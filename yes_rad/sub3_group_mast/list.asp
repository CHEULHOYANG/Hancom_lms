<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,rs,idx,title,g_mem,rs1,gu
%>
<!--#include file="../main/top.asp"-->

<script>
function viewLecGow(){

		 TG_PAY = window.open("","yesoft_quiz", "width=770,height=500,top=0,left=0,scrollbars=no,resizable=no,titlebar=no");
		 TG_PAY.focus();        
		 document.chfm.target="yesoft_quiz";
		 document.chfm.action="setinput.asp";
		 document.chfm.submit();

}

function list_del(idx){
		var bool = confirm("삭제하시겠습니까?");
		if (bool){
			location.href = "del.asp?idx="+idx+"&gu=<%=request("gu")%>";
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
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span><%If request("gu") = "0" Then Response.write"회원" End if%><%If request("gu") = "1" Then Response.write"문자" End if%> 그룹관리</h2>

		<div class="tbl_top">
			<a href="write.asp?gu=<%=request("gu")%>" class="fbtn1">그룹등록</a>
			<%If request("gu")=0 then%><a href="javascript:viewLecGow('<%=idx%>');" class="fbtn2">수강등록</a><%End if%>
		</div>

<form name="chfm" action="setinput.asp" method="post">	
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:5%" />
			<col />
			<col style="width:10%" />
			<col style="width:15%" />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th><img src="../rad_img/img/noncheck.gif" style="cursor:pointer;" onClick="AllCheck(this,document.all.idx);"></th>	
					<th>그룹명</th>
					<th>회원수</th>
					<th>회원목록저장</th>	
					<th>기능</th>								
				</tr>				
			</thead>
			<tbody>
<%
sql="select idx,title,gu from group_mast where gu = "& request("gu") &" order by idx desc"
set rs=db.execute(sql)

if rs.eof or rs.bof then

else
do until rs.eof 

idx = rs(0)
title = rs(1)

if rs(2) = 0 then
sql="select count(idx) from member where sp1 = '"& idx &"'"
elseif rs(2) = 1 then
sql="select count(idx) from member where sp2 = '"& idx &"'"
elseif rs(2) = 2 then
sql="select count(idx) from member where sp3 = '"& idx &"'"
end if
set rs1 = db.execute(sql)

g_mem = rs1(0)
%>
				<tr>
					<td><input type="checkbox" name="idx" value="<%=rs(0)%>"></td>
					<td class="tl"><%=title%></td>
					<td><%=g_mem%>명</td>
					<td><a href="list_excel.asp?gm=<%=idx%>&gu=<%=request("gu")%>" class="sbtn">엑셀로저장하기</a></td>
					<td><a href="edit.asp?idx=<%=idx%>&gu=<%=request("gu")%>" class="btns trans">수정</a>
<a href="javascript:list_del('<%=idx%>');" class="btns">삭제</a></td>
					
				</tr>
<%
rs.movenext
loop
rs.close
end if
%>
			</tbody>
		</table>
</form>

<%If request("gu") = 0 then%>
		<div class="caution"><p>그룹을 선택해서 일괄적으로 수강등록을 하실수가 있습니다.</p></div>
		<div class="caution"><p>등록된 회원그룹은 시험/강의신청에서 기능제한을 목적으로 사용이 가능합니다.</p></div>
<%else%>
	<div class="caution"><p>그룹을 만드신후 회원목록에서 문자그룹을 설정해주시면 그룹별로 문자를 발송할수 있습니다.</p></div>
<%End if%>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->