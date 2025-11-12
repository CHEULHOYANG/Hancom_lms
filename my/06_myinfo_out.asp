<!-- #include file="../include/set_loginfo.asp" -->
<% if  isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<!-- #include file="../include/head1.asp" -->

<script language="javascript">
function TxtChk_Length(obj){
	var objlen = obj.value.length;
	spanID.innerHTML = "<b>" + objlen + "</b>";

	if(objlen > 150){
		alert("150자 이내로 입력하세요");
		obj.value = obj.value.substring(0,150);
		spanID.innerHTML = "<b>" + obj.value.length + "</b>";
		return false;
	}
}
</script>

<!-- #include file="../include/top.asp" -->

<div class="smain">    
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3>회원탈퇴</h3>
        </div>
        <div class="scont">
        	                    <ul class="outTxt">
                        <li>회원탈퇴를 신청하시면 해당 아이디는 <strong>즉시 탈퇴처리</strong>됩니다.</li>
                        <li>회원탈퇴후, <strong>14일동안은 회원가입이 불가능</strong>합니다. 탈퇴와 재가입을 통해 아이디를 교체하면서 일반 이용자들께 피해를 끼치는 행위를 방지하기 위한 조치이오니 넓은 양해 바랍니다. </li>
                        <li>회원탈퇴 즉시, 회원정보는 즉시 삭제되며 단, 아래의 <strong>공공적 성격의 게시물</strong>은 탈퇴후에도 삭제되지 않습니다. 탈퇴후에도 회원정보 삭제로 인해 작성자 본인을 확인할 수 없기 때문에 게시물 등의 삭제를 원하시는 경우에는 반드시 먼저 게시물을 삭제하신 후,탈퇴를 신청하시기 바랍니다.</li>
                        <li>- 게시판 : 타인과 함께 사용하는 공적인 영역의 게시물과 댓글, 의견 등<br />
                            - 구매내역 : 결제내역및 사용정보<br />
                            - 진도현황 : 강의진도및 접속내역</li>
                        <li>개인정보 취급방침에 따라 불량이용 및 이용제한에 관한 기록은 3개월동안 삭제되지 않고 보관됩니다.</li>
                    </ul>
<form name="outfm" method="post" action="myinfo_out_ok.asp" style="display:inline;">
			<div class="outList">
                            <ul>
                                <li><input type="checkbox" name="out_reason" id="out_reason" value="자료의 질이 낮음">&nbsp;자료의 질이 낮음</li>
                                <li><input type="checkbox" name="out_reason" id="out_reason" value="자료의 부족">&nbsp;자료의 부족</li>
                            </ul>
                            <ul>
                                <li><input type="checkbox" name="out_reason" id="out_reason" value="동영상 재생불만">&nbsp;동영상 재생불만</li>
                                <li><input type="checkbox" name="out_reason" id="out_reason" value="AS불만">&nbsp;AS불만</li>
                            </ul>
                            <ul>
                                <li><input type="checkbox" name="out_reason" id="out_reason" value="개인정보유출 우려">&nbsp;개인정보유출 우려</li>
                                <li><input type="checkbox" name="out_reason" id="out_reason" value="사이트 컨텐츠 빈약">&nbsp;사이트 컨텐츠 빈약</li>
                            </ul>
                            <ul>
                                <li><input type="checkbox" name="out_reason" id="out_reason" value="이용빈도 적음">&nbsp;이용빈도 적음</li>
                                <li><input type="checkbox" name="out_reason" id="out_reason" value="기타">&nbsp;기타</li>
                            </ul>
                        </div>
						<dl class="outre">
                            <dt>회원님의 진심어린 충고한마디 부탁드립니다.</dt>
                            <dd><textarea name="replcont" id="replcont" cols="45" rows="5" class="txtarea" onKeyup="TxtChk_Length(this);" style="width:96%"></textarea></dd>
                            <dd class="stip">기타의견은 250자 내외로 입력하실 수 있습니다. <strong  ID="spanID">0</strong>/250Byte</dd>
                        </dl>
</form>

            <div class="cbtn"> <a href="javascript:if(confirm('정말로 회원탈퇴하시겠습니까?')) document.outfm.submit();" class="mbtn grey">탈퇴하기</a> </div>

        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" -->
<% else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>