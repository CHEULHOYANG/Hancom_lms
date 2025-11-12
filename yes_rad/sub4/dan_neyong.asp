<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx,intpg
Dim gbnS,strPart,strSearch
Dim varPage
Dim sql,dr,isRecod,isRows,isCols,rs
dim icon_count,jj
Dim strnm,strteach,tinfo,intprice,intgigan,catenm,totalnum,categbn,strSajin,inginum,icon,book_idx,sub_title,teach_id,mem_group,ordn,step_check,ca1,ca2,state

idx = Request("idx")
intpg = Request("intpg")
gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")

varPage = "gbnS=" & gbnS & "&strPart=" & strPart & "&strSearch=" & strSearch

sql = "select strnm,strteach,tinfo,intprice,intgigan,catenm=(select bname from dancate where idx=categbn),categbn,totalnum,sajin,inginum,icon,book_idx,sub_title,teach_id,mem_group,ordn,step_check,ca1,ca2,state from lecturTab where idx=" & idx
set dr = db.execute(sql)

If dr.eof Or dr.bof Then

	response.write"<script>"
	response.write"alert('데이터에러!!');"
	response.write"history.back();"
	response.write"</script>"
	response.end

Else

	strnm = dr(0)
	strteach = dr(1)
	tinfo = dr(2)
	intprice = dr(3)
	intgigan = dr(4)
	catenm = dr(5)
	categbn = dr(6)
	totalnum = dr(7)
	strSajin = dr(8)
	inginum = dr(9)
	icon = dr(10)
	book_idx = dr(11)
	sub_title = dr(12)
	teach_id = dr(13)
	mem_group = dr(14)
	ordn = dr(15)
	step_check = dr(16)
	ca1 = dr(17)
	ca2 = dr(18)
	state = dr(19)

dr.close 
End if
%>
<!--#include file="../main/top.asp"-->

<script type="text/javascript" src="/nicedit/nicEdit.js"></script>
<script type="text/javascript">
bkLib.onDomLoaded(function() {
	new nicEditor({fullPanel : true}).panelInstance('tinfo');
});
</script>

<script language="javascript">
function NumKeyOnly(){
	if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;
}
function cate_select(){

	var f = window.document.regfm;
	var a1 = f.ca1.value;

	if(a1 == "0"){
		alert("분류를 선택해주세요.");
		_data = "";
		$('#playArea').html(_data);	
		return;
	}

		$.ajax({
			url: "../../xml/dan_cate.asp",
			type:"POST",
			data:{"key":""+a1+""},
			dataType:"text",
			cache:false,
			processData:true,
			success:function(_data){								
				$('#playArea').html(_data);						
			},
			error:function(xhr,textStatus){
			alert("[에러]원인:"+xhr.status+"                                     ");
			}	
		});	
		
}
function go2Reg(theform){
	var clmn;
	clmn = theform.strnm;
	if(clmn.value==""){
		alert("강좌명을 입력하세요!");
		clmn.focus();
		return;
	}
	if(clmn.value.replace(/ /g,"")==""){
		alert("강좌명을 입력하세요!");
		clmn.select();
		return;
	}

	clmn = theform.ca1;
	if(clmn.value=="0"){
		alert("분류를 선택해주세요!");
		return;
	}

	clmn = theform.strteach;
	if(clmn.value==""){
		alert("강사명을 입력하세요!");
		clmn.focus();
		return;
	}
	if(clmn.value.replace(/ /g,"")==""){
		alert("강사명을 입력하세요!");
		clmn.select();
		return;
	}

	clmn = theform.intprice;
	if(clmn.value==""){
		alert("수강료를 입력하세요!");
		clmn.focus();
		return;
	}

	clmn = theform.intgigan;
	if(clmn.value==""){
		alert("수강기간을 입력하세요!");
		clmn.focus();
		return;
	}

	clmn = theform.sajin
	if(clmn.value){
		 if(!clmn.value.match(/\.(gif|jpg|png)$/i)) {
		 	alert("동영상 이미지는 그림파일(*.gif,*.jpg,*.png)만 등록할 수 있습니다!");
		 	clmn.select();
		 	return;
		 }
	}

	clmn = theform.tinfo;
	clmn.value = nicEditors.findEditor('tinfo').getContent();

	theform.submit();
}

function book_add(idx){

	if (document.regfm.book_idx.value.indexOf(","+idx+"") == -1) {
		document.regfm.book_idx.value = ""+document.regfm.book_idx.value+","+idx+"";
	}
	else
	{	
		var bool = confirm("이미등록한 상품입니다. 기존등록을 삭제하겠습니까?");
		if (bool){
			document.regfm.book_idx.value = document.regfm.book_idx.value.replace(","+idx+"","");
		}
	}
	
	document.regfm.bookselected[0].selected = true;
}

function FormatCutterny(number){
	var rValue = "";
	var EnableChar = "0123456789";
	var Chr='';
	var EnableNumber = '';

	for (i=0;i<number.length;i++) {
		Chr = number.charAt(i);
		if (EnableChar.indexOf(Chr) != -1){
			EnableNumber += Chr;
		}
	}

	var ABSNumber = '';
	ABSNumber = EnableNumber;

	if (ABSNumber.length < 4) {			//총길이가 3이하면 탈출
		rValue = ABSNumber;
		return rValue;
	}

	var ReverseWords = '';			//ReverseWords : 뒤집어진 '-'를 제외한 문자열

	for(i=ABSNumber.length;i>=0;i--){
			ReverseWords += ABSNumber.charAt(i);
	}

	rValue = ReverseWords.substring(0, 3);

	var dotCount = ReverseWords.length/3-1;
	for (j=1;j<=dotCount;j++){
		for(i=0;i<ReverseWords.length;i++){
			if (i==j*3)
				rValue+=","+ReverseWords.substring(i, i+3)
		}
	}

	var elseN = ReverseWords.length%3;
	if (elseN!=0){
		rValue+= ","+ReverseWords.substring(ReverseWords.length-elseN,ReverseWords.length)
	}

	ReverseWords = rValue;
	rValue = '';
	for(i=ReverseWords.length;i>=0;i--){
			rValue += ReverseWords.charAt(i);
	}

	return rValue;
}

function ModChange(obj1,obj2){
	obj1.style.display = obj1.style.display == "none"  ? "block" : "none";
	obj2.style.display = obj2.style.display == "none"  ? "block" : "none";
}

function AllCheck(thisimg,chekID){
	if(chekID){
		var srcAry = thisimg.src.split("/");
		if(srcAry[srcAry.length-1] == "noncheck.gif"){
			thisimg.src = "../rad_img/allcheck.gif";
			isChecked(true,chekID);
		}else{
			thisimg.src = "../rad_img/noncheck.gif";
			isChecked(false,chekID);
		}
	}
}

function isChecked(cmd,chekID){
	var chekLen=chekID.length;
	if(chekLen){
		for (i=0;i<chekLen;i++){
			chekID[i].checked=cmd;
		}
	}
	else{
		chekID.checked=cmd;
	}
}

function delteAll(chkobj){
	if(chkobj){
		var checkgbn = true;
		if(chkobj.length){
			for(i=0;i<chkobj.length;i++){
				if(chkobj[i].checked){
					checkgbn = false;
					break;
				}
			}
		}else{
			if(chkobj.checked){
				checkgbn = false;
			}
		}

		if(checkgbn){
			alert("삭제하실 강의를 선택해주세요!");
			return;
		}

		delok = confirm("체크한 강의를 삭제합니다");
		if(delok){
			var secidAry = "";
			if(chkobj.length){
				for(j=0;j<chkobj.length;j++){
					if(chkobj[j].checked){
						secidAry += chkobj[j].value + "|";
					}
				}
			}
			else{
				if(chkobj.checked){
					secidAry += chkobj.value + "|";
				}
			}

			delSection('<%=idx%>',secidAry);
		}
	}
}
function go2SecNyong(idxnn){
	location.href="sec_mody.asp?idxnn=" + idxnn + "&idx=<%=idx%>&intpg=<%=intpg%>&<%=varPage%>";
}

function delDan(){
	var delok = confirm("단과를 삭제하시겠습니까?\n\n이 단과에 해당된 모든 강의도 삭제 됩니다.                                                ");
	if(delok){
		location.href="dan_delete.asp?idx=<%=idx%>";
	}
}


function setFreeMove(chekobj,Lidx){	//샘플설정
	var freGbn = "0";
	var freMsg = "샘플보기를 해제합니다";
	var freCheck = true;
	
	if(chekobj.checked){
		freGbn = "1";
		freMsg = "샘플로  설정합니다."
		freCheck = false
	} 
	
	freok = confirm(freMsg);
	if(freok){
		var params = "key=" + escape(chekobj.value + "|" + freGbn + "|" + Lidx);
		sndReq("sub2xml/sec_free_xml.asp",params,vIewSection,"POST");
	}else{
		chekobj.checked = freCheck;
	}	
}

function setOrder(ordGbn,idxn,ordn,mxn,Lidx){	//회차 순서 변경
	var params;
	var sndvalue;
	var flg = false;
	
	if(ordGbn=="up"){
		if(parseInt(ordn,10) > 1){
			sndvalue = "1|" + idxn + "|" + ordn + "|" + Lidx;
			flg = true;
		}
	}
	else{
		if(parseInt(ordn,10) < parseInt(mxn,10)){
			sndvalue = "2|" + idxn + "|" + ordn + "|" + Lidx;
			flg = true;
		}
	}
	
	if(flg){
			params = "key=" + escape(sndvalue);
			sndReq("sub2xml/sec_order_xml.asp",params,vIewSection,"POST");
	}	
}

function delSection(Lidx,idxAry){		//삭제
	params = "key=" + escape(Lidx) + "&Sidx=" + escape(idxAry);
	sndReq("sub2xml/sec_del_xml.asp",params,vIewSection,"POST");
	//location.href="sec_del_xml.asp?" + params;
}

function vIewSection(){
	if(objXmlhttp.readyState == 4){
		if(objXmlhttp.status==200){
			var xmlDoc = objXmlhttp.responseXML;
			var objRows = xmlDoc.getElementsByTagName("isrows").item(0);
			var objCols = objRows.getElementsByTagName("iscols");
			var strinHm = objCols.item(0).firstChild.nodeValue;
			alert(strinHm);
			document.getElementById("subPan").innerHTML = strinHm;
		}else{
			alert("네트웍 오류 : 개발자에게 문의하세요!");
		}
	}	
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>단과강좌관리</h2>

<form name="regfm" action="dan_modfy.asp" enctype="multipart/form-data" method="post">
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="intpg" value="<%=intpg%>">
<input type="hidden" name="gbnS" value="<%=gbnS%>">
<input type="hidden" name="strPart" value="<%=strPart%>">
<input type="hidden" name="strSearch" value="<%=strSearch%>">
<input type="hidden" name="strSajin" value="<%=strSajin%>">

<input type="hidden" name="sca1" value="<%=request("ca1")%>">
<input type="hidden" name="sca2" value="<%=request("ca2")%>">

		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>숨김</th>
						<td><input type="radio"  name="state" value="0" <%If state=0 Then Response.write"checked" End if%> > 아니오
						  <input type="radio"  name="state" value="1" <%If state=1 Then Response.write"checked" End if%> > 예
                          <span class="stip">* 강좌목록에서 숨길수 있습니다.</span></td>
					</tr>
					<tr>
						<th>순차재생</th>
						<td><input type="radio"  name="step_check" value="0" <%If step_check=0 Then Response.write"checked" End if%> > 아니오
						  <input type="radio"  name="step_check" value="1" <%If step_check=1 Then Response.write"checked" End if%> > 예
                          <span class="stip">* 강좌순차적으로 수강완료를 해야 다음 강좌가 열리게 됩니다.</span></td>
					</tr>
					<tr>
						<th>순번</th>
						<td><input type="text"  name="ordn" class="inptxt1 w60" value="<%=ordn%>" ></td>
					</tr>
					<tr>
						<th>수강신청가능 회원그룹</th>
						<td><%
sql = "select idx,title from group_mast where gu = 0 "
set rs=db.execute(sql)

if rs.eof or rs.bof then
else
do until rs.eof
%>
<input type="checkbox" name="mem_group" id="mem_group" value="<%=rs(0)%>" <%if instr(mem_group,", "& rs(0) &",") then response.write"checked" end if%> /> <%=rs(1)%>&nbsp;<%
rs.movenext
loop
rs.close
end if
%>
<br /><span class="stip">* 체크시 해당 그룹에 회원들만 수강신청이 가능합니다. 그룹관리는 회원관리에서 가능합니다.</span></td>
					</tr>
					<tr>
						<th>강좌명</th>
						<td><input type="text"  name="strnm" class="inptxt1 w400"  value="<%=strnm%>"></td>
					</tr>
					<tr>
						<th>간략설명</th>
						<td><input type="text"  name="sub_title" class="inptxt1 w400"  value="<%=sub_title%>"></td>
					</tr>
					<tr>
						<th>카테고리</th>
						<td><select name="ca1" class="seltxt w200" onChange="cate_select();">
  <option value="0">선택</option>
<%
sql="select idx,title from dan_category where deep=0 order by ordnum asc,idx desc"
set rs=db.execute(sql)
if rs.eof or rs.bof then
else
do until rs.eof
%>
      <option value="<%=rs(0)%>" <%If ca1 = rs(0) Then response.write"selected" End if%>><%=rs(1)%></option>
<%
rs.movenext
Loop
rs.close
end if
%>
    </select>&nbsp;<span id="playArea"><%If ca1 > 0 then%><select name="ca2" class="seltxt w200">
  <option value="0" <%If ca2 = 0 Then response.write"selected" End if%>>분류를선택하세요.</option>
<%
sql="select idx,title from dan_category where deep=1 and uidx="& ca1 &" order by ordnum asc,idx desc"
set rs=db.execute(sql)
if rs.eof or rs.bof then
else
do until rs.eof
%>
      <option value="<%=rs(0)%>" <%If ca2 = rs(0) Then response.write"selected" End if%>><%=rs(1)%></option>
<%
rs.movenext
Loop
rs.close
end if
%>
    </select><%End if%></span></td>
					</tr>
					<tr>
						<th>강사정보</th>
						<td><input type="text"  name="strteach" class="inptxt1 w100" placeholder="강사명" value="<%=strteach%>"> / <input  name="teach_id" type="text" class="inptxt1 w100" id="teach_id" placeholder="강사아이디" value="<%=teach_id%>" ></td>
					</tr>
					<tr>
						<th>수강정보</th>
						<td><input type="text"  name="intprice" class="inptxt1 w100" placeholder="수강료" onKeyPress="NumKeyOnly();" onKeyUp="this.value = FormatCutterny(this.value);" value="<%=formatnumber(intprice,0)%>"> 원 / <input type="text"  name="intgigan" class="inptxt1 w100" maxlength="3" onKeyPress="NumKeyOnly();" placeholder="수강기간" value="<%=intgigan%>"> 일</td>
					</tr>
					<tr>
						<th>강의아이콘</th>
						<td><%
				  sql = "select name,icon from icon_mast order by idx desc"
				  set rs=db.execute(sql)
				  
				  if rs.eof or rs.bof then
				  else
				  do until rs.eof%><input name="icon" type="checkbox" id="icon" value="<%=rs(1)%>" <%if instr(icon,", "& rs(1) &",") then response.write"checked" end if%>> <img src="/ahdma/logo/<%=rs(1)%>" align="absmiddle">&nbsp;
                    <%
rs.movenext
loop
rs.close
end if
%></td>
					</tr>
					<tr>
						<th>연동상품선택</th>
						<td><input  name="book_idx" type="text" id="book_idx" readonly class="inptxt1 w400" value="<%=book_idx%>"><p style="height:10px"></p>
						<select name="bookselected" id="bookselected" onChange="book_add(this.value);" class="seltxt w400">
                              <option value="">선택해주세요</option>
                              <% 
							  sql = "select idx,title,price1 from book_mast order by idx desc"
							  set rs=db.execute(sql)
							  
							  if rs.eof or rs.bof then
							  else
							  do until rs.eof %>
                              <option value="<%=rs(0)%>"><%=rs(0)%>. <%=rs(1)%> (<%=FormatNumber(rs(2),0)%>원)</option>
                              <% rs.movenext
							  loop
							  rs.close
								end if %>
                          </select> <span class="stip">* 같은 상품을 2번 선택하시면 삭제가 됩니다.</span></td>
					</tr>
					<tr>
						<th>이미지</th>
						<td><input type="file" name="sajin" class="inptxt1 w200"  >   <span class="stip">* 사이즈는 4:3형태로 png,jpg,gif만 가능</span> <%If Len(strSajin) > 0 And strSajin <> "noimg.gif" Then%><p style="height:10px"></p><img src="/ahdma/studimg/<%=strSajin%>" width="150px">&nbsp;<input type='checkbox' name='check_del' id='checkbox' value='1'/> 삭제<%End if%></td>
					</tr>
					<tr>
						<th>메인표출</th>
						<td><input type="checkbox" name="inginum" value="1" <% if inginum = 1 then response.write " checked" %>> 해당 강의를 메인에 표출합니다</td>
					</tr>
					<tr>
						<th>강의내용</th>
						<td><a href="javascript:popenWindow('/nicedit/upimg.asp?box=tinfo','390','290');"><img src="/nicedit/bt1.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/vod.asp?box=tinfo','390','290');"><img src="/nicedit/bt2.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/files.asp?box=tinfo','390','290');"><img src="/nicedit/bt3.gif" border="0"></a><textarea name="tinfo" id="tinfo" rows="2" cols="20" style="width:800px; height:200px;"><%=tinfo%></textarea></td>
					</tr>
				</tbody>
			</table>
</form>

		<div class="rbtn">
			<a href="javascript:go2Reg(regfm);" class="btn">수정</a>
			<a href="javascript:delDan();" class="btn">삭제</a>
			<a href="dan_list.asp?intpg=<%=intpg%>&gbnS=<%=gbnS%>&strPart=<%=strPart%>&strSearch=<%=strSearch%>&ca1=<%=request("ca1")%>&ca2=<%=request("ca2")%>" class="btn trans">목록보기</a>		
		</div>


	</div>
</div>



</body>
</html>
<!-- #include file = "../authpg_2.asp" -->