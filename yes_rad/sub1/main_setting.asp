<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs
Dim mtitle1,mtitle2,mtitle3,mtitle4,mtitle5,mtitle6,mtitle7,mtitle8,mtitle9,mtitle10
Dim mlink1,mlink2,mlink3,mlink4,mlink5,mlink6,mlink7,mlink8,mlink9,mlink10
			  
sql="select mtitle1,mtitle2,mtitle3,mtitle4,mtitle5,mtitle6,mtitle7,mtitle8,mtitle9,mtitle10,mlink1,mlink2,mlink3,mlink4,mlink5,mlink6,mlink7,mlink8,mlink9,mlink10 from site_info"
 set rs=db.execute(sql)
			  
if rs.eof or rs.bof then
else
			  
	mtitle1 = rs(0)
	mtitle2 = rs(1)
	mtitle3 = rs(2)
	mtitle4 = rs(3)
	mtitle5 = rs(4)
	mtitle6 = rs(5)
	mtitle7 = rs(6)
	mtitle8 = rs(7)
	mtitle9 = rs(8)
	mtitle10 = rs(9)
	mlink1 = rs(10)
	mlink2 = rs(11)
	mlink3 = rs(12)
	mlink4 = rs(13)
	mlink5 = rs(14)
	mlink6 = rs(15)
	mlink7 = rs(16)
	mlink8 = rs(17)
	mlink9 = rs(18)
	mlink10 = rs(19)

rs.close
end if
%>
<!--#include file="../main/top.asp"-->

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>메인링크설정</h2>

<form name="form1" method="post" action="main_setting_ok.asp">

		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:20%" />
			<col style="width:40%" />
			<col style="width:40%" />
			</colgroup>
			<thead>
				<tr>
					<th>구분</th>	
					<th>제목</th>
					<th>링크</th>						
				</tr>				
			</thead>
			<tbody>
				<tr>
					<th>링크#1</th>
					<td><input name="mtitle1" type="text" class="inptxt1 w200" value="<%=mtitle1%>" style="text-align:center;"></td>
					<td><input name="mlink1" type="text" class="inptxt1 w200" value="<%=mlink1%>"></td>
				</tr>
				<tr>
					<th>링크#2</th>
					<td><input name="mtitle2" type="text" class="inptxt1 w200" value="<%=mtitle2%>" style="text-align:center;"></td>
					<td><input name="mlink2" type="text" class="inptxt1 w200" value="<%=mlink2%>" ></td>
				</tr>
				<tr>
					<th>링크#3</th>
					<td><input name="mtitle3" type="text" class="inptxt1 w200" value="<%=mtitle3%>" style="text-align:center;"></td>
					<td><input name="mlink3" type="text" class="inptxt1 w200" value="<%=mlink3%>" ></td>
				</tr>
				<tr>
					<th>링크#4</th>
					<td><input name="mtitle4" type="text" class="inptxt1 w200" value="<%=mtitle4%>" style="text-align:center;"></td>
					<td><input name="mlink4" type="text" class="inptxt1 w200" value="<%=mlink4%>" ></td>
				</tr>
				<tr>
					<th>링크#5</th>
					<td><input name="mtitle5" type="text" class="inptxt1 w200" value="<%=mtitle5%>" style="text-align:center;"></td>
					<td><input name="mlink5" type="text" class="inptxt1 w200" value="<%=mlink5%>" ></td>
				</tr>
				<tr>
					<th>링크#6</th>
					<td><input name="mtitle6" type="text" class="inptxt1 w200" value="<%=mtitle6%>" style="text-align:center;"></td>
					<td><input name="mlink6" type="text" class="inptxt1 w200" value="<%=mlink6%>" ></td>
				</tr>
				<tr>
					<th>링크#7</th>
					<td><input name="mtitle7" type="text" class="inptxt1 w200" value="<%=mtitle7%>" style="text-align:center;"></td>
					<td><input name="mlink7" type="text" class="inptxt1 w200" value="<%=mlink7%>" ></td>
				</tr>
				<tr>
					<th>링크#8</th>
					<td><input name="mtitle8" type="text" class="inptxt1 w200" value="<%=mtitle8%>" style="text-align:center;"></td>
					<td><input name="mlink8" type="text" class="inptxt1 w200" value="<%=mlink8%>"></td>
				</tr>
				<tr>
					<th>링크#9</th>
					<td><input name="mtitle9" type="text" class="inptxt1 w200" value="<%=mtitle9%>" style="text-align:center;"></td>
					<td><input name="mlink9" type="text" class="inptxt1 w200" value="<%=mlink9%>" ></td>
				</tr>
				<tr>
					<th>링크#10</th>
					<td><input name="mtitle10" type="text" class="inptxt1 w200" value="<%=mtitle10%>" style="text-align:center;"></td>
					<td><input name="mlink10" type="text" class="inptxt1 w200" value="<%=mlink10%>" ></td>
				</tr>
			</tbody>
		</table>

</form>

		<div class="rbtn">
			<a href="javascript:document.form1.submit();" class="btn">저장하기</a>
		</div>

<div class="caution"><p>해당 메뉴는 디자인에 따라 적용이 미사용됩니다.</p></div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->