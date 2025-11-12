<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr
Dim info1,info2,info3,info4,info5,info6,info7

sql = "select top 1 info1,info2,info3,info4,info5,info6,info7 from m_config"
set dr = db.execute(sql)

if dr.eof or dr.bof then

	info1 = ""
	info2 = ""
	info3 = ""
	info4 = ""
	info5 = ""
	info6 = ""
	info7 = ""
	
else

	info1 = dr(0)
	info2 = dr(1)
	info3 = dr(2)
	info4 = dr(3)
	info5 = dr(4)
	info6 = dr(5)
	info7 = dr(6)

dr.close
end if

%>
<!--#include file="../main/top.asp"-->

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>모바일웹설정</h2>

<form name="form1" method="post" action="mobile_ok.asp" enctype="multipart/form-data">
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>로고</th>
						<td><input name="file2" type="file" class="inptxt1 w400" id="file2" >&nbsp;&nbsp;<%if len(info6) > 0 then response.write"<input type='checkbox' name='check_del2' value='1'>&nbsp;삭제" end if%> <span class="stip">jpg,png,gif 120pxX40px</span></td>
					</tr>
					<tr>
						<th>바로가기아이콘등록</th>
						<td><input name="file1" type="file" class="inptxt1 w400" id="file1" value="" >&nbsp;&nbsp;<%if len(info1) > 0 then response.write"<input type='checkbox' name='check_del1' value='1'>&nbsp;삭제" end if%><span class="stip">* png파일만가능 72pxX72px</span></td>
					</tr>
					<tr>
						<th>사이트주소</th>
						<td><input name="info2" type="text" class="inptxt1 w400" id="info2" value="<%=info2%>" ></td>
					</tr>
					<tr>
						<th>대표번호</th>
						<td><input name="info3" type="text" class="inptxt1 w200" id="info3" value="<%=info3%>" ></td>
					</tr>
					<tr>
						<th>회사주소</th>
						<td><input name="info4" type="text" class="inptxt1 w400" id="info4" value="<%=info4%>" ></td>
					</tr>
					<tr>
						<th>사이트명</th>
						<td><input name="info5" type="text" class="inptxt1 w400" id="info5" value="<%=info5%>" ></td>
					</tr>

					<tr>
						<th>사이트타이틀</th>
						<td><input name="info7" type="text" class="inptxt1 w400" id="info7" value="<%=info7%>" ></td>
					</tr>
				</tbody>
			</table>
</form>

		<div class="rbtn">
			<a href="javascript:document.form1.submit();" class="btn trans">저장하기</a>		
		</div>

		<div class="caution"><p>모바일웹에 사용되는 로고 하단 카피라이트를 설정하실수 있습니다.</p></div>
		<div class="caution"><p>주소는 http://를 포함한 전체 주소를 입력해주세요.</p></div>

	</div>
</div>

</table>
</body>
</html>
<!-- #include file = "../authpg_2.asp" -->