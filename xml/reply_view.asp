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

idx = request("idx")

if idx = "" then response.end %>
<!-- #include file = "../include/dbcon.asp" -->
<%
sql = "select content,(select strnm from LecturTab where idx=A.vidx) from lec_reply A where idx = "& idx
set rs=db.execute(sql)

if rs.eof or rs.bof then
	response.write"<script>"
	response.write"alert('DB오류');"
	response.write"self.close();"
	response.write"</script>"
	response.end
else
	
	content	= rs(0)
	content=replace(content,chr(13) & chr(10),"<br>")
	title= rs(1)	
	rs.close
end if
%>

</head>
<body>
<div class="laypop">
	<div class="lay_tit">
		<h2><font color='#ff6633'><%=title%></h2>
	</div>
	<div class="lay_cont"><%=content%></div>
</div>