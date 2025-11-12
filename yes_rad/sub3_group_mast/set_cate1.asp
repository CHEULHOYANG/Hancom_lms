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

key = request("key")

if key = "" then response.end %>
<!-- #include file = "../../include/dbcon.asp" -->
<%If Key = 1 then%>
<select name="categbn" id="categbn" style="width:170px;" class='seltxt'>
<%else%>
<select name="categbn" id="categbn" style="width:170px;" class='seltxt' onChange="set_cate2(this.value);">
<%End if%>
<option value="0">선택</option>
<%
	sql = "select "
	select case int(key)
		case 1
			sql = sql & "idx,strnm from premTab order by idx"
		case 2
			sql = sql & "idx,bname from mscate order by ordnum"
		case 3
			sql = sql & "idx,title from dan_category where deep = 0 order by ordnum"
	end select

	set rs=db.execute(sql)

	if rs.eof or rs.bof then
	Else
	do until rs.eof
%>
	<option value="<%=rs(0)%>"><%=rs(1)%></option>
<%
	rs.movenext
	Loop
	rs.close
	end if
%>
</select>