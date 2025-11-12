<% dim menuidx
if inStr(Request.ServerVariables("PATH_INFO"),"page") > 0 then
	if isRecod then
		menuidx = idx
	else
		menuidx = 0
	end if
else
	menuidx = 0
end if  
dim pathAry : pathAry = split(Request.ServerVariables("PATH_INFO"),"/")
dim strFirstn
strFirstn = Left(pathAry(UBound(pathAry)),1)

select case strFirstn
	case "n"
		menuidx = 111
	case "f"
		menuidx = 112
	case "q"
		menuidx = 113
	case "d"
		menuidx = 114
	case "s"
		menuidx = 115
end select %>
	<div class="nlnbWrap">
		<h2><%=t_menu7%></h2>
		<div class="nlnb">
			<dl>
				<dt><a href="/cs/nlist.asp">공지사항</a></dt>
			</dl>
			<dl>
				<dt><a href="/cs/flist.asp">자주묻는질문과답변</a></dt>
			</dl>
			<dl>
				<dt><a href="/cs/qlist.asp">문의게시판</a></dt>
			</dl>
<% 
sql = "select idx,jemok from guideTab where gbn = 1 order by ordnum asc,idx desc"
set dr = db.execute(sql)
if not dr.bof or not dr.eof then
do until dr.eof 
%>
			<dl>
				<dt><a href="/cs/page.asp?idx=<%=dr(0)%>"><%=dr(1)%></a></dt>
			</dl>
<%
dr.movenext
Loop
else 
end if
dr.close

sql = "select idx,title from cal_mast order by idx desc"
set dr = db.execute(sql)
if not dr.bof or not dr.eof then
do until dr.eof 
%>
			<dl>
				<dt><a href="/cs/cal.asp?cal_idx=<%=dr(0)%>"><%=dr(1)%></a></dt>
			</dl>
<%
dr.movenext
Loop
else 
end if
dr.close
%>
			<dl>
				<dt><a href="/question/ing.asp">설문</a></dt>
				<dd><a href="/question/ing.asp">진행중인설문</a><a href="/question/end.asp">종료된설문</a></dd>
			</dl>
		</div>

		<!-- #include file="../include/left2.asp" -->

<!--  배너시작   -->
	<div style="text-align:center;">
	<% 
	sql = "select banner,banner_url,filegbn,target from banner where areagbn='045' order by  ordnum asc , idx desc"
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