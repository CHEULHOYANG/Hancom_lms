<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs,p_idx,q_count,i,title,sq

p_idx = request("p_idx")

sql = "select title from question_list where idx = "& p_idx
set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
	title = rs(0)
rs.close
End if

sql = "select count(idx) from question_mast where ca = "& p_idx
set rs=db.execute(sql)

q_count = rs(0)
rs.close
%>
<!--#include file="../main/top.asp"-->

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>설문지참여결과(항목별)</h2>

		<div class="tbl_top">
<form name="form1" method="post" action="?">
<input type="hidden" name="p_idx" value="<%=request("p_idx")%>">
  
			  <select name="id" id="id" onChange="document.form1.submit();" class="seltxt w200">
                <option<% if Len(request("id")) = 0 then response.write " selected" %> value="">참여회원 전체</option>
<%
sql = "select id,dbo.MemberNm(id) from question_result where p_idx= "& p_idx
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
Do Until rs.eof
%>
                <option<% if request("id") = rs(0) then response.write " selected" %> value="<%=rs(0)%>"><%=rs(0)%>(<%=rs(1)%>)</option>
<%
rs.movenext
Loop
rs.close
End if
%>
              </select><select name="q_idx" id="q_idx" onChange="document.form1.submit();" class="seltxt w200">
                <option<% if Len(request("q_idx")) = 0 then response.write " selected" %> value="">문항 전체</option>
                <%
For i = 1 To q_count
%>
                <option<% if request("q_idx") = int(i) then response.write " selected" %> value="<%=i%>"><%=i%>번 문항</option>
                <%
next
%>
              </select> <a href="question_list.asp" class="fbtn">목록으로</a>	</form>
		</div>

<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:10%" />
			<col />
			<col style="width:15%" />
			</colgroup>
			<thead>
				<tr>					
					<th>설문번호</th>
					<th>설문내용</th>
					<th>아이디</th>						
				</tr>				
			</thead>
			<tbody>
<%
If Len(request("q_idx")) > 0 Then
	sq = ""& sq &" and q_idx = "& request("q_idx") &""
End If
If Len(request("id")) > 0 Then
	sq = ""& sq &" and id like '%"& request("id") &"%'"
End If

sql = "select q_idx,q_result,id,regdate from question_result_detail where p_idx = "& p_idx &" "& sq &" order by id desc,q_idx asc"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
Do Until rs.eof
%>
				<tr>
					<td><%=rs(0)%></td>
					<td><%=rs(1)%></td>
					<td><%=rs(2)%></td>
				</tr>
<%
rs.movenext
Loop
rs.close
End if
%>
			</tbody>
		</table>


	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->