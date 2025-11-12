<!-- #include file="../include/set_loginfo.asp" -->
<% if  isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
sql = "select idx,id,pwd,name,juminno1,juminno2,tel1,tel2,email,zipcode1,zipcode2,juso1,juso2,b_year,b_month,b_day,b_type,sms_res,email_res from member where id='" & str_User_ID & "'"
dim idx,id,pwd,name,juminno1,juminno2,tel1,tel2,email,zipcode1,zipcode2,juso1,juso2,b_year,b_month,b_day,b_type,sms_res,email_res
set dr = db.execute(sql)
idx = dr(0)
id = dr(1)
pwd = dr(2)
name = dr(3)
juminno1 = dr(4)
juminno2 = dr(5)
tel1 = split(dr(6),"-")
tel2 = split(dr(7),"-")
email = dr(8)
zipcode1 = dr(9)
zipcode2 = dr(10)
juso1 = dr(11)
juso2 = dr(12)
b_year = dr(13)
b_month = dr(14)
b_day = dr(15)
b_type = dr(16)
sms_res = dr(17)
email_res = dr(18)
dr.close %>
<!-- #include file="../include/head1.asp" -->

<script language="javascript">
function goReg_Member(theform){

	var clmn;

	clmn = theform.cnum;
	if(clmn.value==""){
		alert("쿠폰번호 입력해주세요!");
		clmn.focus();
		return;
	}
	
	document.regfm.submit();
}
</script>

<!-- #include file="../include/top.asp" -->

<div class="smain">    
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3>무료수강쿠폰등록</h3>
        </div>
        <div class="scont">

<form name="regfm" action="07_coupon_ok.asp" method="post" style="display:inline;">
            <table class="ftbl" style="width:830px">
                <colgroup>
                <col style="width:22%" />
                <col style="width:78%" />
                </colgroup>
                <tbody>
                    <tr>
                        <th>쿠폰번호</th>
                        <td><input type="text" id="cnum" name="cnum" class="inptxt1 w500" /></td>
                    </tr>
                </tbody>
            </table>
</form>

            <div class="cbtn"> <a href="javascript:goReg_Member(regfm);" class="mbtn grey">쿠폰번호등록</a> </div>

			<ul class="free">
				<li class="cont"><span><strong class="fr">쿠폰번호</strong>를 정확히 입력해주시기 바랍니다.</span></li>
				<li class="cont"><span>입력후 구매강의목록에서 강좌를 보실수 있습니다.</span></li>
			</ul>

        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" -->
<% else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>