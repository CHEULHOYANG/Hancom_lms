<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<% 
Dim dntGbn : dntGbn = request("dntGbn")
Dim dntNm
Dim dntRecod,dntRows,dntCols
dim icon,icon_count,jj,bc,jj_count,ba
Dim ca1_name,ca2_name
Dim top_img1,top_img2
Dim tabnm : tabnm = "LecturTab"
Dim sPattern : sPattern = "[<][^>]*[>]"
Dim strClmn : strClmn = " idx,strnm,strteach,intprice,totalnum,sjin=case sajin when 'noimg.gif' then 'noimage.gif' else sajin end,intgigan,tinfo,icon,book_idx,sub_title,mem_group,dbo.order_mast_count_dan(idx,'"& str_User_ID &"'),dbo.order_mast_count_pass(idx,'"& str_User_ID &"') "
Dim nowPage : nowPage = Request("URL")

If Len(request("ca1")) = 0 Then

	ca1_name = "수강신청"

else

	sql = "select title,img from dan_category where idx=" & request("ca1")
	set dr = db.execute(sql)
	If dr.eof Or dr.bof Then
		ca1_name = ""
		top_img1 = ""
	else
		ca1_name = dr(0)
		top_img1 = dr(1)
	dr.close
	End if
	

	sql = "select idx,title from dan_category where deep=1 and uidx="& request("ca1") &" order by ordnum asc,idx desc"
	set dr = db.execute(sql)

	if not dr.bof or not dr.eof then
		dntRecod = True
		dntRows = split(dr.getstring(2),chr(13))
		dntCols = split(dntRows(0),chr(9))

		if dntGbn = "" then
			dntGbn = dntCols(0)
		end if
	end if
	dr.close

End if

If Len(request("ca2")) > 0 Then

	sql = "select title,img from dan_category where idx=" & request("ca2")
	set dr = db.execute(sql)

	If dr.eof Or dr.bof Then
		ca2_name = ""
		top_img2 = ""
	else
		ca2_name = dr(0)
		top_img2 = dr(1)
	dr.close
	End if
	
End If

Dim user_group

If Len(str_User_ID) > 0 Then

	sql = "select sp1 from member where id = '"& str_User_ID &"'"
	Set rs = db.execute(sql)

	If rs.eof Or rs.bof Then
	Else
		user_group = rs(0)
	rs.close
	End if

End if

Public Function RegExpReplace(byval Patrn,byval  TrgtStr,byval RplcStr)
	Dim ObjRegExp
	On Error Resume Next
	Set ObjRegExp = New RegExp
	ObjRegExp.Pattern = Patrn
	ObjRegExp.Global = True
	ObjRegExp.IgnoreCase = True
	RegExpReplace = ObjRegExp.Replace(TrgtStr, RplcStr)
	Set ObjRegExp = Nothing
End Function

Function cutStr(str, cutLen)
	Dim strLen, strByte, strCut, strRes, char, i
	strLen = 0
	strByte = 0
	strLen = Len(str)
	for i = 1 to strLen
		char = ""
		strCut = Mid(str, i, 1)
		char = Asc(strCut)
		char = Left(char, 1)
		if char = "-" then
			strByte = strByte + 2
		else
			strByte = strByte + 1
		end if
		if cutLen < strByte then
			strRes = strRes & ".."
			exit for
		else
			strRes = strRes & strCut
		end if
	next
	cutStr = strRes
End Function
%>
<!-- #include file="../include/head1.asp" -->



<script language="javascript">
function imgBrdStyle(flg,imobj){
	if(flg){
		imobj.style.border="solid 2px #FF6600";
	}
	else{
		imobj.style.border="none";
	}
}

function viewSample(flg,intUnm){
	if(flg){
		alert("로그인 하신 후 이용하세요!");
	}else{
		var urlnm="../viwer/smple_ready.asp?vtype=dan&plidx=" + intUnm;
		var sFeatures = "width=980,height=560,top=0,left=0,scrollbars=no,resizable=no,titlebar=no";
		var k = window.open(urlnm, "viewpg", sFeatures);
		k.focus();
	}
}
//구매하기
function AryDanBuy(flg,n){
	if(flg){
		location.href="../member/login.asp?str__Page=" + encodeURIComponent("<%=nowPage%>?dntGbn=<%=dntGbn%>");
	}else{

		var chkAry = document.fm["II"];
		var chkAry1 = document.fm["JJ"];		
		var strbxt = "";
		var strbxt1 = "";
		var ckS=0;

		var ii_count = document.fm.ii_count.value;
		var jj_count = document.fm.jj_count.value;

		var tocheck = parseInt(ii_count) + parseInt(jj_count);

		//강좌가 0이면
		if (parseInt(ii_count) == 0){
			ckS=0;
		}
		else if(parseInt(ii_count) == 1)
		{
			if(document.fm.II.checked == false) ckS++;
		}
		else
		{
				for(var i=0; i < chkAry.length; i++){
					if(fm["II"][i].checked == true) {
						break;
					}
					else {
					ckS++;
					}
				}			
		}
		//교재가 0이면
		if (parseInt(jj_count) == 0){
			ckS = ckS +0;
		}
		else if(parseInt(jj_count) == 1)
		{
			if(document.fm.JJ.checked == false) ckS++;
		}
		else
		{
				for(var i=0; i < chkAry1.length; i++){
					if(fm["JJ"][i].checked == true) {
						break;
					}
					else {
					ckS++;
					}
				}			
		}

		if(ckS==tocheck){
			alert(' 결제하실 상품을 선택해주세요!!');
			return;
		}

		if(parseInt(ii_count) > 0){
			if(parseInt(ii_count) == 1){
				if(document.fm.II.checked == true) strbxt += document.fm.II.value + ",";
			}
			else
			{
				for(var i=0; i < chkAry.length; i++){
					if(fm["II"][i].checked == true) strbxt += chkAry[i].value + ",";
				}
			}
		}

		if(parseInt(jj_count) > 0){
			if(parseInt(jj_count) == 1){
				if(document.fm.JJ.checked == true) strbxt1 += document.fm.JJ.value + ",";
			}
			else
			{
				for(var i=0; i < chkAry1.length; i++){
					if(fm["JJ"][i].checked == true) strbxt1 += chkAry1[i].value + ",";
				}
			}
		}

		var strbxtLen = strbxt.split(",");
		if(strbxtLen.length - 1 > 10){
			alert("단과 수강신청은 최대 10개 과목까지만 신청하실 수 있습니다");
			return;
		}
		var params = "key="+encodeURIComponent(strbxt)+"&key1="+encodeURIComponent(strbxt1);
		sndReq("danbuyxml.asp",params,setBuy,"POST");
		//self.location.href='danbuyxml.asp?'+params;

	}
}

function setBuy(){
	if(objXmlhttp.readyState == 4){
		if(objXmlhttp.status==200){
			var xmlDoc = objXmlhttp.responseXML;
			var obj = xmlDoc.getElementsByTagName("isrows");
			var flg =eval(obj[0].getAttribute("flg"));
			var bygbn = obj[0].getAttribute("errgbn");
			if(flg){
				alert("에러 발생 : 로그인하지 않았거나, 네트웍에러");
			}else{

				if(parseInt(bygbn,10) > 0){
					alert("프리미엄  강좌를 수강하고 있으므로 단과 강좌를 구매하실 필요가 없습니다!");
					return;
				}

				location.href="../elpay/pay_dan.asp";
			}

		}else{
			alert("네트웍 오류 : 개발자에게 문의하세요!");
		}
	}
}
//바구니
function AryDanBaguy(flg,n){
	if(flg){
		location.href="../member/login.asp?str__Page=" + encodeURIComponent("<%=nowPage%>?dntGbn=<%=dntGbn%>");
	}else{
		var chkAry = document.fm["II"];
		var chkAry1 = document.fm["JJ"];		
		var strbxt = "";
		var strbxt1 = "";
		var ckS=0;

		var ii_count = document.fm.ii_count.value;
		var jj_count = document.fm.jj_count.value;

		var tocheck = parseInt(ii_count) + parseInt(jj_count);

		//강좌가 0이면
		if (parseInt(ii_count) == 0){
			ckS=0;
		}
		else if(parseInt(ii_count) == 1)
		{
			if(document.fm.II.checked == false) ckS++;
		}
		else
		{
				for(var i=0; i < chkAry.length; i++){
					if(fm["II"][i].checked == true) {
						break;
					}
					else {
					ckS++;
					}
				}			
		}
		//교재가 0이면
		if (parseInt(jj_count) == 0){
			ckS = ckS +0;
		}
		else if(parseInt(jj_count) == 1)
		{
			if(document.fm.JJ.checked == false) ckS++;
		}
		else
		{
				for(var i=0; i < chkAry1.length; i++){
					if(fm["JJ"][i].checked == true) {
						break;
					}
					else {
					ckS++;
					}
				}			
		}

		if(ckS==tocheck){
			alert(' 장바구니에 담으실 상품을 선택해주세요!!');
			return;
		}
			
		if(parseInt(ii_count) > 0){
			if(parseInt(ii_count) == 1){
				if(document.fm.II.checked == true) strbxt += document.fm.II.value + ",";
			}
			else
			{
				for(var i=0; i < chkAry.length; i++){
					if(fm["II"][i].checked == true) strbxt += chkAry[i].value + ",";
				}
			}
		}

		if(parseInt(jj_count) > 0){
			if(parseInt(jj_count) == 1){
				if(document.fm.JJ.checked == true) strbxt1 += document.fm.JJ.value + ",";
			}
			else
			{
				for(var i=0; i < chkAry1.length; i++){
					if(fm["JJ"][i].checked == true) strbxt1 += chkAry1[i].value + ",";
				}
			}
		}

		var params = "key="+encodeURIComponent(strbxt)+"&key1="+encodeURIComponent(strbxt1);
		//self.location.href='danbgunyxml.asp?'+params;
		sndReq("danbgunyxml.asp",params,setBasket,"POST");
	}
}

function setBasket(){
	if(objXmlhttp.readyState == 4){
		if(objXmlhttp.status==200){
			var xmlDoc = objXmlhttp.responseXML;
			var obj = xmlDoc.getElementsByTagName("isrows");
			var flg =eval(obj[0].getAttribute("flg"));
			var chkid = obj[0].getAttribute("chkid");

			if(flg){
			 	alert("장바구니에 저장하는데 에러 발생 : 로그인하지 않았거나, 네트웍에러");
			}else{
				var bool = confirm("장바구니에 저장되었습니다.\n지금 확인하시겠습니까?");
				if (bool){
					location.href = "/my/03_bguny.asp";
				}
				if (document.fm.jj_count > 0) checkReset();
				if (document.fm.jj_count > 0) checkReset1();
			
			}

		}else{
			alert("네트웍 오류 : 개발자에게 문의하세요!");
		}
	}
}

function checkReset(chk){
	var chkAry = document.all.II;

	if(chkAry.length){
		for(i=0;i<chkAry.length;i++){
			if(chkAry[i].checked) chkAry[i].checked = false;
		}
	}else{
		if(chkAry.checked) chkAry.checked = false;
	}
}
function checkReset1(chk){
	var chkAry = document.all.JJ;

	if(chkAry.length){
		for(i=0;i<chkAry.length;i++){
			if(chkAry[i].checked) chkAry[i].checked = false;
		}
	}else{
		if(chkAry.checked) chkAry.checked = false;
	}
}
</script>

<!-- #include file="../include/top.asp" -->

<div class="smain">  
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3><%=ca1_name%><%If Len(ca2_name) > 0 Then Response.write "<span style='font-size:17px'>&nbsp;>&nbsp;"& ca2_name &"</span>" End if%></h3>
        </div>
        <div class="scont">
			
			<%If Len(ca2_name) = 0 then%><%If Len(top_img1) > 0 then%><p style="width:830px;margin:0 0 20px 0;"><img src="/ahdma/quiz/<%=top_img1%>" style="width:100%"><p><%End if%><%else%><%If Len(top_img2) > 0 then%><p style="width:830px;margin:0 0 20px 0;"><img src="/ahdma/quiz/<%=top_img2%>" style="width:100%"><p><%End if%><%End if%>

<form name="fm" method="post">
            <table class="btbl" style="width:830px">
				<colgroup>
				<col style="width:18%" />
				<col style="width:38%" />
				<col style="width:10%" />
				<col style="width:10%" />
				<col style="width:16%" />
				<col style="width:8%" />
				</colgroup>
				<thead>
					<tr>
						<th colspan="2">강의안내</th>
						<th>강의샘플</th>
						<th>구분</th>
						<th>가격</th>
						<th>구매</th>
					</tr>
				</thead>
				<tbody>
<%
	Dim bcount,i,b_price,book_idx,rs

	b_price = 0

If Len(ca1) > 0 And Len(ca2) > 0 Then
	sql = "select " & strClmn & "from " & tabnm & " where state = 0 and ca1 = " & ca1 & " and ca2 = "& ca2 &" order by ordn asc"
elseIf Len(ca1) > 0 Then
	sql = "select " & strClmn & "from " & tabnm & " where state = 0 and ca1 = " & ca1 & " order by ordn asc"
Else
	sql = "select " & strClmn & "from " & tabnm & " where state = 0 order by ordn asc"
End if
	set dr = db.execute(sql)
	if not dr.bof or not dr.eof Then

	ii = 0
	bc = 0
	Do until dr.eof	
	
	b_price = 0
				
	book_idx = split(dr(9),",")
	bcount = ubound(book_idx)

	If bcount > 0 then

		For i = 1 To bcount
		
			sql = "select price1 from book_mast where state = 0 and idx = "& book_idx(i)
			Set rs=db.execute(sql)

			If rs.eof Or rs.bof Then
			Else
				b_price = b_price + rs(0)
			End If

		Next			

	End if
			
%>

<%If b_price > 0 then%><%bc = bc + 1%>
				  <tr>
					<%If dr(5) <> "noimage.gif" Then%><td rowspan="2"><img src="/ahdma/studimg/<%=dr(5)%>" class="imgbox_dan" onclick="self.location.href='dan_view.asp?dntGbn=<%=dntGbn%>&idx=<%=dr(0)%>';" style="cursor:pointer" /></td><%End if%>
					<td <%If dr(5) = "noimage.gif" Then Response.write "colspan='2'" End if%> rowspan="2" class="cont" onclick="self.location.href='dan_view.asp?dntGbn=<%=dntGbn%>&idx=<%=dr(0)%>';" style="cursor:pointer"><%
				icon = split(dr(8),",")
				icon_count = ubound(icon)
				for jj=0 to icon_count

					if len(trim(icon(jj))) > 5 then
					response.write "<img src='../ahdma/logo/"& trim(icon(jj)) &"'>&nbsp;"
					end If

				next%><h4><%=dr(1)%></h4>
				<p><%=dr(10)%></p></td>
					<td rowspan="2"><a href="javascript:viewSample(<%=strProg%>,'<%=dr(0)%>');" class="sbtn">샘플보기</a></td>
					<td>강좌</td>
					<td><%=formatnumber(dr(3),0)%>원</td>
					<td><%If Len(dr(11)) > 3 Then %>
					<%if instr(dr(11),", "& user_group &",") Then%>
					<input type="checkbox" name="II" id="II" value="<%=dr(0)%>" <%If dr(12) > 0 Or dr(13) > 0 Then Response.write"disabled" End if%>>
					<%else%>
					<input type="checkbox" name="II" id="II" value="<%=dr(0)%>" disabled>
					<%End If%>
					<%else%>
					<input type="checkbox" name="II" id="II" value="<%=dr(0)%>" <%If dr(12) > 0 Or dr(13) > 0 Then Response.write"disabled" End if%>>
					<%End if%></td>
				  </tr>
				  <tr>
					<td style="border-left:1px solid #ddd;">교재</td>
					<td><%=FormatNumber(b_price,0)%>원</td>
					<td><%If Len(dr(11)) > 3 Then %>
					<%if instr(dr(11),", "& user_group &",") Then%>
					<input type="checkbox" name="JJ" id="JJ" value="<%=dr(9)%>" <%If dr(12) > 0 Or dr(13) > 0 Then Response.write"disabled" End if%>>
					<%else%>
					<input type="checkbox" name="JJ" id="JJ" value="<%=dr(9)%>" disabled>
					<%End If%>
					<%else%>
					<input type="checkbox" name="JJ" id="JJ" value="<%=dr(9)%>" <%If dr(12) > 0 Or dr(13) > 0 Then Response.write"disabled" End if%>>
					<%End if%></td>
				  </tr>
<%else%>
					<tr>
						<%If dr(5) <> "noimage.gif" Then%><td><img src="/ahdma/studimg/<%=dr(5)%>" class="imgbox_dan" onclick="self.location.href='dan_view.asp?dntGbn=<%=dntGbn%>&idx=<%=dr(0)%>';" style="cursor:pointer" /></td><%End if%>
						<td <%If dr(5) = "noimage.gif" then Response.write "colspan='2'" End if%> class="cont" onclick="self.location.href='dan_view.asp?dntGbn=<%=dntGbn%>&idx=<%=dr(0)%>';" style="cursor:pointer"><%
				icon = split(dr(8),",")
				icon_count = ubound(icon)
				for jj=0 to icon_count

					if len(trim(icon(jj))) > 5 then
					response.write "<img src='../ahdma/logo/"& trim(icon(jj)) &"'>&nbsp;"
					end If

				next%><h4><%=dr(1)%></h4>
				<p><%=dr(10)%></p></td>
						<td><a href="javascript:viewSample(<%=strProg%>,'<%=dr(0)%>');" class="sbtn">샘플보기</a></td>
						<td>강좌</td>
						<td><%=formatnumber(dr(3),0)%>원</td>						
						<td><%If Len(dr(11)) > 3 Then %>
					<%if instr(dr(11),", "& user_group &",") Then%>
					<input type="checkbox" name="II" id="II" value="<%=dr(0)%>" <%If dr(12) > 0 Or dr(13) > 0 Then Response.write"disabled" End if%>>
					<%else%>
					<input type="checkbox" name="II" id="II" value="<%=dr(0)%>" disabled>
					<%End If%>
					<%else%>
					<input type="checkbox" name="II" id="II" value="<%=dr(0)%>" <%If dr(12) > 0 Or dr(13) > 0 Then Response.write"disabled" End if%>>
					<%End if%></td>
					</tr>
<%End if%>

<%

	ii = ii + 1
    dr.MoveNext
    Loop

Else
End If
%>
				</tbody>
			</table>
<input type="hidden" name="ii_count" value="<%=ii%>">
<input type="hidden" name="jj_count" value="<%=bc%>">
</form>

		<div class="rbtn"> <a href="javascript:AryDanBaguy(<%=strProg%>,<%=bc%>);" class="mbtn grey">장바구니</a> <a href="javascript:AryDanBuy(<%=strProg%>,<%=bc%>);" class="mbtn red">결제하기</a> </div>

        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" -->