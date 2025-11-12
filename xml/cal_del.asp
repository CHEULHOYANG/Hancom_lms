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

Call sql_CheckInj	''sql 인젝션 처리

dim sql,rs,cnum,v_time

cnum = request("key")

if cnum = "" then response.end %>
<!-- #include file = "../include/dbcon.asp" -->
<%
cnum = split(cnum,"|")


sql = "delete from cal_gu_mast where idx = '"& cnum(1) &"' and sid = '"& cnum(0) &"'"
db.execute sql,,adexecutenorecords

%>
<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:15%" />
			<col />
			<col style="width:20%" />
			<col style="width:20%" />
			<col style="width:15%" />
			</colgroup>
			<thead>
				<tr>
					<th>정렬</th>	
					<th>분류명</th>
					<th>바탕컬러</th>
					<th>글자컬러</th>	
					<th>기능</th>								
				</tr>				
			</thead>
			<tbody>
<form name="form" method="post">	
				<tr>
					<td>분류추가</td>
					<td><input name="title" type="text" class="inptxt1" id="title" size="40"></td>
					<td><input name="bg_color" type="text" class="inptxt1 w100" id="bg_color" size="7" >&nbsp;<a href="#" onClick="javascript:window.open('color1.asp?fname=form','color','width=400,height=350,menubar=no,scrollbars=no');" class="btns trans">색상표</a></td>
					<td><input name="font_color" type="text" class="inptxt1 w100" id="font_color" size="7" >&nbsp;<a href="#" onClick="javascript:window.open('color2.asp?fname=form','color','width=400,height=350,menubar=no,scrollbars=no');"  class="btns trans">색상표</a></td>
					<td><a href="javascript:cal_gu_mast();" class="btns trans">등록</a></td>
				</tr>
</form>

 <%

		sql="select count(idx) from cal_gu_mast where sid = '"& cnum(0) &"'"
		set rs=db.execute(sql)
		
		board_count = rs(0)
		  
		sql="select idx,title,bg_color,font_color from cal_gu_mast where sid = '"& cnum(0) &"' order by ordnum asc,idx desc"
		set rs=db.execute(sql)
		if rs.eof or rs.bof then
		else
		i=1
		do until rs.eof

idx = rs(0)
title = rs(1)
bg_color = rs(2)
font_color = rs(3)
%>
<form name="form<%=idx%>" method="post">	
				<tr>
					<td><%if i > 1 then%><a href="javascript:cal_up('<%=idx%>');"><img src="../rad_img/a_up.gif" width="8" height="8" border="0"></a>&nbsp;<%end if%><%if board_count <> i then%><a href="javascript:cal_down('<%=idx%>');"><img src="../rad_img/a_down.gif" width="8" height="8" border="0"></a><%end if%></td>
					<td><input name="title" type="text" class="inptxt1" id="title" size="40" value="<%=title%>"></td>
					<td><input name="bg_color" type="text" class="inptxt1 w100" id="bg_color" size="7" value="<%=bg_color%>" >&nbsp;<a href="#" onClick="javascript:window.open('color1.asp?fname=form<%=idx%>','color','width=400,height=350,menubar=no,scrollbars=no');" class="btns trans">색상표</a></td>
					<td><input name="font_color" type="text" class="inptxt1 w100" id="font_color" size="7" value="<%=font_color%>">&nbsp;<a href="#" onClick="javascript:window.open('color2.asp?fname=form<%=idx%>','color','width=400,height=350,menubar=no,scrollbars=no');"  class="btns trans">색상표</a></td>
					<td><a href="javascript:cal_edit('<%=idx%>');" class="btns trans">수정</a>&nbsp;<a href="javascript:cal_del('<%=idx%>');" class="btns"
>삭제</a></td>
				</tr>
</form>
<%           
		rs.movenext
		i=i+1
		loop
		rs.close
		end if
%>

			</tbody>
		</table>