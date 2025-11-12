<!-- #include file = "../include/set_loginfo.asp" -->
<!-- #include file = "../include/dbcon.asp" -->
<% if isUsr then
Dim bycode,bycode1			''강좌 일련번호 배열
Dim buygbn			''단과,과정 구분	1:과정,2:단과
Dim paytype			''결제방식
Dim moneyHap	''부가세 포함 결제금액
Dim cnumber,cprice,rs,i,payTitle1,order_id,bycount

Dim payTitle,usrnm,bankinfo,send_price
payTitle = Request.Form("payTitle")
usrnm = Request.Form("usrnm")
bankinfo = Request.Form("bankinfo")
moneyHap = Request.Form("moneyHap")
cnumber = Request.Form("cnumber")
cprice = Request.Form("cprice")
send_price = Request.Form("send_price")

If Len(send_price) = 0 Then send_price = 0

order_id = Left(session.sessionID,4) & Right(year(date),2) & month(date) & day(date) & hour(time) & minute(time) & second(time)

Dim name,tel1,tel2,email,zipcode1,zipcode2,juso1,juso2,memo,b_price

name = Request.Form("name")
tel1 = Request.Form("tel1")
tel2 = Request.Form("tel2")
email = Request.Form("email")
zipcode1 = Request.Form("zipcode1")
zipcode2 = Request.Form("zipcode2")
juso1 = Request.Form("juso1")
juso2 = Request.Form("juso2")
memo = Request.Form("memo")
b_price = Request.Form("b_price")

Dim ordidx
sql = "select isNull(Max(idx),0) + 1 from bank_order"
set dr = db.execute(sql)
ordidx = dr(0)
dr.close

bycode = Request.Form("bycode")
bycode1 = Request.Form("bycode1")
bycount = Request.Form("bycount")

Dim idxAry : idxAry = split(bycode,"|")
Dim idxAry1 : idxAry1 = split(bycode1,"|")
Dim idxAry2 : idxAry2 = split(bycount,"|")

	payTitle1 = ""
	if UBound(idxAry1) > 0 Then	
		payTitle1 =  " + 상품 (" & Ubound(idxAry1) & "개)"
	end If

		If send_price > 0 Then payTitle1 =  " + 배송비 (" & send_price & "원)"

buygbn = Request.Form("paygbn")
paytype = Request.Form("paytype")

Dim tabnm,strnm,clmn
if int(buygbn) > 1 then
	tabnm = "LecturTab"
	strnm = "단과 : "
	clmn = "categbn"
elseif int(buygbn) < 1 then
		tabnm = "PremTab"
		strnm = "프리미엄 : "
		clmn = bycode
else
	tabnm = "Lectmast"
	strnm = "과정 : "
	clmn = "gbn"
end If

Dim huday

sql = "select huday from site_info"
set dr = db.execute(sql)

If dr.eof Or dr.bof Then
	huday = 0
Else
	huday = dr(0)
dr.close
End if


Dim intprice,categbn,tabidx,intgigan

dim tempd,eday,huil

for ii = 0 to UBound(idxAry)

	sql = "select intprice," & clmn & ",intgigan from " & tabnm & " where intprice = 0 and idx=" & idxAry(ii)
	set dr = db.execute(sql)

	If dr.eof Or dr.bof Then

		response.write "<script>"
		response.write "alert('무료강의만 신청이 가능합니다.');"
		response.write "self.location.href='history.back();"
		response.write "</script>"
		response.End
		
	Else
	
		intprice = dr(0)
		categbn = dr(1)
		intgigan = int(dr(2))

	dr.close
	End If
	
	sql = ""

	tempd = Cstr(DateAdd("d",intgigan,date))
	eday = tempd & " " & FormatDateTime(now(),4) & ":00"

	''휴학기간 설정
	''기간이 30 - 60일 과정 : 7일 휴학
	''기간이 61 - 180일 과정 : 15일 휴학
	''기간이 181 이상인 과정 : 30일 휴학 가능

	huil = huday

	sql = "insert into order_mast (id,buygbn,tabidx,categbn,title,paytype,intprice,state,eday,holdil,bankidx,cnumber,cprice,order_id) values ('" & str_User_ID & "'," & buygbn & "," & idxAry(ii) & "," & categbn & ",'" & strnm & "',1," &  intprice & ",0,convert(smalldatetime,'" & eday & "')," & huil & "," & ordidx & ",'"& cnumber &"',"& cprice &",'"& order_id &"')"

	db.execute(sql)

Next

set dr = nothing
db.close
set db = nothing

response.write "<script>"
response.write "alert('무료강의가 등록되었습니다.');"
response.write "self.location.href='../my/01_main.asp';"
response.write "</script>"
response.end

else %>
<!-- #include file = "../include/false_pg.asp" --><% end if %>