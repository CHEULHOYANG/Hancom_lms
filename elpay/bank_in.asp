<!-- #include file = "../include/set_loginfo.asp" --><% if isUsr then %>
<!-- #include file = "../include/dbcon.asp" --><%

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function

Dim moneyHap	''결제금액
Dim bycode			''강좌일련번호
Dim bycode1			''강좌일련번호
Dim paygbn			''단과,과정 구분	0:프리미엄,1:과정,2:단과
Dim idxAry,idxAry1

moneyHap = Request.Form("moneyHap")
bycode = Request.Form("bycode")
bycode1 = Request.Form("bycode1")
paygbn = Request.Form("paygbn")

Dim payTitle

if int(paygbn) < 1 then
	sql = "select strnm,intprice from PremTab where idx=" & bycode
	set dr = db.execute(sql)
	payTitle = Tag2Txt(dr(0))
	moneyHap = dr(1)
	dr.close
elseif int(paygbn) > 1 Then

	If Len(bycode) > 0 Then
	
		idxAry = split(bycode,"|")
		sql = "select strnm from LecturTab where idx=" & idxAry(0)
		set dr = db.execute(sql)
		payTitle = dr(0)
		payTitle = Tag2Txt(payTitle)
		dr.close

		if UBound(idxAry) > 0 then
			payTitle = payTitle & " 외 " & Ubound(idxAry) & "과목"
		end If
		
	End If

	If Len(bycode) = 0 And Len(bycode1) > 0 Then
	
		idxAry1 = split(bycode1,"|")
		sql = "select title from book_mast where idx=" & idxAry1(0)
		set dr = db.execute(sql)
		payTitle = dr(0)
		payTitle = Tag2Txt(payTitle)
		dr.close

		if UBound(idxAry1) > 0 then
			payTitle = payTitle & " 외 " & Ubound(idxAry1) & "개"
		end If
		
	End if	

else
	sql = "select strnm,intgigan from Lectmast where idx=" & bycode
	set dr = db.execute(sql)
	payTitle = dr(0) & "(" & dr(1) & "일과정)"
	dr.close
end if  %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>무통장입금</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<link rel="stylesheet" type="text/css" href="/img/default.css" />

<script language="javascript">
function resvBank(thefm){
	var clmn;
<%If moneyHap > 0 then%>
	clmn = thefm.usrnm;
	if(clmn.value==""){
		alert("입금하실 분의 이름을 입력해주세요!");
		clmn.focus();
		return;
	}

	if(clmn.value.replace(/ /g,"") == ""){
		alert("입금하실 분의 이름을 입력해주세요!");
		clmn.select();
		return;
	}

	clmn = thefm.bankinfo;
	if(clmn.value==""){
		alert("등록된 입금계좌가 없어서 무통장입금은 사용하실 수 없습니다.\n\n카드,실시간이체,핸드폰결제를 이용해주세요!");
		self.close();
		return;
	}
<%end if%>
thefm.submit()
}
</script>

<body style="margin:10px 0 0 10px">

<h3 class="stit">무통장 입금신청</h3>
<form name="payfm" method="post" action="pay_bank.asp" style="display:inline;">
<input type="hidden" name="cnumber" value="<%=request.Form("cnumber")%>">
<input type="hidden" name="cprice" value="<%=request.Form("cprice")%>">
<input type="hidden" name="cash" value="<%=request.Form("cash")%>">
<input type="hidden" name="moneyHap" value="<%=moneyHap%>">
<input type="hidden" name="bycode" value="<%=bycode%>">
<input type="hidden" name="buygbn" value="<%=paygbn%>">
<input type="hidden" name="paytype" value="1">
<input type="hidden" name="payTitle" value="<%=payTitle%>">
<input type="hidden" name="bycount" value="<%=request.Form("bycount")%>">

<input type="hidden" name="send_price" value="<%=request.Form("send_price")%>">
<input type="hidden" name="bycode1" value="<%=request.Form("bycode1")%>">
<input type="hidden" name="name" value="<%=request.Form("name")%>">
<input type="hidden" name="tel1" value="<%=request.Form("tel1_1")%>-<%=request.Form("tel1_2")%>-<%=request.Form("tel1_3")%>">
<input type="hidden" name="tel2" value="<%=request.Form("tel2_1")%>-<%=request.Form("tel2_2")%>-<%=request.Form("tel2_3")%>">
<input type="hidden" name="email" value="<%=request.Form("email")%>">
<input type="hidden" name="zipcode1" value="<%=request.Form("zipcode1")%>">
<input type="hidden" name="zipcode2" value="<%=request.Form("zipcode2")%>">
<input type="hidden" name="juso1" value="<%=request.Form("juso1")%>">
<input type="hidden" name="juso2" value="<%=request.Form("juso2")%>">
<input type="hidden" name="memo" value="<%=request.Form("memo")%>">
<input type="hidden" name="b_price" value="<%=request.Form("b_price")%>">
            <table class="ftbl" style="width:500px">
                <colgroup>
                <col style="width:22%" />
                <col style="width:78%" />
                </colgroup>
                <tbody>
                    <tr>
                        <th>결제금액</th>
                        <td><span class="frprice"><%=Formatnumber(moneyHap,0)%></span> 원(부가세포함)</td>
                    </tr>
<%If moneyHap > 0 then%>
                    <tr>
                        <th>입금자명</th>
                        <td><input type="text" name="usrnm" value="<%=str_User_Nm%>" class="inptxt1 w80" /></td>
                    </tr>
                    <tr>
                        <th>입금은행정보</th>
                        <td><select name="bankinfo" class="seltxt1 w300">
                  <% sql = "select bankname,banknumber,use_name from bank"
								set dr = db.execute(sql)
								if Not dr.bof or Not dr.eof then
								do until dr.eof %>
                  <option value="<%=dr(0)%> , <%=dr(1)%> , <%=dr(2)%>"><%=dr(0)%> / <%=dr(1)%> / <%=dr(2)%></option>
                  <% dr.MoveNext
								Loop
								else %>
                  <option value="">등록된 은행정보 없음</option>
                  <% end if
								dr.close %>
                </select></td>
                    </tr>
<%else%>
                    <tr>
                        <th>결제방법</th>
                        <td><strong>전액적립금결제</strong></td>
                    </tr>
<%End if%>
                </tbody>
            </table>
</form>
<%If moneyHap > 0 then%>
            <div class="cbtn"> <a href="javascript:resvBank(payfm);" class="mbtn grey">입금하기</a> <a href="javascript:self.close();" class="mbtn">취소하기</a> </div>
<%else%>
            <div class="cbtn"> <a href="javascript:resvBank(payfm);" class="mbtn grey">적립금결제</a> <a href="javascript:self.close();" class="mbtn">취소하기</a> </div>
<%End if%>

</body>
</html><% else %>
<!-- #include file = "../include/false_pg.asp" --><% end if %>