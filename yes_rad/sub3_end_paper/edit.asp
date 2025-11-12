<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim einfo1,einfo2,einfo3,einfo4,einfo5,einfo6,einfo7,einfo8,einfo9,einfo10
Dim title,id,info1,info2,info3,info4,info5,info6,info7,info8,info9,info10,files
Dim sql,rs

sql="select info1,info2,info3,info4,info5,info6,info7,info8,info9,info10 from end_paper_config"
set rs=db.execute(sql)

if rs.eof or rs.bof Then

	einfo1 = "타이틀1"
	einfo2 = "타이틀2"
	einfo3 = "타이틀3"
	einfo4 = "타이틀4"
	einfo5 = "타이틀5"
	einfo6 = "타이틀6"
	einfo7 = "타이틀7"
	einfo8 = "타이틀8"
	einfo9 = "타이틀9"
	einfo10 = "타이틀10"

Else

	einfo1 = rs(0)
	einfo2 = rs(1)
	einfo3 = rs(2)
	einfo4 = rs(3)
	einfo5 = rs(4)
	einfo6 = rs(5)
	einfo7 = rs(6)
	einfo8 = rs(7)
	einfo9 = rs(8)
	einfo10 = rs(9)

rs.close
end if

sql="select title,id,info1,info2,info3,info4,info5,info6,info7,info8,info9,info10,files from end_paper where idx = "& request("idx")
set rs=db.execute(sql)

if rs.eof or rs.bof Then

	response.write"<script>"
	response.write"alert('디비에러!!');"
	response.write"history.back();"
	response.write"</script>"
	response.end

Else

	title = rs(0)
	id = rs(1)
	info1 = rs(2)
	info2 = rs(3)
	info3 = rs(4)
	info4 = rs(5)
	info5 = rs(6)
	info6 = rs(7)
	info7 = rs(8)
	info8 = rs(9)
	info9 = rs(10)
	info10 = rs(11)
	files = rs(12)

rs.close
end if
%>
<!--#include file="../main/top.asp"-->

<script>
function paper_edit(){

	var f = window.document.fm;

	if(f.title.value==""){
	alert("수료증제목을 입력해주세요.");
	f.title.focus();
	return;
	}
	if(f.id.value==""){
	alert("아이디를 입력해주세요.");
	f.id.focus();
	return;
	}


	f.submit();

}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>수료증관리</h2>

<form action="edit_ok.asp" method="post" name="fm" enctype="multipart/form-data">
<input type="hidden" name="idx" value="<%=request("idx")%>">
<input type="hidden" name="page" value="<%=request("page")%>">
<input type="hidden" name="searchpart" value="<%=request("searchpart")%>">
<input type="hidden" name="searchstr" value="<%=request("searchstr")%>">

<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>발급번호</th>
						<td><input name="info8" type="text" class="inptxt1 w200" id="info8" value="<%=info8%>"></td>
					</tr>
					<tr>
						<th>회원아이디</th>
						<td><input name="id" type="text" class="inptxt1 w200" id="id" value="<%=id%>" ></td>
					</tr>
					<tr>
						<th>수료증제목</th>
						<td><input name="title" type="text" class="inptxt1 w400" id="title" value="<%=title%>" ></td>
					</tr>
					<tr>
						<th>수료증파일</th>
						<td><input type="file" name="files" class="inptxt1 w200"> <%If Len(files) > 0 then%>  <input name="file3_del" type="checkbox" id="file3_del" value="Y"> 삭제 (현재파일:<a href="/ahdma/quiz/<%=files%>"><%=files%></a>)<%end if%></td>
					</tr>
<%If Len(einfo2) >0 then%>
                  <tr>
                    <th><%=einfo2%></th>
                    <td><input name="info2" type="text" class="inptxt1 w400" id="info2" value="<%=info2%>" ></td>
                  </tr>
<%End if%>

<%If Len(einfo3) >0 then%>
                  <tr>
                    <th><%=einfo3%></th>
                    <td><input name="info3" type="text" class="inptxt1 w400" id="info3" value="<%=info3%>">                    </td>
                  </tr>
<%End if%>

<%If Len(einfo4) >0 then%>
                  <tr>
                    <th><%=einfo4%></th>
                    <td><input name="info4" type="text" class="inptxt1 w400" id="info4" value="<%=info4%>">                    </td>
                  </tr>
<%End if%>

<%If Len(einfo5) >0 then%>
                  <tr>
                    <th><%=einfo5%></th>
                    <td><input name="info5" type="text" class="inptxt1 w400" id="info5" value="<%=info5%>">                    </td>
                  </tr>
<%End if%>

<%If Len(einfo6) >0 then%>
                  <tr>
                    <th><%=einfo6%></th>
                    <td><input name="info6" type="text" class="inptxt1 w400" id="info6" value="<%=info6%>">                    </td>
                  </tr>
<%End if%>

<%If Len(einfo7) >0 then%>
                  <tr>
                    <th><%=einfo7%></th>
                    <td><input name="info7" type="text" class="inptxt1 w400" id="info7" value="<%=info7%>"></td>
                  </tr>
<%End if%>
					
				</tbody>
			</table>



		<div class="rbtn">
			<a href="javascript:paper_edit();" class="btn">저장하기</a>
			<a href="list.asp?page=<%=request("page")%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>" class="btn trans">목록보기</a>		
		</div>

</form>

	</div>
</div>

</body>
</html>

<!-- #include file = "../authpg_2.asp" -->