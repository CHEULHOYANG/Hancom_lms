<!-- #include file="../include/set_loginfo.asp" -->
<% if isUsr Then

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function

Dim moneyHap	''결제금액
Dim bycode,bycode1			''강좌일련번호
Dim paygbn			''단과,과정 구분	0:프리미엄,1:과정,2:단과
Dim payType
Dim cnumber,cprice,rs,i

Dim name,tel1,tel2,email,zipcode1,zipcode2,juso1,juso2,memo,b_price,bycount,cash
Dim order_id,send_price,huday



order_id = Left(session.sessionID,4) & Right(year(date),2) & month(date) & day(date) & hour(time) & minute(time) & second(time)

send_price = Request.Form("send_price")
name = Request.Form("name")
tel1 = Request.Form("tel1_1") &"-"& Request.Form("tel1_2") &"-"& Request.Form("tel1_3")
tel2 = Request.Form("tel2_1") &"-"& Request.Form("tel2_2") &"-"& Request.Form("tel2_3")
email = Request.Form("email")
zipcode1 = Request.Form("zipcode1")
zipcode2 = Request.Form("zipcode2")
juso1 = Request.Form("juso1")
juso2 = Request.Form("juso2")
memo = Request.Form("name")
b_price = Request.Form("b_price")

cnumber = Request.Form("cnumber")
cprice = Request.Form("cprice")
moneyHap = Request.Form("moneyHap")
bycode = Request.Form("bycode")
bycode1 = Request.Form("bycode1")
bycount = Request.Form("bycount")
paygbn = Request.Form("paygbn")
payType = Request.Form("payType")  

cash = Request.Form("cash")
If Len(cash) = 0 Then cash = 0
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" /><% if not moneyHap = "" and not paygbn = "" and not payType = "" then

Dim Smode,MxIssueNO,CcMode
MxIssueNO = str_User_ID & "_" & svdatefomt

select case int(payType)
	case 2
		Smode = "3001"
		CcMode = "11"
	case 3
		Smode = "6101"
		CcMode = "10"
	case 4
		Smode = "2501"
		CcMode = "10"
end select

CcMode = "11"

Function svdatefomt()
	Dim dt1,dt2,dt3
	dt1 = replace(Date,"-","")
	dt2 = FormatDateTime(now(),4)
	dt3 = second(now)
	dt1 = Right(dt1,8)
	dt2 = replace(dt2,":","")

	if dt3 < 10 then
		dt3 = "0" & dt3
	end if
svdatefomt = dt1 & dt2 & dt3
End Function %><!-- #include file="../include/dbcon.asp" --><%

sql = "select huday from site_info"
set dr = db.execute(sql)

If dr.eof Or dr.bof Then
	huday = 0
Else
	huday = dr(0)
dr.close
End if

If int(cash) > 0 Then

	sql = "select mileage from member where id = '"& str_User_ID &"'"
	Set rs=db.execute(sql)

	If int(rs(0)) >= int(cash) Then

		sql = "Update member set mileage = mileage - "& cash &" where id='"& str_User_ID &"'"
		db.execute sql,,adexecutenorecords

		sql = "insert into mileage (id,gu,price,g_title,otp)values"
		sql = sql & "('" & str_User_ID &"'"
		sql = sql & ",1,"& cash &""
		sql = sql & ",'주문번호 #"& order_id &" 적립금사용'"
		sql = sql & ",''"
		sql = sql & ")"
		db.execute sql,,adexecutenorecords

	Else
		
		Response.write"<script>"
		Response.write"alert('적립금 오류!! 다시 구매를 진행해주세요.');"
		Response.write"self.close();"
		Response.write"</script>"
		Response.End
		
	End if

End if

''먼저 state 가 3인 거 삭제
''db.execute("delete order_mast where state=3")

''미리 거래 정보를 Order_mast에 입력하자
Dim idxAry : idxAry = split(bycode,"|")
Dim idxAry1 : idxAry1 = split(bycode1,"|")
Dim idxAry2 : idxAry2 = split(bycount,"|")

dim payTitle,tabnm,strnm,clmn,payTitle1
if int(paygbn) < 1 Then

	sql = "select strnm,intprice from PremTab where idx=" & bycode
	set dr = db.execute(sql)
	payTitle = dr(0)
	payTitle = Tag2Txt(payTitle)
	moneyHap = dr(1)
	dr.close

	tabnm = "PremTab"
	strnm = "프리미엄 : "
	clmn = bycode

elseif int(paygbn) > 1 Then

	''강좌값이 온다면
	If Len(bycode) > 0 then

		sql = "select strnm from LecturTab where idx=" & idxAry(0)
		set dr = db.execute(sql)
		payTitle = dr(0)
		payTitle = Tag2Txt(payTitle)
		dr.close

		tabnm = "LecturTab"
		strnm = "단과 : "
		clmn = "categbn"

		if UBound(idxAry) > 0 then
			payTitle = payTitle & " 외 " & Ubound(idxAry) & "과목"
		end If
	
	End If

	''교재값이 온다면
	If Len(bycode) = 0 And Len(bycode1) > 0 Then

		sql = "select title from book_mast where idx=" & idxAry1(0)
		set dr = db.execute(sql)
		payTitle = dr(0)
		payTitle = Tag2Txt(payTitle)
		dr.close

		tabnm = "LecturTab"
		strnm = "교재 : "
		clmn = "categbn"

		if UBound(idxAry1) > 0 then
			payTitle = payTitle & " 외 교재" & Ubound(idxAry1) & "개"
		end If
	
	End if	

Else

	sql = "select strnm,intgigan from Lectmast where idx=" & bycode
	set dr = db.execute(sql)
	payTitle = dr(0) & "(" & dr(1) & "일과정)"
	payTitle = Tag2Txt(payTitle)
	dr.close

	tabnm = "Lectmast"
	strnm = "과정 : "
	clmn = "gbn"
end If

Dim reply,reply_count

reply = split(cnumber,",")
reply_count = ubound(reply)

For i = 1 To reply_count

	sql = "select count(idx) from coupon_price_mast where state=0 and cnumber = '"& reply(i) &"'"
	Set rs=db.execute(sql)

	If rs(0) = 1 then
	Else
		response.write"<script>"
		response.write"alert('적용하신 쿠폰에 문제가 발생했습니다. 다시 결제해주세요!!');"
		Response.write"opener.history.back();"
		response.write"self.close();"
		response.write"</script>"
		response.end
	End if

	sql = "select count(idx) from order_mast where charindex(',"& reply(i) &"',cnumber) > 0"
	Set rs=db.execute(sql)

	If rs(0) > 0 Then
	
		Response.write"<script>"
		Response.write"alert('이미 사용중인 쿠폰입니다.');"
		Response.write"opener.history.back();"
		Response.write"self.close();"
		Response.write"</script>"
		Response.End

	rs.close	
	End if

Next



Dim intprice,categbn,tabidx,intgigan,tempd,eday,huil

If Len(bycode) > 0 then

for ii = 0 to UBound(idxAry)

		sql = "select intprice," & clmn & ",intgigan from " & tabnm & " where idx=" & idxAry(ii)
		set dr = db.execute(sql)
		intprice = dr(0)
		categbn = dr(1)
		intgigan = int(dr(2))
		dr.close
		sql = ""

		tempd = Cstr(DateAdd("d",intgigan,date))
		eday = tempd & " " & FormatDateTime(now(),4) & ":00"

		''휴강일
		huil = huday

		sql = "insert into order_mast (id,buygbn,tabidx,categbn,title,paytype,intprice,state,eday,holdil,yy,mm,dd,otp,cnumber,cprice,order_id,cash) values ('" & str_User_ID & "'," & paygbn & "," & idxAry(ii) & "," & categbn & ",'" & strnm & "'," & payType & "," &  intprice & ",3,convert(smalldatetime,'" & eday & "')," & huil & ","
		sql = sql & Year(now) & "," & Month(now) & "," & Day(now) & ",'" & MxIssueNO & "','"& cnumber &"',"& cprice &",'"& order_id &"',"& cash &")"
		db.execute(sql)

		If cash > 0 Then	cash = 0
		If Len(cnumber) > 0 Then	
			cnumber = ""
			cprice = 0
		End If

Next

End If


If Len(bycode1) > 0 Then

''교재등록시작
for ii = 0 to UBound(idxAry1)

		sql = "select price1,title from book_mast where idx=" & idxAry1(ii)
		set dr = db.execute(sql)
		intprice = dr(0)
		categbn = 0
		strnm = dr(1)
		intgigan = 0
		dr.close
		sql = ""

		tempd = Cstr(DateAdd("d",intgigan,date))
		eday = tempd & " " & FormatDateTime(now(),4) & ":00"
		''휴강일
		huil = huday

		If Len(idxAry2(ii+1)) = 0 Then 

				sql = "insert into order_mast (id,buygbn,tabidx,categbn,title,paytype,intprice,state,eday,holdil,yy,mm,dd,otp,cnumber,cprice,s_name,s_tel1,s_tel2,s_email,s_zipcode1,s_zipcode2,s_juso1,s_juso2,s_memo,bookidx,order_id,send_price,cash) values ('" & str_User_ID & "',3," & idxAry1(ii) & "," & categbn & ",'" & strnm & "'," & payType & "," &  intprice & ",3,convert(smalldatetime,'" & eday & "')," & huil & ","
				sql = sql & Year(now) & "," & Month(now) & "," & Day(now) & ",'" & MxIssueNO & "','"& cnumber &"',"& cprice &",'"& name &"','"& tel1 &"','"& tel2 &"','"& email &"','"& zipcode1 &"','"& zipcode2 &"','"& juso1 &"','"& juso2 &"','"& memo &"',1,'"& order_id &"',"& send_price &","& cash &")"
				db.execute(sql)
		Else

				sql = "insert into order_mast (id,buygbn,tabidx,categbn,title,paytype,intprice,state,eday,holdil,yy,mm,dd,otp,cnumber,cprice,s_name,s_tel1,s_tel2,s_email,s_zipcode1,s_zipcode2,s_juso1,s_juso2,s_memo,bookidx,order_id,send_price,bcount,cash) values ('" & str_User_ID & "',3," & idxAry1(ii) & "," & categbn & ",'" & strnm & "'," & payType & "," &  intprice * idxAry2(ii+1) & ",3,convert(smalldatetime,'" & eday & "')," & huil & ","
				sql = sql & Year(now) & "," & Month(now) & "," & Day(now) & ",'" & MxIssueNO & "','"& cnumber &"',"& cprice &",'"& name &"','"& tel1 &"','"& tel2 &"','"& email &"','"& zipcode1 &"','"& zipcode2 &"','"& juso1 &"','"& juso2 &"','"& memo &"',1,'"& order_id &"',"& send_price &","& idxAry2(ii+1) &","& cash &")"
				db.execute(sql)

		End If

		If send_price > 0 Then send_price = 0
		If cash > 0 Then	cash = 0
		If Len(cnumber) > 0 Then	
			cnumber = ""
			cprice = 0
		End If

Next

End if

Dim PID,PhoneNO,Pemail

sql = "select jumin = juminno1 + juminno2,replace(tel2,'-',''),email from member where id='" & str_User_ID & "'"
set dr = db.execute(sql)
PID = dr(0)
PhoneNo = dr(1)
Pemail = dr(2)
dr.close

set dr = nothing
db.close
set db = nothing

dim path_URL : path_URL = request.ServerVariables("HTTP_HOST")
dim ItemInfo : ItemInfo = "1|" & moneyHap & "|1|12S0Hz0000|testcorp"

response.redirect "/allatpay_pc/approval.asp?order_id="& order_id
Response.End

 else 
 end if 
 end if %>