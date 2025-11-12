<!-- #include file="../include/set_loginfo.asp" -->
<% if isUsr then %>
<!-- #include file="../include/dbcon.asp" -->
<%
dim sdate,edate,SearchPart,SearchStr,rs1
dim search_check1,search_check2,search_check3,search_check4,search_check5,search_check6,search_check7
dim price,gu,g_title,regdate
dim page,recordcount,pagecount,totalpage,i,blockpage,pagesize
dim gu_price1,gu_price2,id,rest_price,rs,sp6,sp1,t_price1,t_price2,idx,user_mileage,Index

sql = "select mileage from member where id = '"& str_User_ID &"'"
Set rs = db.execute(sql)

user_mileage = rs(0)
rs.close

if request("page")="" then
   page=1
   else 
   page=request("page")
end if

pagesize=20

sdate = request("sdate")
if len(sdate) = 0 then 	sdate = date()
edate = request("edate")
if len(edate) = 0 then 	edate = date()

sql = "select count(idx) as reccount from mileage where id = '"& str_User_ID &"' and (regdate between convert(smalldatetime,'" & sdate & " 00:00')" & " and convert(smalldatetime,'" & edate & " 23:59'))"
set rs=db.execute(sql)
recordcount =rs(0)
pagecount=int((recordcount-1)/pagesize)+1
sql = "SELECT top " & pagesize & " price,gu,g_title,regdate,id,idx FROM mileage where id = '"& str_User_ID &"' and (regdate between convert(smalldatetime,'" & sdate & " 00:00')" & " and convert(smalldatetime,'" & edate & " 23:59')) and idx not in"
sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from mileage where id = '"& str_User_ID &"' and (regdate between convert(smalldatetime,'" & sdate & " 00:00')" & " and convert(smalldatetime,'" & edate & " 23:59')) order by idx desc)order by idx desc"
set rs=db.execute(sql)

%>
<!-- #include file="../include/head1.asp" -->
<!-- #include file="../include/top.asp" -->

<div class="smain">    
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3>적립금내역</h3>
			회원님의 적립금 : <%=FormatNumber(user_mileage,0)%>원
        </div>
        <div class="scont">
<form name="sform" method="post">
		<p style="margin:0 5px 5px 0px"><input class="sdate inptxt1 w80" id="sdate" value="<%=sdate%>" name="sdate" readonly /> ~ <input class="edate inptxt1 w80" id="edate" value="<%=edate%>" name="edate" readonly  />&nbsp;<a href="javascript:document.sform.submit();" class="fbtn">검색</a></p>
</form>
			<table class="btbl mb80" style="width:830px">
					<colgroup>
						<col style="width:8%" />
						<col style="width:50%" />
						<col style="width:14%" />
						<col style="width:14%" />
						<col style="width:14%" />
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>								
							<th>상세내역</th>
							<th>적립(+)</th>
							<th>사용(-)</th>
							<th>사용일시</th>							
						</tr>				
					</thead>
					<tbody>
<%
if rs.eof or rs.bof Then
else
t_price1 = 0
t_price2 = 0

Index = (pagesize + recordcount) - (page * pagesize) + 1		
do until rs.eof
Index = Index - 1

price=rs(0)
gu=rs(1)
if gu=1 then
gu_price1=price
gu_price2=0
elseif gu=2 then
gu_price1=0
gu_price2=price
end if
g_title=rs(2)
regdate=rs(3)
id=rs(4)
idx = rs(5)
%>
				<tr>
					<td><%=Index%></td>
					<td class="tl"><%=g_title%></td>					
					<td><font color="#993333"><%=formatnumber(gu_price2,0)%>원</font></td>
					<td><font color="#663366"><%=formatnumber(gu_price1,0)%>원</font></td>		
					<td><%=replace(formatdatetime(regdate,2),"-",".")%></td>	
				</tr>
<%
rs.movenext
t_price1 = t_price1 + gu_price2
t_price2 = t_price2 + gu_price1
Loop
rs.close
end if
%>
					</tbody>
				</table>

<%if recordcount > 0 then%>
		<div class="paging">
<%
blockPage=Int((page-1)/10)*10+1
if blockPage = 1 Then
Else
%>	
			<a href="?page=<%=blockPage%>&sdate=<%=request("sdate")%>&edate=<%=request("edate")%>"><img src="../img/img/a_prev1.gif" alt="이전페이지"></a>
<%
End If
   i=1
   Do Until i > 10 or blockPage > pagecount
      If blockPage=int(page) Then
%>
			<strong><%=blockPage%></strong>
<%	else	%>
			<a href="?page=<%=blockPage%>&sdate=<%=request("sdate")%>&edate=<%=request("edate")%>" class="pnum"><%=blockPage%></a>
<%
    End If    
    blockPage=blockPage+1
    i = i + 1
    Loop
if blockPage > pagecount Then
Else
%>
			<a href="?page=<%=blockPage%>&sdate=<%=request("sdate")%>&edate=<%=request("edate")%>"><img src="../img/img/a_next1.gif" alt="다음페이지"></a>
<%
End If
%>
		</div>		
<%End if%>

        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" -->

<link rel="stylesheet" href="../include/pikaday.css">
<script src="../include/moment.js"></script>
<script src="../include/pikaday.js"></script>

<script>
    var picker = new Pikaday(
    {
        field: document.getElementById('sdate'),
        firstDay: 1,
		format: "YYYY-MM-DD",
        minDate: new Date('<%=left(date(),4)-10%>-01-01'),
        maxDate: new Date('<%=left(date(),4)+10%>-12-31'),
        yearRange: [<%=left(date(),4)-10%>,<%=left(date(),4)+10%>]
    });
    var picker1 = new Pikaday(
    {
        field: document.getElementById('edate'),
        firstDay: 1,
		format: "YYYY-MM-DD",
        minDate: new Date('<%=left(date(),4)-10%>-01-01'),
        maxDate: new Date('<%=left(date(),4)+10%>-12-31'),
        yearRange: [<%=left(date(),4)-10%>,<%=left(date(),4)+10%>]
    });
</script>
<% else %><!-- #include file = "../include/false_pg.asp" -->
<% end if %>