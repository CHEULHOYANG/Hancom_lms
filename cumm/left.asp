	<div class="nlnbWrap">
		<h2><%=t_menu6%></h2>
		<div class="nlnb">
			<dl>
				<dt><a href="/cumm/list.asp">커뮤니티</a></dt>
				<dd><%
sql = "select idx,jemok from board_mast where ygbn > 1 order by ordnum asc,idx desc"
set dr = db.execute(sql)
if not dr.bof or not dr.eof then
do until dr.eof 
%><a href="/cumm/list.asp?tabnm=<%=dr(0)%>"><%=dr(1)%></a><%
dr.movenext
Loop
else 
end if
dr.close		  
%></dd>
			</dl>
			<dl>
				<dt><a href="/jalyo/list.asp">자료실</a></dt>
				<dd><%
sql = "select idx,jemok from board_mast where ygbn = 1 order by ordnum asc,idx desc"
set dr = db.execute(sql)
if not dr.bof or not dr.eof then
do until dr.eof 
%><a href="/jalyo/list.asp?tabnm=<%=dr(0)%>"><%=dr(1)%></a><%
dr.movenext
Loop
else 
end if
dr.close		  
%></dd>
			</dl>
		</div>

        <!-- #include file="../include/left2.asp" -->

<!--  배너시작   -->
	<div style="text-align:center;">
	<% 
	sql = "select banner,banner_url,filegbn,target from banner where areagbn='044' order by  ordnum asc , idx desc"
	set dr = db.execute(sql)
	if not dr.bof or not dr.eof then
	do until dr.eof 
	response.write ""& BannerOutput(dr(0),dr(1),dr(2),200,dr(3)) &"<br /><br />"
	dr.movenext
	Loop
	end if
	dr.close %>					
	</div>
<!--  배너끝  -->

	</div>