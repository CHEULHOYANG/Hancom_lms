<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim aid,pwd,sql,dr,isnCount,manage

	aid = TextChk(Request("id"))
	pwd = TextChk(Request("pwd"))
	manage = ", "& request("manage") &","

	sql = "select Count(idx) from admin_mast where id='" & aid & "'"
	Set Dr = db.execute(sql)

	if int(Dr(0)) > 0 then
		isnCount = False
	else
		isnCount = True
	end if
	Dr.close
	Set Dr = Nothing

	if isnCount then
		sql = "insert into admin_mast (id,pwd,manage) values ('" & aid & "','" & pwd & "','"& manage &"')"
	else
		sql = "update admin_mast set pwd = '" & pwd & "',manage = '" & manage & "' where id='" & aid & "'"
	end if

	db.execute(sql)
	db.close
	Set db = Nothing

	Function TextChk(strClmn)
		TextChk = Replace(strClmn,"'","''")
		TextChk = Replace(strClmn,"<","&lt;")
		TextChk = Replace(strClmn,">","&gt;")
	End Function

	Response.Redirect "admin_list.asp"
%>
<!-- #include file = "../authpg_2.asp" -->