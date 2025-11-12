<?xml version="1.0" encoding="euc-kr"?><%  Response.ContentType = "text/xml" %>
<!DOCTYPE RootXml[
<!ELEMENT RootXml (isrows*)>
	<!ELEMENT isrows ANY>
	<!ATTLIST isrows
	flg CDATA #REQUIRED
	eregbn CDATA #REQUIRED>
]><% Dim key,keygbn,bygbn,remsg
key = Request.Form("key")
key1 = Request.Form("key1")
bygbn = 0 %>
<RootXml><% if Len(key) > 0 or Len(key1) > 0 then
	key = Replace(key,"'","")
	key = Replace(key,",,",",")
	key = Replace(key,"--","")

	key1 = Replace(key1,"'","")
	key1 = Replace(key1,",,",",")
	key1 = Replace(key1,"--","")

	''로그인체크*****************************************************

	Dim str_Cookies_Ary
	Dim str_User_ID

	if Replace(Request.Cookies("userInfo")," ","") = "" then
		remsg = "true"
	else
		str_Cookies_Ary = Split(Request.Cookies("userInfo"),",")
		if UBOund(str_Cookies_Ary) = 3 then
			str_User_ID =  str_Cookies_Ary(0) %><!-- #include file = "../include/dbcon.asp" --><%

			''구매 시작****************************************************
			


			keygbn = split(key,",")
			keygbn1 = split(key1,",")

			dim sql,ii,cnt
			sql = "select count(idx) from order_mast where id='" & str_User_ID & "' and buygbn=0 and state=0 and eday > convert(smalldatetime,getdate())"
			set dr = db.execute(sql)
			cnt = dr(0)
			dr.close

			if int(cnt) > 0 then
				bygbn = 1
			else

				dim cntn,cntn1
				for ii = 0 to UBound(keygbn) - 1

					sql = "select count(idx) from order_mast where buygbn=2 and id='" & str_User_ID & "' and bookidx=0 and state=0 and eday > convert(smalldatetime,getdate()) and tabidx=" & keygbn(ii)
					set dr = db.execute(sql)

					if int(dr(0)) > 0 then
						cntn = cntn & keygbn(ii) & ",0|"
					else
						cntn = cntn & keygbn(ii) & ",1|"
					end If

				Next

				cntn = cntn & "*"
				cntn = replace(cntn,"|*","")

				Session("buySection") = cntn				

			end If




			remsg = "false"

			set dr = nothing
			db.close
			set db = Nothing

			''구매 End****************************************************

				for ii = 0 to UBound(keygbn1) - 1
					cntn1 = cntn1 & keygbn1(ii) & ",1|"
				Next			

				cntn1 = cntn1 & "*"
				cntn1 = replace(cntn1,"|*","")

				Session("buySection1") = cntn1

				else
					remsg = "true"
				end if
			end if

		''로그인체크***************************************************** %>
	<isrows flg="<%=remsg%>" errgbn="<%=bygbn%>" /><% end if %>
</RootXml>