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

dim sql,rs,cnum,v_time

cnum = request("key")

if cnum = "" then response.end %>
<!-- #include file = "../include/dbcon.asp" -->
<%
cnum = split(cnum,"|")

			sql = "select count(idx) from save_mast where id = '"& cnum(1) &"' and v_idx = '"& cnum(0) &"'"
			set rs=db.execute(sql)
			
			if rs(0) < 7 then

				sql = "insert into save_mast (id,v_idx,v_time)values"
				sql = sql & "('" & cnum(1) & "'"
				sql = sql & ","& cnum(0)								
				sql = sql & ",'"& cnum(2) &"'"				
				sql = sql & ")"
				db.execute sql,,adexecutenorecords				
				
			end if

	response.write"<select name=chkgal>"
	response.write"<option value=''>미선택</option>"
	sql = "select v_time from save_mast where id = '"& cnum(1) &"' and v_idx = '"& cnum(0) &"'"
	set rs = db.execute(sql)
	if rs.eof or rs.bof then
	else
	i=1
	do until rs.eof
	response.write"<option value="& rs(0) &">"& i &"번("& rs(0) &")</option>"
	rs.movenext
	i=i+1
	loop
	rs.close
	end if
	response.write"</select>" 			
		
%>