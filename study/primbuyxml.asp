<?xml version="1.0" encoding="euc-kr"?><%  Response.ContentType = "text/xml" %>
<!DOCTYPE RootXml[
	<!ELEMENT isrows ANY>
	<!ATTLIST isrows
	flg CDATA #REQUIRED
	bygbn CDATA #REQUIRED>
]><%
Dim key,bygbn
key = Request.Form("key")
bygbn = 0

Dim remsg

if key = "" then

	remsg = "false"

else


''로그인체크*****************************************************

	Dim str_Cookies_Ary
	Dim str_User_ID

	if Replace(Request.Cookies("userInfo")," ","") = "" then
		remsg = "false"
	else
		str_Cookies_Ary = Split(Request.Cookies("userInfo"),",")
		if UBOund(str_Cookies_Ary) = 3 then
			str_User_ID =  str_Cookies_Ary(0) %><!-- #include file = "../include/dbcon.asp" --><%

			''구매 시작****************************************************
			
			db.execute("delete order_mast where state=3 and id='" & str_User_ID & "'")

			dim sql,cnt
			sql = "select count(idx) from order_mast where id='" & str_User_ID & "' and buygbn=0 and state=0 and eday > convert(smalldatetime,getdate())"
			set dr = db.execute(sql)
			cnt = dr(0)
			dr.close

			if int(cnt) > 0 then
				bygbn = 1
			else
				Session("buySection") = key
				bygbn = 2
			end if

			remsg = "true"

			set dr = nothing
			db.close
			set db = Nothing

			''구매 End****************************************************

		else
			remsg = "false"
		end if
	end if

''로그인체크*****************************************************

end if %>
<RootXml>
	<isrows flg="<%=remsg%>" bygbn="<%=bygbn%>" />
</RootXml>