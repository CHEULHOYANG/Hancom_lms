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

sql = "select count(idx) from view_mast where end_check = 1 and id = '"& cnum(1) &"' and v_idx = "& cnum(0) &" and gang_idx = "& cnum(4) &""
set rs=db.execute(sql)

end_check = rs(0)
rs.close

If end_check > 0 Then

	response.write "이미종료"
	response.End
	
End if

			sql = "select top 1 v_time,idx from view_mast where id = '"& cnum(1) &"' and v_idx = '"& cnum(0) &"' and v_date = '"& date() &"' and v_sesstion = '"& cnum(2) &"' and v_gu='"& cnum(3) &"' order by v_time desc"
			set rs=db.execute(sql)
			
			if rs.eof or rs.bof then
			else

				db.execute("update view_mast set v_time = '"& check_time1 &"' , end_check = 1 where idx = " & rs(1) &" ")

				response.write "기존종료"
				response.end

				
			rs.close
			end If		
%>