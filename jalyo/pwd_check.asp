<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file = "../include/dbcon.asp" -->
<%
dim tabnm : tabnm = Request("tabnm")
dim idx,intpg
idx = request("idx")
intpg = request("intpg")

Dim bbsJemok,pgbn,ygbn,mgbn
sql = "select jemok,pgbn,ygbn,mgbn from board_mast where idx=" & tabnm
set dr = db.execute(sql)
bbsJemok = dr(0)
pgbn = dr(1)
ygbn = dr(2)
mgbn = dr(3)
dr.close

Dim title,writer,content,re_step,re_level,ref
Dim repage : repage = "list.asp?tabnm=" & tabnm & "&intpg=" & intpg
%>
<!-- #include file="../include/head1.asp" -->

<script language="javascript">
function go2WriteOk(theform){
	var clmn;
	clmn = theform.user_pwd;
	if(clmn.value==""){
		alert("비밀번호를 입력해주세요!");
		clmn.focus();
		return;
	}

	theform.submit();
}
</script>

<!-- #include file="../include/top.asp" -->

<div class="smain">    
	<!-- #include file="left.asp" -->	
    <div class="content">
    	<div class="cont_tit">
        	<h3><%=bbsJemok%></h3>
        </div>
        <div class="scont">
<form name="fm" action="content.asp" method="post" style="display:inline;">
<input type="hidden" name="tabnm" value="<%=request("tabnm")%>">
<input type="hidden" name="gbnS" value="<%=request("gbnS")%>">
<input type="hidden" name="strPart" value="<%=request("strPart")%>">
<input type="hidden" name="strSearch" value="<%=request("strSearch")%>">
<input type="hidden" name="intpg" value="<%=request("intpg")%>">	
<input type="hidden" name="idx" value="<%=request("idx")%>">
            <table class="ftbl" style="width:830px">
                <colgroup>
                <col style="width:22%" />
                <col style="width:78%" />
                </colgroup>
                <tbody>
                    <tr>
                        <th>비밀번호</th>
                        <td><input name="user_pwd" type="password" id="writer" class="inptxt1 w100"></td>
                    </tr>
                </tbody>
            </table>
</form>
            <div class="cbtn"> <a href="javascript:go2WriteOk(fm);" class="mbtn grey">입력완료</a> <a href="<%=repage%>" class="mbtn">취소하기</a> </div>
        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" -->