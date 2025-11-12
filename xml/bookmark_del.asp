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
cnum = split(cnum,"^^")

sql = "delete from bookmark_mast where id = '"& cnum(0) &"' and idx = "& cnum(1)
db.execute(Sql)

sql = "select vtime,idx from bookmark_mast where v_idx = "& cnum(2) &" and id = '"& cnum(0) &"'"
set rs=db.execute(Sql)

if rs.eof or rs.bof then
else
i=1
do until rs.eof

v1 = rs(0) 
h = (int)(v1 / 3600)
if len(h) = 1 then	h = "0"& h &""
v1 = v1 mod 3600
m = (int)(v1 / 60)

if len(m) = 1 then	m = "0"& m &""
s = v1 mod 60  

if len(s) = 1 then	s = "0"& s &""
%>                                          
<li><span onclick="forward(<%=rs(0)%>);" style="cursor:pointer"><%=h%>:<%=m%>:<%=s%></span><a href="javascript:bookmark_del(<%=rs(1)%>);" class="mbg btn_del">삭제하기</a></li>
<%
rs.movenext
i=i+1
loop
rs.close
end if
%>      