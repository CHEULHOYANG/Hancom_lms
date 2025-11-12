<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim count1,count2,bdate
dim sql,rs
sql="select count(idx) from member where email_res=1"
set rs=db.execute(sql)

count1=rs(0)
rs.close

bdate = left(now(),10)
bdate = split(bdate,"-")

sql="select count(idx) from member where b_year='"& bdate(0) &"' and b_month='"& bdate(1) &"' and b_day='"& bdate(2) &"' "
set rs=db.execute(sql)

count2=rs(0)
rs.close
%>
<!--#include file="../main/top.asp"-->

<script language="javascript">
function admin_mail_send(){
	var f = window.document.mail;
	if(f.FORM_title.value==""){
	alert("메일링 제목을 입력해주세요.");
	f.FORM_title.focus();
	return;
	}

	clmn = f.FORM_Content;
	clmn.value = nicEditors.findEditor('FORM_Content').getContent();
	if(clmn.value==""  || clmn.value=="<br>") {
	alert("내용을 입력해주세요");
	return;
	}

	if(f.from_email.value==""){
	alert("보내는 사람의 메일주소를 입력해주세요.");
	f.from_email.focus();
	return;
	}
	f.submit();
}
</script>

<script type="text/javascript" src="/nicedit/nicEdit.js"></script>
<script type="text/javascript">
bkLib.onDomLoaded(function() {
	new nicEditor({fullPanel : true}).panelInstance('FORM_Content');
});
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>이메일발송관리</h2>
		<form name="mail" method="post" action="mlist_ok.asp">
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>수신회원</th>
						<td><input type="radio" name="groub" value="1" checked> 오늘 생일회원 (<%=count2%>명)<br />
						<input type="radio" name="groub" value="2"> 메일링 수신허가회원 (<%=count1%>명)<br />
						<input type="radio" name="groub" value="3"> 이메일입력 &nbsp;<input type="text" name="to_email" class="inptxt1 w300" size="40"></td>
					</tr>
					<tr>
						<th>제목</th>
						<td><input name="FORM_title" type="text" class="inptxt1 w400" id="FORM_title" size="80"></td>
					</tr>
					<tr>
						<th>내용</th>
						<td><a href="javascript:popenWindow('/nicedit/upimg.asp?box=FORM_Content','390','290');"><img src="../../nicedit/bt1.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/vod.asp?box=FORM_Content','390','290');"><img src="../../nicedit/bt2.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/files.asp?box=FORM_Content','390','290');"><img src="../../nicedit/bt3.gif" border="0"></a>
                          <textarea name="FORM_Content" id="FORM_Content" rows="2" cols="20" style="width:580px; height:200px;"></textarea></td>
					</tr>
					<tr>
						<th>발송이메일주소</th>
						<td><input name="from_email" type="text" class="inptxt1" id="from_email" size="40"></td>
					</tr>
				</tbody>
			</table>
		</form>
		<div class="rbtn">
			<a href="javascript:admin_mail_send();" class="btn">발송하기</a>
		</div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->