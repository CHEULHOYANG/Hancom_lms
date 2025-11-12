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

key = Request("key")
keygbn = Request("keygbn")

if key = ""  or keygbn = "" then response.end %>
<!-- #include file = "../../include/dbcon.asp" -->
<select name="tabidx" id="tabidx" style="width:290px;" class='seltxt'>
<option value="0">선택</option>
<%
	select case int(keygbn)
		case 2
			sql = sql & "select idx,strnm from Lectmast where gbn=" & key & " order by ordn"
		case 3
			sql = sql & "select idx,strnm from LecturTab where ca1=" & key & " order by strnm"
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