<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<% if isUsr then

Dim bycode : bycode = Session("buySection")

if bycode = "" then %>
<!-- #include file = "../include/false_pg.asp" --><% else
Dim moneyHap,strnm,intgigan,u_mileage,rs

sql = "select mileage from member where id = '"& str_User_ID &"'"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
	u_mileage = rs(0)
rs.close
End if

sql = "select strnm,intprice,intgigan from Lectmast where idx=" & bycode
set dr = db.execute(sql)
strnm = dr(0)
moneyHap = dr(1)
intgigan = dr(2)
dr.close %>

<!-- #include file="../include/head1.asp" -->
<!-- #include file="../include/top.asp" -->

<script language="javascript">
function BygbnCodIn(flg,btnvalue){
	payfm.bycode.value=btnvalue;
	if(flg){
		payfm.paygbn.value=0;
	}else{
		payfm.paygbn.value=1;
	}
}

function go2Payin(pgType){
	fm = document.payfm;
	if(fm.paygbn.value==""){
		alert("수강선택을 해주세요");
		return;
	}
	if(fm.bycode.value==""){
		alert("결제내역없습니다!");
		return;
	}

	fm.payType.value=pgType;

	if ((fm.moneyHap.value==0) && (fm.cprice.value > 0)){
		var bool = confirm("쿠폰으로 결제하시겠습니까?");
		if (bool){
			fm.action = "coupon_ok.asp";
			fm.submit();
		}

	}else{

		if(parseInt(pgType,10) > 1){
			w="390";
			h="360";
			fm.action = "pay_iframe.asp";

		}else{
			w="520";
			h="500";
			fm.action = "bank_in.asp";


		}

		var l = Math.round(screen.availWidth/2)-Math.round(w/2);
		var t = Math.round(screen.availHeight/2)-Math.round(h/2);
		var sFeatures = "width=" + w + ",height=" + h + ",top=" + t + ",left=" + l + ",resizable=no";
		TG_PAY = window.open("","TG_PAY",sFeatures);
		fm.target="TG_PAY";
		fm.submit();
		TG_PAY.focus();

	}
}

function viewList(){
	var args = viewList.arguments;
	var listidx = args[0];

	var w,h
	w = 550;
	h = 500;
	var l = Math.round(screen.availWidth/2)-Math.round(w/2);
	var t = Math.round(screen.availHeight/2)-Math.round(h/2);
	var sFeatures = "width=" + w + ",height=" + h + ",top=" + t + ",left=" + l + ",resizable=no,scrollbars=1";
	var opurl = "openlist.asp?listidx=" + listidx;
	var op = window.open(opurl, "listWin", sFeatures);
	op.focus();
}


function coupon_check(){

	var f = window.document.payfm;

	f.moneyHap.value = f.moneyHap1.value;

	if(f.paygbn.value==""){
		alert("수강선택을 해주세요");
		return;
	}

	if (parseInt(f.moneyHap.value) <= 0){
			f.moneyHap.value = 0;
			alert("결제하실금액이 없으시기때문에 더이상 쿠폰을 사용하실 필요가 없습니다.\n\n무통장입금 결제수단을 클릭하시면 자동으로 쿠폰결제가 완료됩니다.");
			return;
	}

	if(f.cnum.value==""){
	alert("쿠폰번호를 정확히 입력해주세요!!");
	f.cnum.focus();
	return;
	}

	if (f.cnumber.value.indexOf(""+f.cnum.value+"") != -1){
		alert("이미 할인을 받으신 쿠폰번호입니다.");
		f.cnum.focus();
		return;
	}

	var a1 = f.cnum.value;
		$.ajax({
			url: "../xml/coupon_price_check.asp",
			type:"POST",
			data:{"key":a1},
			dataType:"text",
			cache:false,
			processData:true,
			success:function(_data){								
				var a = _data;	

				if(a == "0"){
					alert("등록된 쿠폰정보가 없습니다.");
					f.cnum.value = '';
				}
				else
				{
					alert("쿠폰할인이 적용되었습니다.");				
					f.cnumber.value = ""+ f.cnumber.value +","+a1+"";
					f.cprice.value = parseInt(f.cprice.value) + parseInt(a);

					if (parseInt(f.moneyHap.value) < 0){
						f.moneyHap.value = 0;
					}else{
						f.moneyHap.value = parseInt(f.moneyHap1.value) - parseInt(f.cash.value) - parseInt(a);
					}
					//금액이 -가 되었는지 체크후 0으로 변경
					if (parseInt(f.moneyHap.value) < 0){
						f.moneyHap.value = 0;
					}

					$('#pay_total').html(Encode_Number(f.moneyHap.value));

					f.cnum.value = '';

					if ((f.moneyHap.value==0) && (f.cprice.value > 0)){
						alert("무통장입금 결제수단을 클릭하시면 자동으로 쿠폰결제가 완료됩니다.");
					}

				}		

			},
			error:function(xhr,textStatus){
			alert("[에러]원인:"+xhr.status+"                                     ");
			}	
		});		
}
function Encode_Number(number)
  {
   if(isNaN(number) || parseInt(number,10)<0) return false;
   
   var int;
   var float="";
   var tmp;
   var ans="";
   
   if(number.indexOf(".")==-1) int=number;
   else {
    int=number.substring(0,number.indexOf("."));
 float=number.substring(number.indexOf("."),number.length);
   }

   var num=int.split("");
   
   tmp=num.reverse();

   for(a=0;a<tmp.length;a++) {
    if(!(a%3) && a!=0) {
  ans+=",";  
 }
    ans+=tmp[a];
   }

   tmp=ans.split("").reverse();
   ans="";

   for(a=0;a<tmp.length;a++) ans+=tmp[a];

   for(a=0;a<2;a++)
    if(ans.charAt(0)=="0" || ans.charAt(0)==",") ans=ans.substring(1,ans.length);

   return ans+float;
}
function onlynum(objtext1){
				var inText = objtext1.value;
				var ret;
				for (var i = 0; i < inText.length; i++) {
				    ret = inText.charCodeAt(i);
					if (!((ret > 47) && (ret < 58)))  {
						alert("숫자만을 입력해주세요.");
						objtext1.value = "";
						objtext1.focus();
						return false;
					}
				}
				return true;
}
function cash_check(){

	var f = window.document.payfm;

	f.moneyHap.value = f.moneyHap1.value;

	if(f.paygbn.value==""){
		alert("수강&교재선택을 해주세요");
		return;
	}

	if (parseInt(f.moneyHap.value) <= 0){
			f.moneyHap.value = 0;
			alert("결제하실금액이 없으시기때문에 더이상 적립금을 사용하실 필요가 없습니다.\n\n무통장입금 결제수단을 클릭하시면 자동으로 쿠폰결제가 완료됩니다.");
			return;
	}

	if(f.cash.value==""){
	alert("적립금을 정확히 입력해주세요!!");
	f.cash.focus();
	return;
	}

	if(parseInt(f.cash.value) > parseInt(<%=u_mileage%>)){
	alert("보유하신 적립금보다 많은 금액을 입력하셨습니다.");
	f.cash.value = <%=u_mileage%>;
	f.cash.focus();
	return;
	}

	if(parseInt(f.cash.value) > parseInt(f.moneyHap.value)){
	alert("결제금액만큼만 적립금을 입력해주세요.");
	f.cash.value = f.moneyHap.value;
	f.cash.focus();
	return;
	}

	var a1 = f.cash.value;

		$.ajax({
			url: "../xml/cash_price_check.asp",
			type:"POST",
			data:{"price":a1,"uid":"<%=str_User_ID%>"},
			dataType:"text",
			cache:false,
			processData:true,
			success:function(_data){								
				var a = _data;	

				if(a == "0"){
					alert("적립금오류!!");
					f.cash.value = 0;
				}
				else
				{
					alert("적립금 할인 적용되었습니다.");				

					if (parseInt(f.moneyHap.value) < 0){
						f.moneyHap.value = 0;
					}else{
						f.moneyHap.value = parseInt(f.moneyHap1.value) - parseInt(f.cprice.value) - parseInt(a);
					}

					//금액이 -가 되었는지 체크후 0으로 변경
					if (parseInt(f.moneyHap.value) < 0){
						f.moneyHap.value = 0;
					}

					$('#pay_total').html(Encode_Number(f.moneyHap.value));

					if (f.moneyHap.value==0 ){
						alert("무통장입금 결제수단을 클릭하시면 결제가 완료됩니다.");
						$('#pay_total').html("0");
					}

				}		

			},
			error:function(xhr,textStatus){
			alert("[에러]원인:"+xhr.status+"                                     ");
			}	
		});		
}
</script>

<div class="scontent">
    	<div class="logtit">
                <h4>패키지 결제하기</h4>
		</div>
        <h3 class="stit">결제상품<em>(<span class="star">*</span>구매하시려는 내용을 결제전 꼭 확인해주세요.)</em></h3>
		<table class="btbl" style="width:980px">
					<colgroup>
						<col style="width:10%" />
						<col style="width:65%" />
						<col style="width:15%" />
						<col style="width:10%" />
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>	
							<th>강좌제목</th>	
							<th>강사</th>
							<th>구성</th>
						</tr>				
					</thead>
			  <% sql = "select A.strnm,A.strteach,(select count(idx) from sectionTab where l_idx=A.idx),A.idx from LecturTab A join LectAry B on A.idx = B.lectidx where B.mastidx="& bycode & " order by B.ordn"
				set dr = db.execute(sql)
				if Not dr.Bof or Not dr.Eof then
				ii = 1
				do until dr.eof %>
						<tr>
							<td><%=ii%></td>
							<td class="tl"><%=dr(0)%></td>
							<td><%=dr(1)%></td>
							<td><%=dr(2)%>강</td>
						</tr>
<% dr.movenext
              ii = ii + 1
				Loop
				Else
				
				End If
				dr.close%>
					<tbody>
					</tbody>
				</table>

<form name="payfm" method="post" style="display:inline;">
<input type="hidden" name="bycodin" value="<%=bycode%>">

        <h3 class="stit">결제정보<em>(<span class="star">*</span>표시된 항목은 꼭 입력해 주셔야 가입이 가능합니다.)</em></h3>
        <table class="ftbl" style="width:980px">
				<colgroup>
					<col style="width:22%" />
					<col style="width:78%" />																		
				</colgroup>
				<tbody>
					<tr>
						<th>결제상품</th>
						<td><strong><%=strnm%></strong></td>
					</tr>

					<tr>
						<th>결제금액</th>
						<td><strong class="frprice" id="pay_total"><%=formatnumber(moneyHap,0)%></strong></td>
					</tr>

					<tr>
						<th>할인쿠폰 정보입력</th>
						<td><input type="text" id="cnum" name="cnum" class="inptxt1" />
							<a href="javascript:coupon_check();" class="fbtn">입력확인</a></td>
					</tr>

					<tr>
						<th>적립금</th>
						<td><input type="text" id="cash" name="cash" class="inptxt1" value="0" onkeyup="onlynum(payfm.cash);" />
							<a href="javascript:cash_check();" class="fbtn">입력확인</a> <span class="fr">(보유적립금 : <%=FormatNumber(u_mileage,0)%>원)</span></td>
					</tr>

				</tbody>
			</table>
<input type="hidden" name="moneyHap1" id="moneyHap1" value="<%=moneyHap%>">
<input type="hidden" name="moneyHap" value="<%=moneyHap%>">
<input type="hidden" name="paygbn" value="1">
<input type="hidden" name="bycode" value="<%=bycode%>">
<input type="hidden" name="payType">
<input type="hidden" name="cnumber" id="cnumber" value="" />
<input type="hidden" name="cprice" id="cprice" value="0" />
</form>

        <div class="cbtn"> 
		<a href="javascript:go2Payin(2);" class="mbtn grey">신용카드/체크카드결제</a><a href="javascript:go2Payin(1);" class="mbtn blue">무통장입금하기</a> <a href="javascript:go2Payin(4);" class="mbtn red">실시간계좌이체하기</a> 
		<!--
		<a href="javascript:go2Payin(3);" class="mbtn green">휴대폰소액결제하기</a> 
		!-->
		</div>

    </div>

<%If Int(moneyHap) = 0 then%>
<script>
function free_go(){
	var fm = window.document.payfm;
	fm.action = "pay_mst_free_ok.asp";
	fm.submit();
}
free_go();
</script>
<%End if%>

<!-- #include file="../include/bottom.asp" --><% end if
else %>
<!-- #include file = "../include/false_pg.asp" --><% end if
Session.Abandon %>