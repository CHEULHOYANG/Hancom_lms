<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,isRecod,isRows,isCols
Dim intpg,blockPage,pagecount,recordcount,lyno

Dim nowPage : nowPage = Request("URL")

intpg = Request("intpg")
if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

const pagesize = 20
Dim strClmn : strClmn = "  idx,id,uname,reason,etc,juminno,regdate "

sql = "select Count(idx) from mem_out"
set dr = db.execute(sql)
recordcount = int(dr(0))
dr.close

if recordcount > 0 then
	isRecod = True
	pagecount=int((recordcount-1)/pagesize)+1
	lyno = recordcount - ((intpg - 1) * pagesize)
	sql = "select  top " & pagesize & strClmn & "from mem_out where idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from mem_out order by idx desc) order by idx desc"
end if
%>
<!--#include file="../main/top.asp"-->

<script language="javascript">
function go2ListPage(pg){
	document.location.href="<%=nowPage%>?intpg=" + pg;
}

function delteAll(chkobj){
	var checkgbn = true;
	if(chkobj.length){
		for(i=0;i<chkobj.length;i++){
			if(chkobj[i].checked){
				checkgbn = false;
				break;
			}
		}
	}else{
		if(chkobj.checked){
			checkgbn = false;
		}
	}

	if(checkgbn){
		alert("삭제하실 회원을 선택해주세요!");
		return;
	}

	delok = confirm("체크한 회원을 삭제합니다");
	if(delok){
		document.chfm.submit();
	}
}

function AllCheck(thisimg,chekID){
	var srcAry = thisimg.src.split("/");
	if(srcAry[srcAry.length-1] == "noncheck.gif"){
		thisimg.src = "../rad_img/img/allcheck.gif";
		isChecked(true,chekID);
	}else{
		thisimg.src = "../rad_img/img/noncheck.gif";
		isChecked(false,chekID);
	}
}

function isChecked(cmd,chekID){
	var chekLen=chekID.length;
	if(chekLen){
		for (i=0;i<chekLen;i++){
			chekID[i].checked=cmd;
		}
	}
	else{
		chekID.checked=cmd;
	}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>탈퇴회원관리</h2>
<% if isRecod then
				set dr = db.execute(sql)
				isRows = split(dr.GetString(2),chr(13)) 
%>
<form name="chfm" action="deletemember.asp" method="post" style="display:inline;">
<input type="hidden" name="backpg" value="m">
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:5%" />
			<col style="width:10%" />
			<col style="width:10%" />
			<col />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th><img src="../rad_img/img/noncheck.gif" style="cursor:pointer;" onClick="AllCheck(this,document.all.idx);"></th>	
					<th>아이디</th>
					<th>이름</th>
					<th>탈퇴사유</th>	
					<th>등록일</th>									
				</tr>				
			</thead>
			<tbody>
<% for ii = 0 to UBound(isRows) - 1
						isCols = split(isRows(ii),chr(9)) %>
				<tr>
					<td><input type="checkbox" name="idx" value="<%=isCols(0)%>|<%=isCols(1)%>"></td>
					<td><%=isCols(1)%></td>
					<td><%=isCols(2)%></td>
					<td><%=isCols(3)%> / <%=isCols(4)%></td>
					<td><%=formatdatetime(isCols(6),2)%></td>
				</tr>
<% lyno = lyno - 1
						Next %>
			</tbody>
		</table>

		<div class="tbl_btm mb80">
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
			<div class="rbtn">
				<a href="javascript:delteAll(document.all.idx);" class="btn">선택삭제</a>
			</div>
		</div>

<%End if%>

	<div class="caution"><p>탈퇴 신청된 회원목록에서 삭제를 하시면 복구가 불가능합니다.</p></div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->