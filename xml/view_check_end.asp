<% Session.CodePage = 949
Response.CharSet = "euc-kr"
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "Expires","0"
''********************************************************************************************************************************************************
Sub sql_CheckInj

	Dim sql_injdata
	sql_injdata = "'|xp_cmdshell|exec|insert|select|delete|drop|backup|update|count|*|%|chr|mid|truncate|char|declare|sysobject|;|--|create"
	sql_injdata = sql_injdata & "|information_schema.tables|xp_|sp_|dtproperties|syscolumns|syscomments|sysdepends|sysfilegroups|sysfiles|sysfiles1"
	sql_injdata = sql_injdata & "|sysforeignkeys|sysfulltextcatalogs|sysfulltextnotify|sysindexes|sysindexkeys|sysmembers|sysobjects|syspermissions"
	sql_injdata = sql_injdata & "|sysproperties|sysprotects|sysreferences|systypes|sysusers|master.dbo.|master..|union|'or''='|'or1=1;--|<script|<object|<iframe|varchar(|exec("

	Dim sql_inj			: sql_inj = Split(sql_injdata,"|")
	Dim sql_get
	Dim sql_data
	if Not Request.Form = "" then
		For Each sql_get In Request.Form
			for sql_data = 0 to UBound(sql_inj)
				if instr(1,Request.Form(sql_get),sql_inj(sql_data), vbTextCompare) > 0 then Response.End
			Next
		Next
	elseif Not Request.QueryString = "" then
		for Each sql_get in Request.QueryString
			for sql_data = 0 to UBound(sql_inj)
				if instr(1,Request.QueryString(sql_get),sql_inj(sql_data), vbTextCompare) > 0 then Response.End
			Next
		Next
	end if
End Sub

Call sql_CheckInj	''sql 인젝션 처리

dim sql,rs,cnum,v_time,check_t

cnum = request("key")

if cnum = "" then response.end %>
<!-- #include file = "../include/dbcon.asp" -->
<%
cnum = split(cnum,"|")

sql = "select strtime from SectionTab where idx=" & cnum(0)
set rs = db.execute(sql)

If rs.eof Or rs.bof Then

	check_time1 = 0

Else

	check_time  = split(rs(0),":")
	check_time1 = (int(check_time(0)) * 60) + int(check_time(1))

rs.close
End If

sql = "select top 1 idx,v_time from view_mast where end_check = 0 and id='" & cnum(1) & "' and v_idx = "& cnum(0) &" and order_mast_idx="& cnum(3) &" order by idx desc"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
else

		If Int(rs(1)) >= Int(check_time1) Then

			db.execute("update view_mast set end_check = 1,v_time="& check_time1 &" where idx = "& rs(0) &" ")

			Response.write "1"
			Response.End
				
		End If

End if	
%>