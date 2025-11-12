<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,isRecod,isRows,isCols
Dim intpg,blockPage,pagecount,recordcount,lyno
Dim tabnm : tabnm = "banner"

Dim nowPage : nowPage = Request("URL")

intpg = Request("intpg")
if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

const pagesize = 10

Dim strClmn : strClmn = " idx,bangbn,areagbn,filegbn,banner_url "

sql = "select Count(idx) from " & tabnm
set dr = db.execute(sql)
recordcount = int(dr(0))
dr.close

if recordcount > 0 then
	isRecod = True
	pagecount=int((recordcount-1)/pagesize)+1
end if
%>

<!--#include file="../main/top.asp"-->

<script language="javascript">
function go2ListPage(pg){
	document.location.href="<%=nowPage%>?intpg=" + pg;
}
function go2DelBan(idx){
	var delok = confirm("정말로 삭제하시겠습니까?");
	if(delok){
		location.href="banner_del.asp?idx=" + idx;
	}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>배너설정</h2>

		<div class="tbl_top">
			<a href="banner_write.asp" class="fbtn1">배너등록</a>	
		</div>

<% if isRecod Then

				sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm & " order by idx desc) order by idx desc"
				set dr = db.execute(sql)
				isRows = split(dr.getstring(2),chr(13)) %>
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:20%" />
			<col />
			<col style="width:25%" />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th>위치/적용페이지</th>	
					<th>링크주소</th>
					<th>배너파일</th>
					<th>관리</th>	
				</tr>				
			</thead>
			<tbody>
<%  for ii = 0 to UBound(isRows) - 1
						isCols = split(isRows(ii),chr(9)) %>
				<tr>
					<td><%=strBanGbn(isCols(1))%> > <%=strAreaGbn(isCols(2))%></td>
					<td><% if isCols(4) = "" then %>-<% else %><a href="<%=isCols(4)%>" target="_blank"><%=isCols(4)%></a><% end if %></td>
					<td><% if isCols(3) = "swf" then %>플래쉬<% else %>이미지<% end if %>(<%=isCols(3)%>) 파일</td>
					<td><a href="banner_edit.asp?idx=<%=isCols(0)%>&intpg=<%=intpg%>" class="btns">수정</a> <a href="javascript:go2DelBan('<%=isCols(0)%>');" class="btns trans">삭제</a></td>
				</tr>
<% Next %>
			</tbody>
		</table>
<% End if%>

<% if isRecod Then%>
		<div class="cbtn">
<%
blockPage = int((intpg-1)/10) * 10 + 1
%>
			<div class="paging">
			<% if blockPage > 1 Then %>
				<a href="javascript:go2ListPage('1');"><img src="/yes_rad/rad_img/img/a_prev2.gif" alt="처음페이지"></a>
				<a href="javascript:go2ListPage('<%=int(blockPage-1)%>');"><img src="/yes_rad/rad_img/img/a_prev1.gif" alt="이전페이지" /></a>
			<%End if%>
			<% ii = 1
									Do Until ii > 10 or blockPage > pagecount
									if blockPage = int(intpg) then %>
				<strong><%=blockPage%></strong><% else %>
				<a href="javascript:go2ListPage('<%=blockPage%>');" class="num"><%=blockPage%></a>
				<% end if
									blockPage = blockPage + 1
									ii = ii + 1
									Loop %>
			<% if blockPage > pagecount then 
			else
			%>
				<a href="javascript:go2ListPage('<%=blockPage%>');"><img src="/yes_rad/rad_img/img/a_next1.gif" alt="다음페이지"></a>
				<a href="javascript:go2ListPage('<%=pagecount%>');"><img src="/yes_rad/rad_img/img/a_next2.gif" alt="마지막페이지"></a>
			<%End if%>
			</div>
		</div>
<%End if%>

	</div>
</div>


</body>
</html><% Function strBanGbn(gbncod)
	select case int(gbncod)
		case 1
			strBanGbn = "메인"
		case 2
			strBanGbn = "서브"
	end select
End Function

Function strAreaGbn(areacod)
	select case areacod
		case "010"
			strareaGbn = "메인#1(무제한)"
		case "011"
			strareaGbn = "메인#2(1개)"
		case "012"
			strareaGbn = "메인#3(1개)"
		case "013"
			strareaGbn = "로고오른쪽(1개)"	

		case "041"
			strareaGbn = "강의실왼쪽"
		case "042"
			strareaGbn = "학원소개왼쪽"
		case "043"
			strareaGbn = "자료실왼쪽"
		case "044"
			strareaGbn = "커뮤니티왼쪽"
		case "045"
			strareaGbn = "고객센터왼쪽"
		case "046"
			strareaGbn = "마이페이지왼쪽"
		case "047"
			strareaGbn = "테스트왼쪽"
		case "048"
			strareaGbn = "선생님왼쪽"
		case "051"
			strareaGbn = "강의실상단"
		case "052"
			strareaGbn = "학원소개상단"
		case "053"
			strareaGbn = "자료실상단"
		case "054"
			strareaGbn = "커뮤니티상단"
		case "055"
			strareaGbn = "고객센터상단"
		case "056"
			strareaGbn = "마이페이지상단"
		case "057"
			strareaGbn = "무료강좌상단"
		case "058"
			strareaGbn = "선생님상단"
		case "060"
			strareaGbn = "선생님메인"
		case "061"
			strareaGbn = "교재소개왼쪽"
	end select
End Function %>
<!-- #include file = "../authpg_2.asp" -->