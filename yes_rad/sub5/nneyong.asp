<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,idx,intpg
dim jemok,neyong,wday,readnum

idx = Request("idx")
intpg = Request("intpg")

sql = "select jemok,neyong,wday,readnum from notice where idx=" & idx
set dr = db.execute(sql)

If dr.eof Or dr.bof Then

	response.write"<script>"
	response.write"alert('데이터에러!!');"
	response.write"history.back();"
	response.write"</script>"
	response.end

Else

	jemok = dr(0)
	neyong = dr(1)
	wday = dr(2)
	readnum = dr(3)
	
dr.close 
End if
%>
<!--#include file="../main/top.asp"-->

<script language="javascript">
function delLicen(){
	delok = confirm("정말로 삭제하시겠습니까?");
	if(delok){
		location.href="ndel.asp?idx=<%=idx%>";
	}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>공지사항</h2>

		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>제목</th>
						<td><%=jemok%></td>
					</tr>
					<tr>
						<th>작성일</th>
						<td><%=wday%></td>
					</tr>
					<tr>
						<th>조회수</th>
						<td><%=readnum%></td>
					</tr>
					<tr>
						<th>내용</th>
						<td><%=neyong%></td>
					</tr>

				</tbody>
			</table>
		<div class="rbtn">
			<a href="nedit.asp?idx=<%=idx%>&intpg=<%=intpg%>&strPart=<%=request("strPart")%>&strSearch=<%=request("strSearch")%>" class="btn">수정</a>
			<a href="javascript:delLicen();" class="btn">삭제</a>
			<a href="nlist.asp?intpg=<%=intpg%>" class="btn trans">목록보기</a>		
		</div>

	</div>
</div>


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->