<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs,t_menu1,t_menu2,t_menu3,t_menu4,t_menu5,t_menu6,t_menu7,t_menu8,t_menu9,t_menu10
Dim t_menu_sub1,t_menu_sub2,t_menu_sub3,t_menu_sub4,t_menu_sub5,t_menu_sub6,t_menu_sub7,t_menu_sub8,t_menu_sub9,t_menu_sub10
			  
sql="select t_menu1,t_menu2,t_menu3,t_menu4,t_menu5,t_menu6,t_menu7,t_menu8,t_menu9,t_menu10,t_menu_sub1,t_menu_sub2,t_menu_sub3,t_menu_sub4,t_menu_sub5,t_menu_sub6,t_menu_sub7,t_menu_sub8,t_menu_sub9,t_menu_sub10 from site_info"
 set rs=db.execute(sql)
			  
if rs.eof or rs.bof then
else
			  
			  t_menu1 = rs(0)
			  t_menu2 = rs(1)
			  t_menu3 = rs(2)
			  t_menu4 = rs(3)
			  t_menu5 = rs(4)
			  t_menu6 = rs(5)
			  t_menu7 = rs(6)
			  t_menu8 = rs(7)
			  t_menu9 = rs(8)
			  t_menu10 = rs(9)
			  t_menu_sub1 = rs(10)
			  t_menu_sub2 = rs(11)
			  t_menu_sub3 = rs(12)
			  t_menu_sub4 = rs(13)
			  t_menu_sub5 = rs(14)
			  t_menu_sub6 = rs(15)
			  t_menu_sub7 = rs(16)
			  t_menu_sub8 = rs(17)
			  t_menu_sub9 = rs(18)
			  t_menu_sub10 = rs(19)

rs.close
end if
%>
<!--#include file="../main/top.asp"-->

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>메뉴명칭설정</h2>

<form name="form1" method="post" action="t_menu_ok.asp">

		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:20%" />
			<col style="width:40%" />
			<col style="width:40%" />
			</colgroup>
			<thead>
				<tr>
					<th>구분</th>	
					<th>작은메뉴</th>
					<th>큰메뉴</th>						
				</tr>				
			</thead>
			<tbody>
				<tr>
					<th>학원소개</th>
					<td><input name="t_menu_sub1" type="text" class="inptxt1 w200" value="<%=t_menu_sub1%>" style="text-align:center;"></td>
					<td><input name="t_menu1" type="text" class="inptxt1 w200" value="<%=t_menu1%>" style="text-align:center;"></td>
				</tr>
				<tr>
					<th>수강신청</th>
					<td><input name="t_menu_sub2" type="text" class="inptxt1 w200" value="<%=t_menu_sub2%>" style="text-align:center;"></td>
					<td><input name="t_menu2" type="text" class="inptxt1 w200" value="<%=t_menu2%>" style="text-align:center;"></td>
				</tr>
				<tr>
					<th>선생님소개</th>
					<td><input name="t_menu_sub3" type="text" class="inptxt1 w200" value="<%=t_menu_sub3%>" style="text-align:center;"></td>
					<td><input name="t_menu3" type="text" class="inptxt1 w200" value="<%=t_menu3%>" style="text-align:center;"></td>
				</tr>
				<tr>
					<th>교재소개</th>
					<td><input name="t_menu_sub4" type="text" class="inptxt1 w200" value="<%=t_menu_sub4%>" style="text-align:center;"></td>
					<td><input name="t_menu4" type="text" class="inptxt1 w200" value="<%=t_menu4%>" style="text-align:center;"></td>
				</tr>
				<tr>
					<th>테스트</th>
					<td><input name="t_menu_sub5" type="text" class="inptxt1 w200" value="<%=t_menu_sub5%>" style="text-align:center;"></td>
					<td><input name="t_menu5" type="text" class="inptxt1 w200" value="<%=t_menu5%>" style="text-align:center;"></td>
				</tr>
				<tr>
					<th>학습커뮤니티</th>
					<td><input name="t_menu_sub6" type="text" class="inptxt1 w200" value="<%=t_menu_sub6%>" style="text-align:center;"></td>
					<td><input name="t_menu6" type="text" class="inptxt1 w200" value="<%=t_menu6%>" style="text-align:center;"></td>
				</tr>
				<tr>
					<th>고객센터</th>
					<td><input name="t_menu_sub7" type="text" class="inptxt1 w200" value="<%=t_menu_sub7%>" style="text-align:center;"></td>
					<td><input name="t_menu7" type="text" class="inptxt1 w200" value="<%=t_menu7%>" style="text-align:center;"></td>
				</tr>
				<tr>
					<th>나의강의실</th>
					<td><input name="t_menu_sub8" type="text" class="inptxt1 w200" value="<%=t_menu_sub8%>" style="text-align:center;"></td>
					<td><input name="t_menu8" type="text" class="inptxt1 w200" value="<%=t_menu8%>" style="text-align:center;"></td>
				</tr>
			</tbody>
		</table>

</form>

		<div class="rbtn">
			<a href="javascript:document.form1.submit();" class="btn">저장하기</a>
		</div>

<div class="caution"><p>미사용시 빈칸으로 하시면 사이트에서 해당 메뉴가 숨겨지게 됩니다.</p></div>
<div class="caution"><p>구매하신 솔루션 옵션에 따라 메뉴가 작동을 하게 됩니다.</p></div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->