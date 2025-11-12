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

id = request("id")

if id = "" then response.end %>
<!-- #include file = "../include/dbcon.asp" -->
<style>
@charset "utf-8";@import url(http://fonts.googleapis.com/earlyaccess/nanumgothic.css);
body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,form,fieldset,p,button,select{margin:0;padding:0}
img,fieldset{border:0;vertical-align:middle}

ul,ol,li,dl{list-style:none}
input,select,textarea{vertical-align:middle;margin:0;padding:0;font-size:13px;font-family:'Nanum Gothic'}
table caption{display:none}
table{border-collapse:collapse}
em{font-style:normal}
h1,h2,h3{letter-spacing:-1px}

body{margin:0;padding:0;font-family:'Nanum Gothic',gulim,dotum;color:#696969;font-size:13px;line-height:18px;background:url(../img/img/pop_bg.png)}

A:link{text-decoration:none;color:#474747}
A:hover{text-decoration:none;color:#272c3a}
A:visited{text-decoration:none;color:#474747}
A:active{text-decoration:none;color:#474747}

/*   POP layout   */
.laypop{width:720px;border-radius:10px;background:#fff}
.lay_tit{padding:18px 32px;position:relative;border-bottom:1px solid #d4d4d4;box-shadow:-1px 3px 2px -3px #ccc}
.lay_tit h2{font-size:21px;color:#101010;line-height:1.3}
.btn_close{display:block;position:absolute;right:25px;top:18px}


.lay_cont{padding:24px 32px}
.ptbl{border-top:1px solid #555;font-size:13px;line-height:20px;margin:0 0 14px}
.ptbl th{padding:10px 0;color:#111;background:#fafbfc;text-align:center;border-bottom:1px solid #ddd}
.ptbl td{border-bottom:1px solid #ddd;color:#555;padding:10px 0px;height:32px;line-height:32px;text-align:center}

</style>
<%
sql = "select count(idx) from user_ip_check where gu = 0 and uid='"& request("id") &"' "
set rs=db.execute(Sql)

total_count = rs(0)
rs.close
%>
<div class="laypop">
	<div class="lay_tit">
		<h2>상세정보 (<%=total_count%>건)</h2>
		<a href="javascript:view_rank_close();" class="btn_close"><img src="../rad_img/img/btn_close.png" alt="창닫기" /></a>
	</div>
	<div class="lay_cont">
		<table class="ptbl" style="width:656px">
			<colgroup>
			<col style="width:20%" />
			<col style="width:40%" />
			<col style="width:40%" />
			</colgroup>
			<tbody>
				<tr>
					<th>번호</th>
					<th>아이피</th>
					<th>접속시간</th>
				</tr>
<%
sql = "select ip,uid,uname,regdate from user_ip_check where gu = 0 and uid='"& request("id") &"' order by idx desc"
set rs=db.execute(Sql)

if rs.eof or rs.bof then
Else
i = 1
do until rs.eof
%>
<tr>
	<td><%=i%></td>
	<td><%=rs(0)%></td>
	<td><%=right(FormatDateTime(rs(3),2),10)%>&nbsp;<%=FormatDateTime(rs(3),4)%></td>
</tr>
<%
rs.movenext
i=i+1
loop
rs.close
end if
%>		
			</tbody>
		</table>
	</div>		
</div>