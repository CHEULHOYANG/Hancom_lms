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
end select %>
	<div class="nlnbWrap">
		<h2><%=t_menu1%></h2>
		<div class="nlnb">
<% 
sql = "select idx,jemok from guideTab where gbn = 2 order by ordnum asc,idx desc"
set dr = db.execute(sql)
if not dr.bof or not dr.eof then
do until dr.eof 
%>
			<dl>
				<dt><a href="/page/page.asp?idx=<%=dr(0)%>"><%=dr(1)%></a></dt>
			</dl>
<%
dr.movenext
Loop
else 
dr.close	
end if	  
%>
		</div>

        <!-- #include file="../include/left2.asp" -->

<!--  배너시작   -->
	<div style="text-align:center;">
	<% 
	sql = "select banner,banner_url,filegbn,target from banner where areagbn='042' order by  ordnum asc , idx desc"
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