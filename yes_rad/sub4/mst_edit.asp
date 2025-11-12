<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,isRecod,isRows,isCols
Dim idx,intpg,varPage,rs
Dim gbnS,strPart,strSearch
dim strnm,intprice,intgigan,strheader,sajin,recom,gbn,ordn,icon,sub_title,mem_group,teacher,state,book_idx

idx = Request("idx")
intpg = Request("intpg")
gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")
varPage = "intpg=" & intpg & "&gbnS=" & gbnS & "&strSearch=" & strSearch & "&strPart=" & strPart

sql = "select strnm,intprice,intgigan,strheader,sajin,recom,gbn,ordn,icon,sub_title,mem_group,teacher,state,book_idx from LectMast where idx=" & idx
set dr = db.execute(sql)

If dr.eof Or dr.bof Then

	response.write"<script>"
	response.write"alert('데이터에러!!');"
	response.write"history.back();"
	response.write"</script>"
	response.end

Else

	strnm = dr(0)
	intprice = formatnumber(dr(1),0)
	intgigan = dr(2)
	strheader = dr(3)
	sajin = dr(4)
	recom = int(dr(5))
	gbn = dr(6)
	ordn = dr(7)
	icon = dr(8)
	sub_title = dr(9)
	mem_group = dr(10)
	teacher = dr(11)
	state = dr(12)
	book_idx = dr(13)

dr.close
End if

''TempAry Table 초기화
db.execute("delete TempAry") %>
<!--#include file="../main/top.asp"-->

<script type="text/javascript" src="/nicedit/nicEdit.js"></script>
<script type="text/javascript">
bkLib.onDomLoaded(function() {
	new nicEditor({fullPanel : true}).panelInstance('strheader');
});
</script>

<script language="javascript">
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
function NumKeyOnly(){
	if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;
}

function go2Reg(theform){
	var clmn;
	clmn = theform.strnm;
	if(clmn.value==""){
		alert("과정명을 입력하세요!");
		clmn.focus();
		return;
	}
	if(clmn.value.replace(/ /g,"")==""){
		alert("과정명을 입력하세요!");
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
		 if(!clmn.value.match(/\.(gif|jpg|bmp)$/i)) {
		 	alert("타이틀 이미지는 그림파일(*.gif,*.jpg,*.bmp)만 등록할 수 있습니다!");
		 	clmn.select();
		 	return;
		 }

	}

	clmn = theform.gbn;
	if(clmn.value==""){
		alert("카테고리를 선택하세요!");
		clmn.focus();
		return;
	}

	clmn = theform.strheader;
	clmn.value = nicEditors.findEditor('strheader').getContent();

	clmn = theform.projectLectures;

	for(i=0; i<clmn.options.length; i++){
		clmn.options[i].selected=true;
	}
theform.submit();
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

function addItem(theform){
	var leftobj = theform.lectureList;
	var rightobj = theform.projectLectures;
	var flg = leftobj.length;
	if(flg < 1){
		alert("등록된 단과강좌가 없기때문에 커리큘럼을 추가할 수 없습니다.");
	}
	else{
		var selectstr = "";
		for(ii=0;ii<leftobj.length;ii++){
			if(leftobj.options[ii].selected){
				selectstr += leftobj.options[ii].value + ",";
			}
		}

		if(selectstr==""){
			alert("커리큘럼에 추가할 강좌를 왼쪽 단과목록에서 선택하세요!");
			return;
		}
		var params = "key=" + escape(selectstr);
		sndReq("selectin_xml.asp",params,leftView,"POST");
	}
}

function removeItem(theform){
	with(theform){

		var rightobj = projectLectures;
		var selectstr = "";

		for(ii=0;ii<rightobj.length;ii++){
			if(rightobj.options[ii].selected){
				selectstr += rightobj.options[ii].value + ",";
			}
		}

		if(selectstr==""){
			alert("삭제할 강좌를 선택하세요!");
			return;
		}
		var params = "key=" + escape(selectstr);
		sndReq("selectout_xml.asp",params,leftView,"POST");
	}
}

function upItem(theform){
	with(theform){
		num=projectLectures.selectedIndex;
		if(num==-1){
			alert('이동할 강좌를 선택하세요!');
			return;
		}

		if(num==0){
			return;
		}

		temp1=projectLectures.options[num].value;
		temp2=projectLectures.options[num].text;
		projectLectures.options[num].value=theform.projectLectures.options[num-1].value;
		projectLectures.options[num].text=theform.projectLectures.options[num-1].text;
		projectLectures.options[num-1].value=temp1;
		projectLectures.options[num-1].text=temp2;
		projectLectures.selectedIndex=num-1;
	}
}

function downItem(theform){
	with(theform){
		num=projectLectures.selectedIndex;
		if(num==-1){
			alert('이동할 강좌를 선택하세요!');
			return;
		}
		if(num==projectLectures.options.length-1){
			return;
		}

		temp1=projectLectures.options[num+1].value;
		temp2=projectLectures.options[num+1].text;
		projectLectures.options[num+1].value=theform.projectLectures.options[num].value;
		projectLectures.options[num+1].text=theform.projectLectures.options[num].text;
		projectLectures.options[num].value=temp1;
		projectLectures.options[num].text=temp2;
		projectLectures.selectedIndex=num+1;
	}
}

function spredSelect(cateidx){
	var params = "key=" + escape(cateidx);
	sndReq("dan_list_xml.asp",params,selectView,"POST");
}

function selectView(){
	if(objXmlhttp.readyState == 4){
		if(objXmlhttp.status==200){
			var xmlDoc = objXmlhttp.responseXML;
			var objRows = xmlDoc.getElementsByTagName("isrows").item(0);
			var objCols = objRows.getElementsByTagName("iscols");
			var strinHm = objCols.item(0).firstChild.nodeValue;
			document.getElementById("dnSelect").innerHTML = strinHm;
		}else{
			alert("error");
		}
	}
}

function leftView(){
	if(objXmlhttp.readyState == 4){
		if(objXmlhttp.status==200){
			var xmlDoc = objXmlhttp.responseXML;
			var objRows = xmlDoc.getElementsByTagName("isrows").item(0);
			var objCols = objRows.getElementsByTagName("iscols");
			var strinHm = objCols.item(0).firstChild.nodeValue;
			document.getElementById("dnSeleced").innerHTML = strinHm;
		}else{
			alert("error");
		}
	}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>패키지강좌관리</h2>

<form name="regfm" action="mst_edit_ok.asp" method="post" enctype="multipart/form-data" style="display:inline;">
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="gbnS" value="<%=gbnS%>">
<input type="hidden" name="strPart" value="<%=strPart%>">
<input type="hidden" name="dbsajin" value="<%=sajin%>">
<input type="hidden" name="strSearch" value="<%=strSearch%>">
<input type="hidden" name="intpg" value="<%=intpg%>">    
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
                          <span class="stip">* 강좌목록에서 숨길수 있습니다</span></td>
					</tr>
					<tr>
						<th>정렬번호</th>
						<td><input  name="ordn" type="text" class="inptxt1 w60" id="ordn" onKeyPress="NumKeyOnly();" value="<%=ordn%>" maxlength="3"></td>
					</tr>
					<tr>
						<th>수강신청가능</th>
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
							<span class="stip">* 체크시 해당 그룹에 회원들만 수강신청이 가능합니다.</span></td>
					</tr>
					<tr>
						<th>카테고리</th>
						<td><select name="gbn" class="seltxt w200">
								<% sql = "select idx,bname from mscate order by idx"
								set dr = db.execute(sql)
								if Not dr.bof or Not dr.Eof then
								do until dr.eof %>
								<option value="<%=dr(0)%>" <% if int(gbn) = int(dr(0))  then response.write " selected" %>><%=dr(1)%></option><% dr.MoveNext
								Loop
								end if
								dr.close %>
							</select></td>
					</tr>
					<tr>
						<th>과정명</th>
						<td><input type="text"  name="strnm" class="inptxt1 w400" value="<%=strnm%>" ></td>
					</tr>					
					<tr>
						<th>간략설명</th>
						<td><input type="text"  name="sub_title" class="inptxt1 w400" value="<%=sub_title%>"></td>
					</tr>
					<tr>
						<th>수강정보</th>
						<td><input type="text"  name="intprice" class="inptxt1 w100" placeholder="수강료" onKeyPress="NumKeyOnly();" onKeyUp="this.value = FormatCutterny(this.value);" value="<%=intprice%>"> 원 / <input type="text"  name="intgigan" class="inptxt1 w100" maxlength="3" onKeyPress="NumKeyOnly();" placeholder="수강기간" value="<%=intgigan%>"> 일</td>
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
						<td><input type="file"  name="sajin" class="inptxt1 w200" > <span class="stip">* 사이즈는 4:3형태로 png,jpg,gif만 가능</span></td>
					</tr>

					<tr>
						<th>메인표출</th>
						<td> <input type="checkbox"  name="recom" value="1" <% if recom = 1 then response.write " checked" %>>  메인페이지에 표출 (<input type="text"  name="teacher" class="inptxt1 w200" placeholder="메인표시내용" value="<%=teacher%>">)</td>
					</tr>
					<tr>
						<th>강의아이콘</th>
						<td><%
				  sql = "select name,icon from icon_mast order by idx desc"
				  set rs=db.execute(sql)
				  
				  if rs.eof or rs.bof then
				  else
				  do until rs.eof%><input name="icon" type="checkbox" id="icon" value="<%=rs(1)%>" <%if instr(icon,", "& rs(1) &",") then response.write"checked" end if%>> <img src="../../ahdma/logo/<%=rs(1)%>" align="absmiddle">&nbsp;
                    <%
rs.movenext
loop
rs.close
end if
%></td>
					</tr>
					<tr>
						<th>설명</th>
						<td><a href="javascript:popenWindow('/nicedit/upimg.asp?box=strheader','390','290');"><img src="/nicedit/bt1.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/vod.asp?box=strheader','390','290');"><img src="/nicedit/bt2.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/files.asp?box=strheader','390','290');"><img src="/nicedit/bt3.gif" border="0"></a>
                          <textarea name="strheader" id="strheader" rows="2" cols="20" style="width:600px; height:200px;"><%=strheader%></textarea></td>
					</tr>
				</tbody>
			</table>


<table width="100%" cellpadding="0" cellspacing="0">
						<tr height="25">
							<td width="44%"><select onChange="spredSelect(this.value);" class="seltxt w300">
							<option value="0">단과과목선택</option><% sql = "select idx,title from dan_category where deep=0 order by ordnum asc,idx desc"
							set dr = db.execute(sql)
							if not dr.bof or not dr.eof then
							do until dr.eof %>
							<option value="<%=dr(0)%>"><%=dr(1)%></option><% dr.moveNext
							Loop
							end if %>
							</select></td>
							<td width="11%"></td>
							<td width="45%">패키지 포함중인 단과</td>
						</tr><% sql = "select idx,strnm from LecturTab order by strnm"
							set dr = db.execute(sql)
							if not dr.Bof or Not dr.Eof then
								isRecod = True
								isRows = split(dr.GetString(2),chr(13))
							end if %>
						<tr>
							<td valign="top" ID="dnSelect">
							<select name="lectureList" id="lectureList" multiple size="15" style="width:100%;height:400px" class="seltxt" ondblclick="addItem(this.form);"><% if isRecod then
							for ii = 0 to UBound(isRows) - 1
							isCols = split(isRows(ii),chr(9)) %>
								<option value="<%=isCols(0)%>"><%=isCols(1)%></option><% Next
								end if %>
							</select>							</td>
							<td>
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr height="25">
									<td height="35" align="center" ><input type="button" value="패키지에 추가" class="btns" style="width:80px;" onClick="addItem(this.form);"></td>
								</tr>
								<tr height="25">
									<td height="35" align="center" ><input type="button" value="추가 삭제" class="btns" style="width:80px;" onClick="removeItem(this.form);"></td>
								</tr>
								<tr height="25">
									<td height="35" align="center" ><input type="button" value="정렬올리기 ▲" class="btns" style="width:80px;" onClick="upItem(this.form);"></td>
								</tr>
								<tr height="25">
									<td height="35" align="center" ><input type="button" value="정렬내리기 ▼" class="btns" style="width:80px;" onClick="downItem(this.form);"></td>
								</tr>
							</table>							</td>
							<td valign="top" ID="dnSeleced">
								<select name="projectLectures" id="projectLectures" multiple size="15" style="width:100%;height:400px" class="seltxt" ondblclick="removeItem(this.form);"><% sql = "select lectidx from LectAry where mastidx=" & idx & " order by ordn"
								set dr = db.execute(sql)
								dim inNum : inNum = 1
								if not dr.Bof or not dr.Eof then
									do until dr.eof
										db.execute("insert into TempAry (idx,num) values (" & dr(0) & "," & inNum & ")")
									inNum = inNum + 1
									dr.MoveNext
									Loop
								end if
								dr.close

								sql = "select A.idx,B.strnm from TempAry A join LecturTab B on A.idx = B.idx"
								set dr = db.execute(sql)
								if Not dr.Bof or Not dr.Eof then
									isRows = split(dr.GetString(2),chr(13))
									for ii = 0 to UBound(isRows) - 1
									isCols = split(isRows(ii),chr(9)) %>
									<option value="<%=isCols(0)%>"><%=isCols(1)%></option><% Next
								end if
								dr.close %>
								</select>							</td>
						</tr>
					</table>

</form>

<p style="height:10px"></p>
<div class="caution"><p>좌측에 단과를 클릭후 <u>[패키지에 추가]</u> 를 눌러주시면 해당 패키지에 포함이 됩니다.</p></div>
<div class="caution"><p>우측에 등록된 단과를 클릭후 <u>[추가 삭제]</u> 를 눌러주시면 등록된 단과에서 삭제가 됩니다.</p></div>
<div class="caution"><p>우측에 등록된 단과 순서는 <u>[정렬올리기 / 정렬내리기]</u> 로 변경이 가능합니다.</p></div>

<p style="height:10px"></p>
		<div class="rbtn">
			<a href="javascript:go2Reg(regfm);" class="btn">저장하기</a>
			<a href="mst_list.asp?<%=varPage%>" class="btn trans">목록보기</a>		
		</div>

	</div>
</div>







					


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->