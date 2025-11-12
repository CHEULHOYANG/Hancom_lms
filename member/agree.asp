<!-- #include file = "../include/set_loginfo.asp" -->
<!-- #include file = "../include/dbcon.asp" -->
<!-- #include file="../include/head1.asp" -->

<script language="javascript">
function NumKeyOnly(){
	if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;

	if(event.keyCode==13) goReg_Member(true,document.regn);
}
function goReg_Member(){

	if(!document.agree.agreerull1.checked){
		alert("사이트이용약관을 자세히 읽어보시고 동의하셔야 합니다.");
		return;
	}

	if(!document.agree.agreerull2.checked){
		alert("개인정보처리방침을 자세히 읽어보시고 동의하셔야 합니다.");
		return;
	}

	if(!document.agree.agreerull3.checked){
		alert("개인정보의 수집 및 이용목적을 자세히 읽어보시고 동의하셔야 합니다.");
		return;
	}

	document.agree.submit();
}
function agree_all(){

	document.agree.agreerull1.checked = false;
	document.agree.agreerull2.checked = false;
	document.agree.agreerull3.checked = false;

	if (document.agree.all_checked.checked==true){
		document.agree.agreerull1.checked = true;
		document.agree.agreerull2.checked = true;
		document.agree.agreerull3.checked = true;
	}

}
</script>

<style>
.logBox1{width:980px;border-top:1px solid #ebebeb;border-left:1px solid #ebebeb;border-right:1px solid #ebebeb;border-bottom:1px solid #ebebeb;background:#f8f8f8;padding:40px 0;overflow:hidden;margin:0 0 40px 0}
.all_check{display:inline-block;float:left;font-size:17px;letter-spacing:-1px;color:#4e4e4e}
.all_agree{display:inline-block;float:right;font-size:19px;letter-spacing:-1px;font-weight:500;color:#111;}
</style>

<!-- #include file = "../include/top.asp" -->

<div class="scontent">
    	<div class="step_join">
                <ul>
                    <li class="on">약관동의<span class="step st1 mbg">POLICY AGREE</span><span class="mline"></span></li>
                    <li>회원정보 입력<span class="step st2 mbg">회원정보 입력</span><span class="mline"></span></li>
                    <li>가입완료<span class="step st3 mbg">가입완료</span></li>
                </ul>
            </div>

<form name="agree" method="post" action="<%if len(name_id) > 10 then%>ipin.asp<%else%>memberin.asp<%End if%>">

<div class="logBox1">
			<div class="ftbl_box">
				<div class="all_check">아래 모든 약관의 내용을 확인하고 전체 동의합니다.</div>
				<div class="all_agree">
					<input type="checkbox" name="all_checked" id="all_checked" onclick="agree_all();" />
					모든 약관에 동의합니다.
				</div>
			</div>
</div>

        <div class="logBox mb50">
            <h3 class="subTit">사이트이용약관</h3>
            <div class="ftbl_box">
                <div class="scroll">
<%
sql = "select neyong from guideTab where jemok ='사이트이용약관'"
set dr = db.execute(sql)
if not dr.bof or not dr.eof then 

	response.write dr(0)

else
end if
%>
                </div>
                <div class="agreeTxt">
                    <input type="checkbox" name="agreerull1" id="agreerull1"> 사이트이용약관에 동의합니다.
					</div>
            </div>
        </div>
        <div class="logBox mb50">
            <h3 class="subTit">개인정보처리방침</h3>
            <div class="ftbl_box">	
                <div class="scroll">
<%
sql = "select neyong from guideTab where jemok ='개인정보처리방침'"
set dr = db.execute(sql)
if not dr.bof or not dr.eof then 

	response.write dr(0)

else
end if
%>
                </div>
                <div class="agreeTxt">
                    <input type="checkbox" name="agreerull2" id="agreerull2"> 개인정보처리방침 동의합니다.
                </div>
            </div>
        </div>
        <div class="logBox mb50">
            <h3 class="subTit">개인정보수집및이용안내에 대한 동의</h3>
            <div class="ftbl_box">	
                <div class="scroll">
<%
sql = "select neyong from guideTab where jemok ='개인정보수집및이용안내에 대한 동의'"
set dr = db.execute(sql)
if not dr.bof or not dr.eof then 

	response.write dr(0)

else
end if
%>
                </div>
                <div class="agreeTxt">
                    <input type="checkbox" name="agreerull3" id="agreerull3"> 개인정보의 수집 및 이용목적에 동의합니다.
                </div>
            </div>
        </div>
</form>

        <div class="cbtn"> <a href="javascript:goReg_Member();" class="mbtn grey">동의하기</a><a href="/main/index.asp" class="mbtn">취소하기</a> </div>
</div>

<!-- #include file = "../include/bottom.asp" -->