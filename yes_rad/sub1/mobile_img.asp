<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs
dim b_type,b_width,b_height
dim b_img1,b_img2,b_img3,b_img4,b_img5,b_img6,b_img7,b_img8,b_img9,b_img10
dim b_link1,b_link2,b_link3,b_link4,b_link5,b_link6,b_link7,b_link8,b_link9,b_link10
dim b_title1,b_title2,b_title3,b_title4,b_title5,b_title6,b_title7,b_title8,b_title9,b_title10
dim b_content1,b_content2,b_content3,b_content4,b_content5,b_content6,b_content7,b_content8,b_content9,b_content10

sql = "select top 1 b_type,b_img1,b_img2,b_img3,b_img4,b_img5,b_img6,b_img7,b_img8,b_img9,b_img10,b_link1,b_link2,b_link3,b_link4,b_link5,b_link6,b_link7,b_link8,b_link9,b_link10,b_title1,b_title2,b_title3,b_title4,b_title5,b_title6,b_title7,b_title8,b_title9,b_title10,b_content1,b_content2,b_content3,b_content4,b_content5,b_content6,b_content7,b_content8,b_content9,b_content10 from m_banner_mast "
set rs=db.execute(sql)

if rs.eof or rs.bof then
b_type = 1
else
b_type = rs(0)
b_img1 = rs(1)
b_img2 = rs(2)
b_img3 = rs(3)
b_img4 = rs(4)
b_img5 = rs(5)
b_img6 = rs(6)
b_img7 = rs(7)
b_img8 = rs(8)
b_img9 = rs(9)
b_img10 = rs(10)
b_link1 = rs(11)
b_link2 = rs(12)
b_link3 = rs(13)
b_link4 = rs(14)
b_link5 = rs(15)
b_link6 = rs(16)
b_link7 = rs(17)
b_link8 = rs(18)
b_link9 = rs(19)
b_link10 = rs(20)
b_title1 = rs(21)
b_title2 = rs(22)
b_title3 = rs(23)
b_title4 = rs(24)
b_title5 = rs(25)
b_title6 = rs(26)
b_title7 = rs(27)
b_title8 = rs(28)
b_title9 = rs(29)
b_title10 = rs(30)
b_content1 = rs(31)
b_content2 = rs(32)
b_content3 = rs(33)
b_content4 = rs(34)
b_content5 = rs(35)
b_content6 = rs(36)
b_content7 = rs(37)
b_content8 = rs(38)
b_content9 = rs(39)
b_content10 = rs(40)
rs.close
end if

%>
<!--#include file="../main/top.asp"-->

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>모바일메인배너설정</h2>

<form action="mobile_img_ok.asp" method="post" enctype="multipart/form-data" name="config"> 
			<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:15%" />
				<col style="width:10%" />
				<col style="width:75%" />
				</colgroup>
				<tbody>
				<tr>
					<th rowspan="2">롤링배너#1</th>
					<th>배너</th>
					<td><input name="file1" type="file" class="inptxt1 w200" id="file1"> <span class="stip">* gif,png,jpg 넓이 800px이하 * 높이 150px 고정</span>
			<%if len(b_img1) > 0 then%><a href="/pds_update/<%=b_img1%>" target="_blank">(<%=b_img1%>)</a>&nbsp;<input name="check_del1" type="checkbox" id="check_del1" value="1"> <font color="#cc0000">삭제</font><%end if%></td>
				</tr>
				<tr>
					<th>링크</th>
					<td><input name="b_link1" type="text" class="inptxt1 w400" id="b_link1" value="<%=b_link1%>" ></td>
				</tr>

				<tr>
					<th rowspan="2">롤링배너#2</th>
					<th>배너</th>
					<td><input name="file2" type="file" class="inptxt1 w200" id="file2"> <span class="stip">* gif,png,jpg 넓이 800px이하 * 높이 150px 고정</span>
            <%if len(b_img2) > 0 then%><a href="/pds_update/<%=b_img2%>" target="_blank">(<%=b_img2%>)</a>&nbsp;<input name="check_del2" type="checkbox" id="check_del2" value="1">
             <font color="#cc0000">삭제</font><%end if%></td>
				</tr>
				<tr>
					<th>링크</th>
					<td><input name="b_link2" type="text" class="inptxt1 w400" id="b_link2" value="<%=b_link2%>" ></td>
				</tr>

				<tr>
					<th rowspan="2">롤링배너#3</th>
					<th>배너</th>
					<td><input name="file3" type="file" class="inptxt1 w200" id="file3"> <span class="stip">* gif,png,jpg 넓이 800px이하 * 높이 150px 고정</span>
            <%if len(b_img3) > 0 then%><a href="/pds_update/<%=b_img3%>" target="_blank">(<%=b_img3%>)</a>&nbsp;<input name="check_del3" type="checkbox" id="check_del3" value="1">
             <font color="#cc0000">삭제</font><%end if%></td>
				</tr>

				<tr>
					<th>링크</th>
					<td><input name="b_link3" type="text" class="inptxt1 w400" id="b_link3" value="<%=b_link3%>" ></td>
				</tr>

				<tr>
					<th rowspan="2">롤링배너#4</th>
					<th>배너</th>
					<td><input name="file4" type="file" class="inptxt1 w200" id="file4"> <span class="stip">* gif,png,jpg 넓이 800px이하 * 높이 150px 고정</span>
            <%if len(b_img4) > 0 then%><a href="/pds_update/<%=b_img4%>" target="_blank">(<%=b_img4%>)</a>&nbsp;<input name="check_del4" type="checkbox" id="check_del4" value="1">
             <font color="#cc0000">삭제</font><%end if%></td>
				</tr>

				<tr>
					<th>링크</th>
					<td><input name="b_link4" type="text" class="inptxt1 w400" id="b_link4" value="<%=b_link4%>" ></td>
				</tr>

				<tr>
					<th rowspan="2">롤링배너#5</th>
					<th>배너</th>
					<td><input name="file5" type="file" class="inptxt1 w200" id="file5"> <span class="stip">* gif,png,jpg 넓이 800px이하 * 높이 150px 고정</span>
            <%if len(b_img5) > 0 then%><a href="/pds_update/<%=b_img5%>" target="_blank">(<%=b_img5%>)</a>&nbsp;<input name="check_del5" type="checkbox" id="check_del5" value="1">
             <font color="#cc0000">삭제</font><%end if%></td>
				</tr>
				<tr>
					<th>링크</th>
					<td><input name="b_link5" type="text" class="inptxt1 w400" id="b_link5" value="<%=b_link5%>" ></td>
				</tr>


				<tr>
					<th rowspan="2">메인배너#1</th>
					<th>배너</th>
					<td><input name="file6" type="file" class="inptxt1 w200" id="file6"> <span class="stip">* gif,png,jpg 넓이 800px이하 * 높이 150px 고정</span>
            <%if len(b_img6) > 0 then%><a href="/pds_update/<%=b_img6%>" target="_blank">(<%=b_img6%>)</a>&nbsp;<input name="check_del6" type="checkbox" id="check_del6" value="1">
             <font color="#cc0000">삭제</font><%end if%></td>
				</tr>
				<tr>
					<th>링크</th>
					<td><input name="b_link6" type="text" class="inptxt1 w400" id="b_link6" value="<%=b_link6%>" ></td>
				</tr>
				<tr>
					<th rowspan="2">메인배너#2</th>
					<th>배너</th>
					<td><input name="file7" type="file" class="inptxt1 w200" id="file7"> <span class="stip">* gif,png,jpg 넓이 800px이하 * 높이 150px 고정</span>
            <%if len(b_img7) > 0 then%><a href="/pds_update/<%=b_img7%>" target="_blank"><%=b_img6%>)</a>&nbsp;<input name="check_del7" type="checkbox" id="check_del7" value="1">
             <font color="#cc0000">삭제</font><%end if%></td>
				</tr>
				<tr>
					<th>링크</th>
					<td><input name="b_link7" type="text" class="inptxt1 w400" id="b_link7" value="<%=b_link7%>" ></td>
				</tr>
				<tr>
					<th rowspan="2">메인배너#3</th>
					<th>배너</th>
					<td><input name="file8" type="file" class="inptxt1 w200" id="file8"> <span class="stip">* gif,png,jpg 넓이 800px이하 * 높이 150px 고정</span>
            <%if len(b_img8) > 0 then%><a href="/pds_update/<%=b_img8%>" target="_blank">(<%=b_img8%>)</a>&nbsp;<input name="check_del8" type="checkbox" id="check_del8" value="1">
            <font color="#cc0000">삭제</font><%end if%></td>
				</tr>
				<tr>
					<th>링크</th>
					<td><input name="b_link8" type="text" class="inptxt1 w400" id="b_link8" value="<%=b_link8%>" ></td>
				</tr>		


				</tbody>
			</table>
</form>

		<div class="rbtn">
			<a href="javascript:document.config.submit();" class="btn">저장하기</a>
		</div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->