<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx,intpg
Dim gbnS,strPart,strSearch
Dim varPage
Dim sql,dr,isRecod,isRows,isCols,rs
dim icon_count,jj

idx = Request("idx")
intpg = Request("intpg")
gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")

varPage = "gbnS=" & gbnS & "&strPart=" & strPart & "&strSearch=" & strSearch

sql = "select strnm,strteach,tinfo,intprice,intgigan,catenm=(select bname from dancate where idx=categbn),categbn,totalnum,sajin,inginum,icon,book_idx,sub_title,teach_id,mem_group,ordn,step_check,ca1,ca2,state from lecturTab where idx=" & idx
set dr = db.execute(sql)
Dim strnm,strteach,tinfo,intprice,intgigan,catenm,totalnum,categbn,strSajin,inginum,icon,book_idx,sub_title,teach_id,mem_group,ordn,step_check,ca1,ca2,state
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
dr.close %>
<!--#include file="../main/top.asp"-->

<script language="javascript">

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


			//location.href="/xml/sec_del_xml.asp?key=<%=idx%>&Sidx="+secidAry;

			$.ajax({
				url: "/xml/sec_del_xml.asp",
				type:"POST",
				data:{"key":<%=idx%>,"Sidx":""+secidAry+""},
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

			$.ajax({
				url: "/xml/sec_free_xml.asp",
				type:"POST",
				data:{"key":""+chekobj.value + "|" + freGbn + "|" + Lidx+""},
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

			//location.href="/xml/sec_order_xml.asp?key="+escape(sndvalue);
			$.ajax({
				url: "/xml/sec_order_xml.asp",
				type:"POST",
				data:{"key":""+sndvalue+""},
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
}
function go2SecNyong(idxnn){
	location.href="sec_mody.asp?idxnn=" + idxnn + "&idx=<%=idx%>&intpg=<%=intpg%>&<%=varPage%>";
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">

<%
 sql ="select idx,strnm,ordnum,strtime,lecsum,lecsrc,freegbn from sectionTab where l_idx=" & idx & " order by ordnum"
				set dr = db.execute(sql)
				dim maxCnt
				maxCnt = 0
				if not dr.bof or not dr.eof then
					isRecod = True
					isRows = split(dr.GetString(2),chr(13))
					maxCnt = UBound(isRows)
				end if
				dr.close 
%>

		<h2 class="cTit"><span class="bullet"></span>단과강좌관리</h2>
		<div class="tbl_top">
			<a href="sec_reg.asp?idx=<%=idx%>&intpg=<%=intpg%>&<%=varPage%>" class="fbtn1">강의 등록하기</a>	
		</div>



<div id="playArea">
<%if isRecod Then %>
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:5%" />
			<col style="width:8%" />
			<col style="width:8%" />
			<col />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th><img src="../rad_img/noncheck.gif" style="cursor:pointer;" onClick="AllCheck(this,document.all.secidx);"></th>	
					<th>정렬</th>
					<th>회차</th>
					<th>제목</th>
					<th>강의시간</th>
					<th>강의요점</th>
					<th>강의소스</th>
					<th>샘플</th>
				</tr>				
			</thead>
			<tbody>
<% 
for ii = 0 to UBound(isRows) - 1
isCols = split(isRows(ii),chr(9))
%>
						<tr>
							<td><input type="checkbox" name="secidx" value="<%=isCols(0)%>"></td>
							<td><img src="../rad_img/a_up.gif" style="cursor:pointer;" onClick="setOrder('up','<%=isCols(0)%>',<%=isCols(2)%>,'<%=maxCnt%>','<%=idx%>');">
							<img src="../rad_img/a_down.gif" style="cursor:pointer;" onClick="setOrder('dwn','<%=isCols(0)%>',<%=isCols(2)%>,'<%=maxCnt%>','<%=idx%>');"></td>
							<td><%=ii+1%>회</td>
							<td class="tl"><% if isCols(6) = "1" then %><font color="#0000CC">[샘플]</font>&nbsp;<% end if %><span style="cursor:pointer;color:#585858;" onMouseOver="this.style.color='#FF6600';" onMouseOut="this.style.color='#585858';" onClick="go2SecNyong('<%=isCols(0)%>');"><%=isCols(1)%></span></td>
							<td><%=isCols(3)%></td>
							<td><% if isCols(4) = "" then %>
							-<% else%>
							<a href="<%=isCols(4)%>"><img src="../rad_img/file.gif" border="0"></a><% end if %>							</td>
							<td><% if isCols(5) = "" then %>
							-<% else %>
							<a href="<%=isCols(5)%>"><img src="../rad_img/file.gif" border="0"></a><% end if %>							</td>
							<td><input type="checkbox"<% if isCols(6) = "1" then response.write " checked" %> value="<%=isCols(0)%>" onClick="setFreeMove(this,'<%=idx%>');"></td>
						</tr>
<% Next %>
			</tbody>
		</table>
<%End if%>
</div>

		<div class="tbl_btm mb80">
			<div class="rbtn">
				<a href="javascript:delteAll(document.all.secidx);" class="btn">선택삭제</a>
				<a href="dan_list.asp?intpg=<%=intpg%>&<%=varPage%>" class="btn trans">목록으로</a>			</div>
		</div>

	</div>
</div>


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->