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
<!-- #include file = "../include/dbcon.asp" -->
<%
	keyAry = split(key,"|")
	ordgbn = keyAry(0)
	sidx = keyAry(1)
	oldnum = keyAry(2)
	lidx = keyAry(3)


	if int(ordgbn) > 1 then	

		nwnum = int(oldnum) + 1
		sql = "update sectionTab set ordnum=ordnum - 1 where l_idx=" & lidx & " and ordnum=" & nwnum

	else

		nwnum = int(oldnum) - 1
		sql = "update sectionTab set ordnum=ordnum + 1 where l_idx=" & lidx & " and ordnum=" & nwnum

	end If


	db.execute(sql)

	sql = "update sectionTab set ordnum=" & nwnum & " where idx=" & sidx
	db.execute(sql)

	sql ="select idx,strnm,ordnum,strtime,lecsum,lecsrc,freegbn from sectionTab where l_idx=" & lidx & " order by ordnum"
	set dr = db.execute(sql)

	Dim isRecod,isRows,isCols,ii,maxCnt
	maxCnt = 0
	if not dr.bof or not dr.eof then
		isRecod = True
		isRows = split(dr.GetString(2),chr(13))
		maxCnt = UBound(isRows)
	end if
	dr.close
	set dr = nothing
	db.close
	set db = nothing

%>
<%if isRecod Then %>
<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:5%" />
			<col style="width:8%" />
			<col style="width:8%" />
			<col />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th><img src="../rad_img/noncheck.gif" style="cursor:pointer;" onClick="AllCheck(this,document.all.secidx);"></th>	
					<th>정렬</th>
					<th>회차</th>
					<th>제목</th>
					<th>강의시간</th>
					<th>강의요점</th>
					<th>강의소스</th>
					<th>샘플</th>
				</tr>				
			</thead>
			<tbody>
<% 
for ii = 0 to UBound(isRows) - 1
isCols = split(isRows(ii),chr(9))
%>
						<tr>
							<td><input type="checkbox" name="secidx" value="<%=isCols(0)%>"></td>
							<td><img src="../rad_img/a_up.gif" style="cursor:pointer;" onClick="setOrder('up','<%=isCols(0)%>',<%=isCols(2)%>,'<%=maxCnt%>','<%=lidx%>');">
							<img src="../rad_img/a_down.gif" style="cursor:pointer;" onClick="setOrder('dwn','<%=isCols(0)%>',<%=isCols(2)%>,'<%=maxCnt%>','<%=lidx%>');"></td>
							<td><%=isCols(2)%>회</td>
							<td class="tl"><span style="cursor:pointer;color:#585858;" onMouseOver="this.style.color='#FF6600';" onMouseOut="this.style.color='#585858';" onClick="go2SecNyong('<%=isCols(0)%>');"><%=isCols(1)%></span><% if isCols(6) = "1" then %> <font color="#0000CC">[샘플]</font> <% end if %></td>
							<td><%=isCols(3)%></td>
							<td><% if isCols(4) = "" then %>
							-<% else%>
							<a href="<%=isCols(4)%>"><img src="../rad_img/file.gif" border="0"></a><% end if %>							</td>
							<td><% if isCols(5) = "" then %>
							-<% else %>
							<a href="<%=isCols(5)%>"><img src="../ad_img/file.gif" border="0"></a><% end if %>							</td>
							<td><input type="checkbox"<% if isCols(6) = "1" then response.write " checked" %> value="<%=isCols(0)%>" onClick="setFreeMove(this,'<%=lidx%>');"></td>
						</tr>
<% Next %>
			</tbody>
		</table>
<%End if%>