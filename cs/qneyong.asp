<!-- #include file="../include/set_loginfo.asp" -->
<% if isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
Dim idx,intpg
idx = Request("idx")
intpg = Request("intpg")
Dim gbnS,strPart,strSearch,varPage

gbnS = Request("gbnS")
strSearch = Request("strSearch")
strPart = Request("strPart")

sql = "select quserid,qgbn,qtitle,qcont,qansgbn,qanscont,regdate,ansdate,files1,files2,uname from oneone where qidx=" & idx
set dr = db.execute(sql)

If dr.eof Or dr.bof Then

	response.write"<script>"
	response.write"alert('데이터베이스에러!!');"
	response.write"history.back();"
	response.write"</script>"
	response.end

else

	Dim quserid,qgbn,qtitle,qcont,qansgbn,qanscont,regdate,ansdate,files1,files2,uname
	quserid = dr(0)
	qgbn = int(dr(1))
	qtitle = dr(2)
	qcont = replace(dr(3),chr(13),"<br>")
	qansgbn = int(dr(4))
	qanscont = dr(5)
	regdate = dr(6)
	ansdate = dr(7)
	files1 = dr(8)
	files2 = dr(9)
	uname = dr(10)
	dr.close

End if

Dim viewPage
viewPage = True

if qgbn > 1 and Not quserid = str_User_ID then
	viewPage = False
end if

if viewPage then %>
<!-- #include file="../include/head1.asp" -->
<% if str_User_ID = quserid then %>
<script language="javascript">
function delLicen(){
	delok = confirm("정말로 삭제하시겠습니까?");
	if(delok){
		location.href="qdel.asp?idx=<%=idx%>";
	}
}
</script>
<% end if %>

<!-- #include file="../include/top.asp" -->

<div class="smain">
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3>문의게시판</h3>
        </div>
        <div class="scont">

<table class="ftbl" style="width:830px">
                    <colgroup>
                    <col style="width:20%" />
                    <col style="width:80%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>문의제목</th>
                            <td><strong><%=qtitle%></strong></td>
                        </tr>
                        <tr>
                            <th>처리상태</th>
                            <td><%If qansgbn = 1 Then response.write "답변완료" Else response.write "답변대기" End if%></td>
                        </tr>
                        <tr>
                            <th>글쓴이</th>
                            <td><%=uname%></td>
                        </tr>
                        <tr>
                            <th>작성일</th>
                            <td><%=regdate%></td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th>문의내용</th>
                            <td class="cmt"><%=qcont%><%if len(files1) > 0 then%><br /><br /><a href="../ahdma/pds/<%=files1%>">첨부파일 : <font color="#cc0000"><%=files1%></font></a><%end if%></td>
                        </tr>
<%If Len(qanscont) > 0 then%>
				<tr>
					<th>답변</th>
					<td class="cmt"><%=replace(qanscont,chr(13),"<br>")%><%if len(files2) > 0 then%><br /><br /><a href="../ahdma/pds/<%=files2%>">첨부파일 : <font color="#cc0000"><%=files2%></font></a><%end if%></td>
				</tr>
<%End if%>
                    </tbody>
                </table>
            <div class="cbtn"> <% if str_User_ID = quserid then %><a href="javascript:delLicen();" class="mbtn grey">삭제하기</a><%End if%> <a href="qlist.asp?intpg=<%=intpg%>&<%=varPage%>" class="mbtn">목록으로</a> </div>

        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" --><% else %>
<!-- #include file="../include/false_pg.asp" --><% end if
else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>
