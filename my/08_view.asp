<!-- #include file="../include/set_loginfo.asp" -->
<% if  isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
Dim idx,id,buygbn,tabidx,categbn,title,regdate,sday,eday,paytype,intprice,payday,yy,mm,dd,state,holdgbn,holdsday,holdeday,holdil,bankidx,otp,cnumber,cprice,bookidx,u_name,u_tel1,u_tel2,u_zipcode1,u_zipcode2,u_juso1,u_juso2,u_memo,u_state,u_tak_info1,u_tak_info2,u_return,send_price,u_email,order_id,reply_ok,bcount,cash

idx = request("idx")

sql = "select idx,id,buygbn,tabidx,categbn,title,regdate,sday,eday,paytype=dbo.PayTypeStr(paytype),intprice,payday,yy,mm,dd,state,holdgbn,holdsday,holdeday,holdil,bankidx,otp,cnumber,cprice,bookidx,s_name,s_tel1,s_tel2,s_zipcode1,s_zipcode2,s_juso1,s_juso2,s_memo,s_state,s_tak_info1,s_tak_info2,s_return,send_price,s_email,order_id,reply_ok,bcount,cash from order_mast where bookidx=1 and id='" & str_User_ID & "' and idx = "& idx
set dr = db.execute(sql)

If dr.eof Or dr.bof Then

	response.write"<script>"
	response.write"alert('데이터에러');"
	response.write"self.location.href='08_list.asp?intpg="& request("intpg") &"';"
	response.write"</script>"
	response.end

Else

	idx = dr(0)
	id = dr(1)
	buygbn = dr(2)
	tabidx = dr(3)
	categbn = dr(4)
	title = dr(5)
	regdate	= dr(6)
	sday = dr(7)
	eday = dr(8)
	paytype = dr(9)
	intprice = dr(10)
	payday = dr(11)
	yy = dr(12)
	mm = dr(13)
	dd = dr(14)
	state = dr(15)
	holdgbn = dr(16)
	holdsday = dr(17)
	holdeday = dr(18)
	holdil = dr(19)
	bankidx = dr(20)
	otp = dr(21)
	cnumber = dr(22)
	cprice = dr(23)
	bookidx = dr(24)
	u_name = dr(25)
	u_tel1 = dr(26)
	u_tel2 = dr(27)
	u_zipcode1 = dr(28)
	u_zipcode2 = dr(29)
	u_juso1 = dr(30)
	u_juso2 = dr(31)
	u_memo = dr(32)
	u_state = dr(33)
	u_tak_info1 = dr(34)
	u_tak_info2 = dr(35)
	u_return = dr(36)
	send_price = dr(37)
	u_email = dr(38)
	order_id = dr(39)
	reply_ok = dr(40)
	bcount = dr(41)
	cash = dr(42)

dr.close
End If

%>
<!-- #include file="../include/head1.asp" -->



<script>
function openWindow4(url,width,height,lefts) {
	var widths = width;
	var heights = height;
	var top = 30; // 창이 뜰 위치 지정
	var left = 30;
	var temp2 = 'toolbar=no, scrollbars=yes, width='+widths+',height='+heights+',top='+top+',left='+left;
	var temp = url;
	window.open(temp, 'bill', temp2);
}
</script>

<!-- #include file="../include/top.asp" -->

<div class="smain">    
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3>주문/배송조회</h3>
        </div>
        <div class="scont">

            <h3 class="stit">주문정보</h3>
            <table class="ftbl" style="width:830px">
                <colgroup>
                <col style="width:22%" />
                <col style="width:78%" />
                </colgroup>
                <tbody>
                    <tr>
                        <th>주문번호</th>
                        <td><strong><%=order_id%></strong></td>
                    </tr>
                    <tr>
                        <th>상품명</th>
                        <td><strong><%=title%></strong></td>
                    </tr>
<%If state = 0 Or state = 2 then%>
                    <tr>
                        <th>배송현황</th>
                        <td><font color="CC0000"><%If u_state = 0 Then response.write"배송전" End if%><%If u_state = 1 Then response.write"배송중" End if%><%If u_state = 2 Then response.write"배송완료" End if%><%If u_state = 3 Then response.write"주문취소" End if%><%If u_state = 4 Then response.write"환불" End if%><%If u_state = 5 Then response.write"반품" End if%></font></td>
                    </tr>
<%End if%>
<%If u_state = 1 Then%>
                    <tr>
                        <th>배송정보</th>
                        <td>택배사 : <%=u_tak_info1%>&nbsp;/&nbsp;운송장번호 : <%=u_tak_info2%></td>
                    </tr>
<%End if%>
                    <tr>
                        <th>주문수량</th>
                        <td><%=bcount%>개</td>
                    </tr>
                </tbody>
            </table>

            <h3 class="stit">배송지정보</h3>
            <table class="ftbl" style="width:830px">
                <colgroup>
                <col style="width:22%" />
                <col style="width:78%" />
                </colgroup>
                <tbody>
					<tr>
						<th>받으시는분</th>
						<td><strong><%=u_name%></strong></td>
					</tr>
					<tr>
						<th>휴대전화번호</th>
						<td><%=u_tel1%></td>
					</tr>

					<tr>
						<th>주소</th>
						<td>[<%=u_zipcode1%>]&nbsp;<%=u_juso1%>&nbsp;<%=u_juso2%></td>
					</tr>
					<tr>
						<th>이메일주소</th>
						<td><%=u_email%></td>		
					</tr>	
					<tr>
						<th>요청사항</th>
						<td><%=u_memo%></td>		
					</tr>
                </tbody>
            </table>

            <h3 class="stit">결제정보</h3>
            <table class="ftbl" style="width:830px">
                <colgroup>
                <col style="width:22%" />
                <col style="width:78%" />
                </colgroup>
                <tbody>
					<tr>
						<th>결제상태</th>
						<td><%if state=0 or state=2 then%>결제완료<%else%>결제대기중<%end if%></td>
					</tr>
					<tr>
						<th>결제수단</th>
						<td><%=paytype%></td>
					</tr>
					<tr>
						<th>결제금액</th>
						<td><font color="FF6633"><%=FormatNumber(intprice,0)%>원</font></td>		
					</tr>	
					<tr>
						<th>배송비</th>
						<td>+ <%=FormatNumber(send_price,0)%>원</td>		
					</tr>
					<tr>
						<th>할인금액</th>
						<td>- <%=FormatNumber(cprice,0)%>원</td>		
					</tr>
					<tr>
						<th>적립금 </th>
						<td>- <%=FormatNumber(cash,0)%>원</td>		
					</tr>
					<tr>
						<th>최종결제금액</th>
						<td><strong><%=FormatNumber((intprice-cprice-cash)+send_price,0)%>원</strong></td>		
					</tr>
                </tbody>
            </table>

            <div class="cbtn">
		<%If u_state = 0 And (state=0 or state=2) Then%>
			<a href="04_qwrite.asp?t=[<%=order_id%>]주문취소신청&c=취소사유작성:" class="mbtn red">주문취소신청</a>
		<%End if%>
		<%If u_state = 2 And reply_ok=0 Then%>
			<a href="04_qwrite.asp?t=[<%=order_id%>]반품신청&c=반품사유작성:" class="mbtn grey">반품신청</a>
			<a href="04_qwrite.asp?t=[<%=order_id%>]환불신청&c=환불사유작성:" class="mbtn grey">환불신청</a>
			<a href="08_end.asp?order_id=<%=order_id%>" class="mbtn">구매확인하기</a>
		<%End if%>
		<%if state=0 or state=2 then%>
			<a href="javascript:openWindow4('bill.asp?order_id=<%=order_id%>','457','550');" class="mbtn grey">영수증인쇄</a>
		<%End if%>
		<%if u_state = 0 then%>
			<a href="04_qwrite.asp?t=[<%=order_id%>]배송지정보변경신청&c=변경하실주소:" class="mbtn grey">배송지주소변경</a>
		<%End if%>
			<a href="08_list.asp?intpg=<%=request("intpg")%>" class="mbtn">목록으로</a>
			</div>

        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" -->
<% else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>