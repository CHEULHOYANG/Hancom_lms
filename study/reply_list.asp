<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<% 
dim page,recordcount,pagecount,totalpage,blockpage,pagesize
dim rs,vidx,vcat,sq,i,stitle,rs1,Index

sq = ""

If Len(request("vidx")) > 0 Then sq = "vidx = "& request("vidx")&""
If Len(request("vcat")) > 0 Then sq = "vcat = "& request("vcat")&""
%>
<!-- #include file="../include/head1.asp" -->
<!-- #include file="../include/top.asp" -->

<div class="smain">  
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3>수강후기</h3>
        </div>
        <div class="scont">
		<div style="padding:0 0 10px 0;"><form name="sform" method="post" action="?">
				<select name="vidx" class="seltxt1" style="width:600px" onchange="document.sform.submit();">
				<option value="">강의선택</option>
<%
sql = "select idx,strnm,sub_title from LecturTab order by idx desc"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
Do Until rs.eof
%>
						<option value="<%=rs(0)%>" <%If request("vidx") = ""& rs(0) &"" Then response.write"selected" End if%>><%=rs(1)%></option><%
rs.movenext
Loop
rs.close
End if
%></select></form></div>


<%
if request("page")="" then
   page=1
   else 
   page=request("page")
end if

pagesize = 10

If Len(sq) > 0 then

	sql = "select count(idx) as reccount from lec_reply where "& sq &""
	set rs=db.execute(sql)
	recordcount =rs(0)
	pagecount=int((recordcount-1)/pagesize)+1
	sql = "SELECT top " & pagesize & " idx,id,name,content,regdate,star,vidx,vcat,(select strnm from LecturTab where idx=A.vidx),(select sajin from LecturTab where idx=A.vidx) from lec_reply A where "& sq &" and idx not in"
	sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from lec_reply where "& sq &" order by idx desc ) order by idx desc"
	set rs=db.execute(sql)

Else

	sql = "select count(idx) as reccount from lec_reply "
	set rs=db.execute(sql)
	recordcount =rs(0)
	pagecount=int((recordcount-1)/pagesize)+1
	sql = "SELECT top " & pagesize & " idx,id,name,content,regdate,star,vidx,vcat,(select strnm from LecturTab where idx=A.vidx),(select sajin from LecturTab where idx=A.vidx) from lec_reply A where idx not in"
	sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from lec_reply order by idx desc ) order by idx desc"
	set rs=db.execute(sql)

End If

If rs.eof Or rs.bof Then
Else
Index = (pagesize + recordcount) - (page * pagesize) + 1		
do until rs.eof
Index = Index - 1
%>
				<div class="re_lista">
					<div class="ra_imga" style="background:url(/img/img/admin.jpg) no-repeat center top;background-size:cover;">
					<img src="/img/img/admin.jpg"></div>
					<div class="re_datea"><%=Replace(Left(rs(4),10),"-",".")%>&nbsp;<%=Left(rs(2),1)%>**&nbsp;<%for i=1 to int(rs(5)) %><img src="../img/star_b.gif" width="10" height="10"><%next%><%for i=1 to 5-int(rs(5)) %><img src="../img/star_g.gif" width="10" height="10"><%next%></div>
					<div class="reple_boxa">
						<%If Len(rs(8)) > 0 then%><h4><%=rs(8)%></h4><br /><%End if%><%=replace(rs(3),chr(13) & chr(10),"<br>")%>
					</div>
				</div>
<%
rs.movenext
Loop
rs.close
End if
%>



		<div class="paging">
			<a href="?vidx=<%=request("vidx")%>&vcat=<%=request("vcat")%>&page=1"><img src="../img/img/a_prev2.gif" alt="처음페이지"></a>			
<%
blockPage=Int((page-1)/10)*10+1
if blockPage = 1 Then
Else
%>
			<a href="?vidx=<%=request("vidx")%>&vcat=<%=request("vcat")%>&page=<%=blockPage-10%>"><img src="../img/img/a_prev1.gif" alt="이전페이지"></a>
<%
End If
   i=1
   Do Until i > 10 or blockPage > pagecount
      If blockPage=int(page) Then
%>
			<strong><%=blockPage%></strong>
<%Else%>
			<a href="?vidx=<%=request("vidx")%>&vcat=<%=request("vcat")%>&page=<%=blockPage%>" class="pnum"><%=blockPage%></a>
                          <%
    End If    
    blockPage=blockPage+1
    i = i + 1
    Loop
if blockPage > pagecount Then
Else
%>
			<a href="?vidx=<%=request("vidx")%>&vcat=<%=request("vcat")%>&page=<%=blockPage%>"><img src="../img/img/a_next1.gif" alt="다음페이지"></a>			
<%
End If
%>
			<a href="?vidx=<%=request("vidx")%>&vcat=<%=request("vcat")%>&page=<%=pagecount%>"><img src="../img/img/a_next2.gif" alt="마지막페이지"></a>
		</div>	

        </div>
    </div>
</div>


<!-- #include file="../include/bottom.asp" -->
<%
Function cutStr(str, cutLen)
	Dim strLen, strByte, strCut, strRes, char, i
	strLen = 0
	strByte = 0
	strLen = Len(str)
	for i = 1 to strLen
		char = ""
		strCut = Mid(str, i, 1)
		char = Asc(strCut)
		char = Left(char, 1)
		if char = "-" then
			strByte = strByte + 2
		else
			strByte = strByte + 1
		end if
		if cutLen < strByte then
			strRes = strRes & ".."
			exit for
		else
			strRes = strRes & strCut
		end if
	next
	cutStr = strRes
End Function
%>