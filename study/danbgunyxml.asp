<?xml version="1.0" encoding="euc-kr"?><%  Response.ContentType = "text/xml" %>
<!DOCTYPE RootXml[
	<!ELEMENT isrows ANY>
	<!ATTLIST isrows
	flg CDATA #REQUIRED
	chkid CDATA #REQUIRED>
]><%
Dim key,key1,keygbn,chkid
key = Request.Form("key")
key1 = Request.Form("key1")
chkid = Request.Form("chkid")

	key = Replace(key,"'","")
	key = Replace(key,",,",",")
	key = Replace(key,"--","")

	key1 = Replace(key1,"'","")
	key1 = Replace(key1,",,",",")
	key1 = Replace(key1,"--","")

Dim remsg

if Len(key) = 0 And Len(key1) = 0 Then 	

	remsg = "true"

else

''로그인체크*****************************************************

	Dim str_Cookies_Ary
	Dim str_User_ID

	if Replace(Request.Cookies("userInfo")," ","") = "" then
		remsg = "true"
	else
		str_Cookies_Ary = Split(Request.Cookies("userInfo"),",")
		if UBOund(str_Cookies_Ary) = 3 then
			str_User_ID =  str_Cookies_Ary(0) %><!-- #include file = "../include/dbcon.asp" --><%

''장바구니 시작****************************************************
dim sql1,ii1,sql,ii,cnt,cnt1,buygbn

keygbn = split(key,",")
buygbn = 2

for ii = 0 to UBound(keygbn) - 1
	sql = "update wish_list set tabidx=" & keygbn(ii) & " where bookidx=0 and userid='" & str_User_ID & "' and buygbn=" & buygbn & " and tabidx=" & keygbn(ii)
	db.execute sql,cnt

	if cnt < 1 then
		db.execute("insert into wish_list (buygbn,tabidx,userid,bookidx) values (" & buygbn & "," & keygbn(ii) & ",'" & str_User_ID & "',0)")
	end if
Next

keygbn1 = split(key1,",")
buygbn = 3

for ii1 = 0 to UBound(keygbn1) - 1
	
		If Len(keygbn1(ii1)) > 0 then
	
			sql1 = "update wish_list set tabidx=" & keygbn1(ii1) & " where bookidx=1 and userid='" & str_User_ID & "' and buygbn=" & buygbn & " and tabidx=" & keygbn1(ii1)
			db.execute sql1,cnt1

			if cnt1 < 1 then
				db.execute("insert into wish_list (buygbn,tabidx,userid,bookidx) values (" & buygbn & "," & keygbn1(ii1) & ",'" & str_User_ID & "',1)")
			end If

		End if

Next

remsg = "false"
db.close
set db = Nothing


''장바구니 End****************************************************

		else
			remsg = "true"
		end if
	end if

''로그인체크*****************************************************

end if %>
<RootXml>
	<isrows flg="<%=remsg%>" chkid="<%=chkid%>" />
</RootXml>