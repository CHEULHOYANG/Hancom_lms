<?xml version="1.0" encoding="euc-kr"?><%  Response.ContentType = "text/xml" %>
<!DOCTYPE RootXml[
<!ELEMENT RootXml (isrows*)>
	<!ELEMENT isrows ANY>
	<!ATTLIST isrows
	flg CDATA #REQUIRED
	eregbn CDATA #REQUIRED>
]><% Dim key,errgbn,remsg
key = Request.Form("key")
errgbn = 0 %>
<RootXml><% if Not key = "" then
	key = Replace(key,"'","")
	key = Replace(key,"--","")

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

			dim sql,cnt
			sql = "select count(idx) from order_mast where id='" & str_User_ID & "' and buygbn=0 and state=0 and eday > convert(smalldatetime,getdate())"
			set dr = db.execute(sql)
			cnt = dr(0)
			dr.close

			if int(cnt) > 0 then
				errgbn = 1
				remsg = "false"
			else

				sql = "select count(idx) from order_mast where buygbn=1 and id='" & str_User_ID & "' and state=0 and eday > convert(smalldatetime,getdate()) and tabidx=" & key
				set dr = db.execute(sql)

				if int(dr(0)) > 0 then
						remsg = "false"
						errgbn = 2
				else
					Session("buySection") = key
					remsg = "true"
					errgbn = 3
				end if
				dr.close

			end if

			set dr = nothing
			db.close
			set db = Nothing

			''구매 End****************************************************

		else
			remsg = "false"
		end if
	end if

''로그인체크***************************************************** %>
	<isrows flg="<%=remsg%>" errgbn="<%=errgbn%>" /><% end if %>
</RootXml>