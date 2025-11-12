<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,idx,intpg
Dim gbnS,strPart,strSearch,varPage
Dim quserid,qgbn,qtitle,qcont,qansgbn,qanscont,regdate,ansdate,files1,files2

idx = Request("idx")
intpg = Request("intpg")
gbnS = Request("gbnS")
strSearch = Request("strSearch")
strPart = Request("strPart")
varPage = "gbnS=" & gbnS & "&strPart=" & strPart & "&strSearch=" & strSearch

sql = "select quserid,qgbn,qtitle,qcont,qansgbn,qanscont,regdate,ansdate,files1,files2 from oneone where qidx=" & idx
set dr = db.execute(sql)

If dr.eof Or dr.bof Then

	response.write"<script>"
	response.write"alert('데이터에러!!');"
	response.write"history.back();"
	response.write"</script>"
	response.end

Else

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

dr.close
End if

sql = "select name,tel2,email from member where id='" & quserid & "'"
Dim isMember
set dr = db.execute(sql)
if Not Dr.Bof or Not Dr.Eof then
	isMember = True
	Dim name,tel2,email
	name = dr(0)
	tel2 = dr(1)
	email = dr(2)
end if
dr.close%>
<!--#include file="../main/top.asp"-->

<script language="javascript">
function ModChange(obj1,obj2){
	obj1.style.display = obj1.style.display == "none"  ? "block" : "none";
	obj2.style.display = obj2.style.display == "none"  ? "block" : "none";
}

function go2Ans(){
	
	if(document.fm.qanscont.value==""){
		alert("답변 내용을 입력하세요!");
		document.fm.qanscont.focus();
		return;
	}
	
	document.fm.submit();
}
function delLicen(){
	delok = confirm("정말로 삭제하시겠습니까?");
	if(delok){
		location.href="qdel.asp?idx=<%=idx%>";
	}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>질문과답변</h2>

<form name="fm" action="qwrite.asp" method="post" style="display:inline;" enctype="multipart/form-data">
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="intpg" value="<%=intpg%>">
<input type="hidden" name="gbnS" value="<%=gbnS%>">
<input type="hidden" name="strPart" value="<%=strPart%>">
<input type="hidden" name="strSearch" value="<%=strSearch%>">

		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>문의 제목</th>
						<td><%=qtitle%></td>
					</tr>
					<tr>
						<th>작성자</th>
						<td><%=quserid%> / <%=name%>  / <%=tel2%> / <%=email%></td>
					</tr>
					<tr>
						<th>작성일</th>
						<td><%=regdate%></td>
					</tr>
					<tr>
						<th>문의 내용</th>
						<td><%=qcont%><%if len(files1) > 0 then%><br /><br /><a href="../../ahdma/pds/<%=files1%>">첨부파일(<%=files1%>)</a><%end if%></td>
					</tr>


					<tr>
						<th>답변내용</th>
						<td><textarea name="qanscont" wrap="hard" class="inptxt1" style="width:780px;height:150px;"><%=qanscont%></textarea><br /><p style="height:10px"></p>
						<input name="files2" type="file" class="inptxt1 w300" id="files2"><%if len(files2) > 0 then%><input name="check_del" type="checkbox" value="1"> 삭제<%end if%></td>
					</tr>

				</tbody>
			</table>
</form>

		<div class="rbtn">
			<a href="javascript:go2Ans();" class="btn">저장하기</a>
			<a href="qlist.asp?intpg=<%=intpg%>&<%=varPage%>" class="btn trans">목록보기</a>		
		</div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->