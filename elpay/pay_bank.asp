<!-- #include file = "../include/set_loginfo.asp" -->
<!-- #include file = "../include/dbcon.asp" -->
<% if isUsr then
Dim bycode,bycode1			''강좌 일련번호 배열
Dim buygbn			''단과,과정 구분	1:과정,2:단과
Dim paytype			''결제방식
Dim moneyHap	''부가세 포함 결제금액
Dim cnumber,cprice,rs,i,payTitle1,order_id,bycount,cash

Dim payTitle,usrnm,bankinfo,send_price
payTitle = Request.Form("payTitle")
usrnm = Request.Form("usrnm")
bankinfo = Request.Form("bankinfo")
moneyHap = Request.Form("moneyHap")
cnumber = Request.Form("cnumber")
cprice = Request.Form("cprice")
cash = Request.Form("cash")
If Len(cash) = 0 Then cash = 0

send_price = Request.Form("send_price")
If Len(send_price) = 0 Then send_price = 0

order_id = Left(session.sessionID,4) & Right(year(date),2) & month(date) & day(date) & hour(time) & minute(time) & second(time)

Dim name,tel1,tel2,email,zipcode1,zipcode2,juso1,juso2,memo,b_price

If int(cash) > 0 then

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

''bank_order inSert
Dim ordidx
sql = "select isNull(Max(idx),0) + 1 from bank_order"
set dr = db.execute(sql)
ordidx = dr(0)
dr.close

usrnm = Replace(usrnm,"'","''")
usrnm = Replace(usrnm,"<","&lt;")
usrnm = Replace(usrnm,">","&gt;")

Dim reply,reply_count

reply = split(cnumber,",")
reply_count = ubound(reply)

For i = 1 To reply_count

	sql = "select count(idx) from coupon_price_mast where state=0 and cnumber = '"& reply(i) &"'"
	Set rs=db.execute(sql)

	If rs(0) = 1 then
	Else
		Response.write"<script>"
		Response.write"alert('적용하신 쿠폰에 문제가 발생했습니다. 다시 결제해주세요!!');"
		Response.write"opener.history.back();"
		Response.write"self.close();"
		Response.write"</script>"
		Response.End

	rs.close
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

If moneyHap > 0 then

		sql = "insert into bank_order (idx,usrnm,usrid,paytitle,bkinfo,nprice,order_id) values (" & ordidx & ",'" & usrnm & "','" & str_User_ID & "','" & payTitle & payTitle1 & "','" & bankinfo & "'," & moneyHap & ",'"& order_id &"')"
		db.execute(sql)

End if

buygbn = Request.Form("buygbn")
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
end if

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

	sql = "select intprice," & clmn & ",intgigan from " & tabnm & " where idx=" & idxAry(ii)
	set dr = db.execute(sql)
	intprice = dr(0)
	categbn = dr(1)
	intgigan = int(dr(2))
	dr.close
	sql = ""

	tempd = Cstr(DateAdd("d",intgigan,date))
	eday = tempd & " " & FormatDateTime(now(),4) & ":00"

	''휴학기간 설정
	''기간이 30 - 60일 과정 : 7일 휴학
	''기간이 61 - 180일 과정 : 15일 휴학
	''기간이 181 이상인 과정 : 30일 휴학 가능

	huil = huday


	sql = "insert into order_mast (id,buygbn,tabidx,categbn,title,paytype,intprice,state,eday,holdil,bankidx,cnumber,cprice,order_id,cash) values ('" & str_User_ID & "'," & buygbn & "," & idxAry(ii) & "," & categbn & ",'" & strnm & "'," & paytype & "," &  intprice & ",1,convert(smalldatetime,'" & eday & "')," & huil & "," & ordidx & ",'"& cnumber &"',"& cprice &",'"& order_id &"',"& cash &")"
	db.execute(sql)

	If Len(cnumber) > 0 Then	
		cnumber = ""
		cprice = 0
	End If
	
	If cash > 0 Then	cash = 0

	db.execute("delete wish_list where userid='" & str_User_ID & "' and buygbn=" & buygbn & " and tabidx=" & idxAry(ii))
Next

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
		huil = 7

		If Len(idxAry2(ii+1)) = 0 Then 

		sql = "insert into order_mast (id,buygbn,tabidx,categbn,title,paytype,intprice,state,eday,holdil,bankidx,cnumber,cprice,s_name,s_tel1,s_tel2,s_email,s_zipcode1,s_zipcode2,s_juso1,s_juso2,s_memo,bookidx,order_id,send_price,cash) values ('" & str_User_ID & "',3," & idxAry1(ii) & "," & categbn & ",'" & strnm & "'," & paytype & "," &  intprice & ",1,convert(smalldatetime,'" & eday & "')," & huil & "," & ordidx & ",'"& cnumber &"',"& cprice &",'"& name &"','"& tel1 &"','"& tel2 &"','"& email &"','"& zipcode1 &"','"& zipcode2 &"','"& juso1 &"','"& juso2 &"','"& memo &"',1,'"& order_id &"',"& send_price &","& cash &")"
		db.execute(sql)

		Else

		sql = "insert into order_mast (id,buygbn,tabidx,categbn,title,paytype,intprice,state,eday,holdil,bankidx,cnumber,cprice,s_name,s_tel1,s_tel2,s_email,s_zipcode1,s_zipcode2,s_juso1,s_juso2,s_memo,bookidx,order_id,send_price,bcount,cash) values ('" & str_User_ID & "'," & buygbn & "," & idxAry1(ii) & "," & categbn & ",'" & strnm & "'," & paytype & "," &  intprice*idxAry2(ii+1) & ",1,convert(smalldatetime,'" & eday & "')," & huil & "," & ordidx & ",'"& cnumber &"',"& cprice &",'"& name &"','"& tel1 &"','"& tel2 &"','"& email &"','"& zipcode1 &"','"& zipcode2 &"','"& juso1 &"','"& juso2 &"','"& memo &"',1,'"& order_id &"',"& send_price &","& idxAry2(ii+1) &","& cash &")"
		db.execute(sql)

		End If
		
		If send_price > 0 Then send_price = 0
		If cash > 0 Then	cash = 0
		If Len(cnumber) > 0 Then	
			cnumber = ""
			cprice = 0
		End If

Next

If moneyHap = 0 Then

		sql = "update order_mast set state=0 where order_id = '"& order_id &"'"
		db.execute(sql)

		Response.write"<script>"
		Response.write"alert('적립금 결제가 완료되었습니다.');"
		Response.write"opener.location.href='/my/01_main.asp';"
		Response.write"self.close();"
		Response.write"</script>"
		Response.End

Else

	Response.redirect "pay_bank_end.asp?ordidx=" & ordidx
	Response.end

End if

else %>
<!-- #include file = "../include/false_pg.asp" --><% end if %>