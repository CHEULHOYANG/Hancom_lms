<% Session.CodePage = 65001
Response.CharSet = "utf-8"
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

Call sql_CheckInj

in_ca = Int(request("idx"))

If Len(in_ca) = 0 Then response.End
%>
<!-- #include file = "../include/dbcon.asp" -->
        	<div class="cltit" >
                <h3>추천강좌</h3>
            </div>
            <div class="ingi_list">
<%
sql = "select top 4 idx,strnm,strteach,intprice,totalnum,sjin=case sajin when 'noimg.gif' then 'noimage.gif' else sajin end,intgigan,tinfo,icon,book_idx,sub_title from LecturTab where ca1 = "& in_ca &" and inginum > 0 order by inginum desc"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
i = 1
Do Until rs.eof
%>
            	<div class="ingi_box" style="background:url(/ahdma/studimg/<%=rs(5)%>) no-repeat center">
                	<a href="/study/dan_view.asp?dntGbn=<%=in_ca%>&idx=<%=rs(0)%>">
                        <span class="num"><%=i%></span>
                        <div class="ingi_txt">
                                    <strong><%=rs(1)%></strong>
                                    <%=rs(10)%>
						</div>
                    </a></div>
<%
rs.movenext
i = i + 1
Loop
rs.close
End if
%>
            </div>