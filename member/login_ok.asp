<!-- #include file = "../include/set_loginfo.asp" -->
<%
if isUsr then
	''로그인 한 상태라면 회원가입 프로세스 stop
	Response.Redirect "../main/index.asp"
	Response.End
end if
%>
<!-- #include file = "../include/refer_check.asp" -->
<!-- #include file="../include/md5.asp"-->
<%
Dim nwpagen : nwpagen = InStr(vReferer,vPage)
''response.write vReferer & "<br>"
''response.write vPage & "<br>"
''response.write nwpagen

Dim pageView
if nwpagen = 1 then
	pageView = True
else
	pageView = False
end if


if pageView then

	Dim usrid,usrpwd,usrnm
	usrid		= strReplace(Request.Form("usrid"))
	usrpwd	= strReplace(Request.Form("usrpwd"))
	str__Page = strReplace(Request.Form("str__Page")) %>
<!-- #include file = "../include/dbcon.asp" --><%


	usrpwd = md5(usrpwd)

	Dim cnt,str_redirect
	sql = "dbo.sp_Login_Usr '" & usrid & "','" & usrpwd & "'"

	set dr = db.execute(sql)
	cnt = dr(0)
	usrnm = dr(1)
	dr.close
	set dr = db.execute(sql)

	if int(cnt) > 0 Then

	dim login_new_ip
	
	login_new_ip = Request.ServerVariables("HTTP_X_FORWARDED_FOR")'클라이언트의 리얼IP받음

	If login_new_ip = "" Then '리얼Ip아닐때 동적IP받음(클라이언트)
	   login_new_ip = Request.ServerVariables("REMOTE_ADDR")
	end if

	sql = "Update member set ins_my = '"& login_new_ip &"',session_value='"& session.sessionID &"' where id='"& usrid &"'"
	db.execute sql,,adexecutenorecords

	''보안을 위해서 로그인 체크한다
	sql = "insert into user_ip_check (uid,uname,gu,ip)values"
	sql = sql & "('" & usrid & "'"
	sql = sql & ",'" & usrnm & "'"
	sql = sql & ",0,'" & login_new_ip & "'"
	sql = sql & ")"
	db.execute sql,,adexecutenorecords
	
	'회원비밀번호오케 아이피1~3까지중에 해당사항이 있는지체크
	'ip_check값이 0이면 통과 1이면 에러

	If login_new_ip = "::1" then	login_new_ip = "120.0.0.1"

	login_new_ip = split(login_new_ip,".")

	dim ip_check
	dim ip1,ip2,ip3,rs

	ip_check = 0

If Len(name_id) > 0 then

	sql = "select isnull(ip1,0),isnull(ip2,0),isnull(ip3,0) from member where id='"& usrid &"'"
	set rs=db.execute(sql)
			
	if rs.eof or rs.bof then
	else
		
		ip1 = rs(0)
		if len(ip1) = 0 then
			ip1 = 0
		end if

		ip2 = rs(1)
		if len(ip2) = 0 then
			ip2 = 0
		end if	

		ip3 = rs(2)
		if len(ip3) = 0 then
			ip3 = 0
		end if	

	rs.close
	end if	

	if ip1 <> "0" then
		
		if ip1 = ""& login_new_ip(0) &"."& login_new_ip(1) &"."& login_new_ip(2) &"" then
			ip_check = 0
		else
			ip_check = 1
		end if
		
	else
		sql = "Update member set ip1 = '"& login_new_ip(0) &"."& login_new_ip(1) &"."& login_new_ip(2) &"' where id='"& usrid &"'"
		db.execute sql,,adexecutenorecords		
		
		ip_check = 0
		
	end If
	
	if ip_check = 1 then
		if ip2 <> "0" Then		
			if ip2 = ""& login_new_ip(0) &"."& login_new_ip(1) &"."& login_new_ip(2) &"" then
				ip_check = 0
			else
				ip_check = 1
			end If			
		else
			if ip1 <> ""& login_new_ip(0) &"."& login_new_ip(1) &"."& login_new_ip(2) &"" and ip2 = 0 then
			
				sql = "Update member set ip2 = '"& login_new_ip(0) &"."& login_new_ip(1) &"."& login_new_ip(2) &"' where id='"& usrid &"'"
				db.execute sql,,adexecutenorecords		
				
				ip_check = 0	
				
			end if				
		end if
	end If
	
	if ip_check = 1 then		
		if ip3 <> "0" then
			if ip3 = ""& login_new_ip(0) &"."& login_new_ip(1) &"."& login_new_ip(2) &"" then
				ip_check = 0
			else
				ip_check = 1
			end if
		else
			if ip1 <> ""& login_new_ip(0) &"."& login_new_ip(1) &"."& login_new_ip(2) &"" and ip2 <> ""& login_new_ip(0) &"."& login_new_ip(1) &"."& login_new_ip(2) &"" and ip3 = 0 then
			
				sql = "Update member set ip3 = '"& login_new_ip(0) &"."& login_new_ip(1) &"."& login_new_ip(2) &"' where id='"& usrid &"'"
				db.execute sql,,adexecutenorecords		
				
				ip_check = 0	
				
			end if
		end if		
	end if

End if

		''정상로그인
		if ip_check = 0 Then

			If int(name_check) > 0 then

				sql = "select count(idx) from mileage where g_title = '로그인 "& name_check &"원 적립' and id = '"& usrid &"' and DateDiff(dd, regdate,getdate()) = 0"
				set rs=db.execute(sql)
				
				if rs(0) = 0 then
				
						sql = "Update member set mileage = mileage + "& name_check &" where id='"& usrid &"'"
						db.execute sql,,adexecutenorecords

						sql = "insert into mileage (id,gu,price,g_title,otp)values"
						sql = sql & "('" & usrid &"'"
						sql = sql & ",2,"& name_check &""
						sql = sql & ",'로그인 "& name_check &"원 적립'"
						sql = sql & ",''"
						sql = sql & ")"
						db.execute sql,,adexecutenorecords

				rs.close
				end If
			
			End if


			if request.form("idsave3") = "Y" then
				response.cookies("idsaved") = "Y"
				response.cookies("idsave_idd") = usrid
				response.cookies("idsave_idd").expires=now()+7
				response.cookies("idsaved").expires=now()+7
			else
				response.cookies("idsaved") = ""
				response.cookies("idsave_idd") = ""
			end if

			Response.Cookies("userInfo") = usrid & "," & usrnm & ",,"
			str_redirect = ".." & str__Page

			response.redirect str_redirect

		Else

			response.write"<script>"
			response.write"alert('아이피이용규정에따라 불가능한 접속입니다.');"
			response.write"self.location.href='login.asp?str__Page=" & str__Page &"';"
			response.write"</script>"
			response.end
		
		End if

	Else

		response.write"<script>"
		response.write"alert('아이디/비밀번호를 확인해주세요.');"
		response.write"self.location.href='login.asp?str__Page=" & str__Page &"';"
		response.write"</script>"
		response.end

	end if

db.close
set db = Nothing

	Function strReplace(strval)
		strval = Replace(strval,"--","")
		strval = Replace(strval,"'","''")
		strReplace = strval
	End Function

else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>