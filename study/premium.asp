<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<% Dim nowPage : nowPage = Request("URL") %>
<!-- #include file="../include/head1.asp" -->


<script language="javascript">
function go2PrimBuy(flg,idx){
	if(flg){
		location.href="../member/login.asp?str__Page=" + encodeURIComponent("<%=nowPage%>");
	}else{
		var params = "key=" + encodeURIComponent(idx);
		sndReq("primbuyxml.asp",params,setPrimBuy,"POST");
	}
}

function setPrimBuy(){
	if(objXmlhttp.readyState == 4){
		if(objXmlhttp.status==200){
			var xmlDoc = objXmlhttp.responseXML;
			var obj = xmlDoc.getElementsByTagName("isrows");
			var flg =eval(obj[0].getAttribute("flg"));
			var bygbn = obj[0].getAttribute("bygbn");
			bygbn = parseInt(bygbn,10);

			if(flg && bygbn == 2 ){
				location.href="../elpay/pay_prim.asp";
			}else{
				var strMsg = "Error : 로그인 하지 않았거나, 네트웍에러";
				if(bygbn > 0)  strMsg = "프리미엄을 수강하고 있으므로 과정강좌를 구매하실 필요없습니다!";
				alert(strMsg);
			}
		}else{
			alert("네트웍 오류 : 개발자에게 문의하세요!");
		}
	}
}
</script>

<!-- #include file="../include/top.asp" -->
<div class="smain">  
	<!-- #include file="left.asp" -->
	<div class="content">
    	
        <div class="scont">

            <div class="prBox">
				<span class="mbg pretit">프리미엄내용</span>
				<table class="stbl" style="width:550px">
						<colgroup>
							<col style="width:40%" />
							<col style="width:18%" />
							<col style="width:18%" />
							<col style="width:24%" />
						</colgroup>
						<tbody>	
<%
Dim p_count

sql="select count(idx) from premTab"
set dr = db.execute(sql)

p_count = dr(0)
dr.close

sql="select idx,strnm,intgigan,intprice from premTab order by idx"
set dr = db.execute(sql)

if not dr.bof or not dr.eof then
isRows = split(dr.getString(2),chr(13)) 

	for ii = 0 to UBound(isRows) - 1
	isCols = split(isRows(ii),chr(9))
%>			
							<tr>
								<th <%If ii+1 = p_count Then Response.write "class='brn'" End if%>><%=isCols(1)%></th>
								<td <%If ii+1 = p_count Then Response.write "class='brn'" End if%>>기간 : <%=isCols(2)%>일</td>
								<td <%If ii+1 = p_count Then Response.write "class='brn'" End if%>><strong class="fr"><%=formatnumber(isCols(3),0)%></strong>원</td>
								<td <%If ii+1 = p_count Then Response.write "class='brn'" End if%>><a href="javascript:go2PrimBuy(<%=strProg%>,'<%=isCols(0)%>');" class="btn"><span class="sico mbg"></span>신청하기</a></td>
							</tr>	
<%
	Next
Else
End if
%>							
						</tbody>
					</table>
			</div>
        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" -->