<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<% 
Dim idx : idx = Request("idx")

if idx = "" then
	sql = "select top 1 idx,jemok,neyong from guideTab where gbn = 2 order by ordnum asc,idx desc"
else
	sql = "select idx,jemok,neyong from guideTab where idx=" & idx
end if

dim jemok,neyong
set dr = db.execute(sql)
if not dr.bof or not dr.eof then
	isRecod = True
	idx = dr(0)
	jemok = dr(1)
	neyong = dr(2)
end if
dr.close %>
<!-- #include file="../include/head1.asp" -->
<!-- #include file="../include/top.asp" -->

<div class="smain">    
	<!-- #include file="left.asp" -->	
    <div class="content">
    	<div class="cont_tit">
        	<h3><%=jemok%></h3>
        </div>
        <%=neyong%>
    </div>
</div>

<!-- #include file="../include/bottom.asp" -->