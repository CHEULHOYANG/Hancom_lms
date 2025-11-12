<!-- #include file = "../include/set_loginfo.asp" --><% if isUsr then %>
<!-- #include file = "../include/dbcon.asp" --><%
Dim ordIdx
ordIdx = Request("ordidx")

sql = "select usrnm,paytitle,bkinfo,nprice from bank_order where idx=" & ordIdx
set dr = db.execute(sql)
Dim usrnm,paytitle,bkinfoAry,nprice
usrnm = dr(0)
paytitle = dr(1)
bkinfoAry = split(dr(2),",")
nprice =  dr(3)
dr.close
set dr = nothing
db.close
set db = nothing %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>무통장입금</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<link rel="stylesheet" type="text/css" href="/img/default.css" />

<body style="margin:10px 0 0 10px">

<h3 class="stit">무통장 입금신청</h3>
            <table class="ftbl" style="width:500px">
                <colgroup>
                <col style="width:22%" />
                <col style="width:78%" />
                </colgroup>
                <tbody>
                    <tr>
                        <th>결제금액</th>
                        <td><span class="frprice"><%=Formatnumber(nprice,0)%></span> 원(부가세포함)</td>
                    </tr>
                    <tr>
                        <th>입금자명</th>
                        <td><%=usrnm%></td>
                    </tr>
                    <tr>
                        <th>입금은행정보</th>
                        <td><%=bkinfoAry(0)%>&nbsp;<%=bkinfoAry(1)%>&nbsp;<%=bkinfoAry(2)%></td>
                    </tr>
                </tbody>
            </table>

			<div class="cbtn"> <a href="javascript:self.close();" class="mbtn">창닫기</a> </div>

			<ul class="free">
				<li class="cont"><span><strong class="fr">입금하신후 </strong>고객센터(<%=help_tel%>)로 문의주시기 바랍니다.</span></li>
				<li class="cont"><span>입금 확인 후 1시간 이내에 처리됩니다.</span></li>
			</ul>

</body>
</html>
<script>
opener.self.location.href='/my/02_paylist.asp';
</script>
<% else %>
<!-- #include file = "../include/false_pg.asp" --><% end if %>