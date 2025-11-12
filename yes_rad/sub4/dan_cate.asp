<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,isRecod,isRows,isCols
sql = "select idx,bname,cnt = (select count(idx) from LecturTab where categbn = A.idx),ordnum from dancate A order by A.ordnum"
set dr = db.execute(sql)
if not dr.bof or not dr.eof then
	isRecod = True
	isRows = split(dr.getString(2),chr(13))
end if
dr.Close
%>
<!--#include file="../main/top.asp"-->

<script>
var topTxt = "<table width='100%' cellpadding='0' cellspacing='0'><tr height='20'><td colspan='4'></td></tr><tr height='1'><td colspan='4' bgcolor='#ececec'></td></tr>";
var btmTxt = "<tr height='20'><td colspan='4'></td></tr></table>";

function CateInsert(isKey,strobj){
if(isKey || event) event.returnValue = false;

	if(strobj.value == ""){
		alert("카테고리명을 입력하세요!");
		strobj.focus();
		return;
	}
	if(strobj.value.replace(/ /g,"") == ""){
		alert("카테고리명을 입력하세요!");
		strobj.select();
		return;
	}

	var params = "key=" + escape(strobj.value);
	sndReq("sub2xml/dancate_xml.asp",params,viewCate,"POST");
}

function viewCate(){
	if(objXmlhttp.readyState == 4){
		if(objXmlhttp.status==200){
			var xmlDoc = objXmlhttp.responseXML;
			var objRows = xmlDoc.getElementsByTagName("isrows").item(0);
			var objCols = objRows.getElementsByTagName("iscols");
			var plg = objCols.item(0).firstChild.nodeValue;
			var strinHm = "";
			
			if(eval(plg)){
				strinHm += topTxt;
				strinHm += objCols.item(1).firstChild.nodeValue;
				strinHm += btmTxt;
			}
			document.getElementById("categoryT").innerHTML = strinHm;
			document.all.strcate.value = "";
		}else{
			alert("error");
		}
	}
}

function EditMode(){
	var args = EditMode.arguments;
	var objmod = document.getElementById("tdmod" + args[0]);
	
	var txtHtm = "<input type=\"text\" value=\"" + args[2] + "\" name=\"strcate" + args[0] + "\" class=\"simpleform\" style=\"width:150;\" onkeypress=\"if(event.keyCode==13) editCate(true,this,'" + args[1] + "');\"> ";
	txtHtm += "	<img src=\"../yes_rad_img/a_img/bt/bt_23.gif\" onclick=\"editCate(false,document.all.strcate" + args[0] + ",'" + args[1] + "');\" style=\"cursor:pointer;\">&nbsp;<img src=\"../yes_rad_img/35.gif\" onclick=\"InputCnl('" + args[0] + "','" + args[1] + "','" + args[2] + "');\" style=\"cursor:pointer;\">";
	
	objmod.innerHTML = txtHtm;
}

function InputCnl(){
	var args = InputCnl.arguments;
	var objmod = document.getElementById("tdmod" + args[0]);
	var txtHtm = "<img src=\"../yes_rad_img/a_img/bt/bt_23.gif\" onclick=\"EditMode('" + args[0] + "','" + args[1] + "','" + args[2] + "');\" style=\"cursor:pointer;\">&nbsp;<img src=\"../yes_rad_img/a_img/bt/bt_24.gif\" onclick=\"CateDelete('" + args[1] + "');\" style=\"cursor:pointer;\">";
	objmod.innerHTML = txtHtm;
}

function editCate(isKey,strobj,idxn){
if(isKey || event) event.returnValue = false;
	if(strobj.value == ""){
		alert("카테고리명을 입력하세요!");
		strobj.focus();
		return;
	}
	if(strobj.value.replace(/ /g,"") == ""){
		alert("카테고리명을 입력하세요!");
		strobj.select();
		return;
	}

	var params = "key=" + escape(strobj.value) + "&keyidx=" + escape(idxn);
	sndReq("sub2xml/dan_edite_xml.asp",params,viewCate,"POST");	
}

function CateDelete(cateidx,rcdNum){
	if(parseInt(rcdNum,10) > 0 ){
		alert("해당 카테고리내에 등록된 강좌가 있어 삭제할 수가 없습니다.\n\n먼저 등록된 강좌를 비워야 합니다.");
	}else{
		var params = "key=" + escape(cateidx);
		sndReq("sub2xml/dancatedel_xml.asp",params,delView,"POST");	
	}
}

function delView(){
	if(objXmlhttp.readyState == 4){
		if(objXmlhttp.status==200){
			var xmlDoc = objXmlhttp.responseXML;
			var objRows = xmlDoc.getElementsByTagName("isrows").item(0);
			var objCols = objRows.getElementsByTagName("iscols");
			var plg = objCols.item(0).firstChild.nodeValue;
			var strinHm = "";
			
			if(eval(plg)){
				strinHm += topTxt;
				strinHm += objCols.item(1).firstChild.nodeValue;
				strinHm += btmTxt;
				document.getElementById("categoryT").innerHTML = strinHm;
			}
			
		}else{
			alert("error");
		}
	}
	
}

function ordSun(){
	var args = ordSun.arguments;
	params = "keygbn=" + escape(args[0]) + "&keyidx=" + escape(args[1]) + "&orgn=" + escape(args[2]);
	sndReq("sub2xml/danord_xml.asp",params,orderView,"POST");
}

function orderView(){
	if(objXmlhttp.readyState == 4){
		if(objXmlhttp.status==200){
			var xmlDoc = objXmlhttp.responseXML;
			var objRows = xmlDoc.getElementsByTagName("isrows").item(0);
			var objCols = objRows.getElementsByTagName("iscols");
			var plg = objCols.item(0).firstChild.nodeValue;
			var strinHm = "";
			
			if(eval(plg)){
				strinHm += topTxt;
				strinHm += objCols.item(1).firstChild.nodeValue;
				strinHm += btmTxt;
				document.getElementById("categoryT").innerHTML = strinHm;
			}
		}else{
			alert("error");
		}
	}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>사이트정보관리</h2>
	</div>
</div>


<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="35" background="../yes_rad_img/include/img/t3_bg.gif"><table width="900" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="20">&nbsp;</td>
            <td width="880"><table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="15"><img src="../yes_rad_img/a_img/page/i_home.gif" width="11" height="10" /></td>
                <td class="grey2">HOME</td>
                <td width="15" align="center"><img src="../yes_rad_img/a_img/page/i_cate.gif" width="5" height="9" /></td>
                <td class="grey2_1">서비스관리</td>
                <td width="15" align="center"><img src="../yes_rad_img/a_img/page/i_cate.gif" width="5" height="9" /></td>
                <td class="grey2_1">카테고리</td>                
                <td width="15" align="center"><img src="../yes_rad_img/a_img/page/i_cate.gif" width="5" height="9" /></td>
                <td class="grey2_1"><strong>단과분류관리</strong></td>
               
              </tr>
            </table></td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td><table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td height="10" align="center" valign="top"></td>
        <td height="10" align="center" valign="top"></td>
      </tr>
      <tr>
        <td width="200px" valign="top"><!--#include file="left.asp"--></td>
        <td width="88%" valign="top"><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td height="35"><table cellspacing="0" cellpadding="0" border="0">
									<tr height="10">
										<td colspan="4"></td>
									</tr>

									<tr>
										<td><span class="style1">카테고리생성</span> &nbsp; </td>
										<td width="160"><input type="text" name="strcate" class="simpleform" style="width:150px;" onKeyPress="if(event.keyCode==13) CateInsert(true,this);"></td>
									  <td width="80"><img src="../yes_rad_img/a_img/bt/bt_01.gif" width="70" height="24" onClick="CateInsert(false,document.all.strcate);" style="cursor:pointer;"></td>
									</tr>                                   
									<tr height="10">
										<td colspan="4"></td>
									</tr>
				</table></td>
          </tr>
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="100%" align="center" ID="categoryT"><% if isRecod then %>
									<table width="100%" cellpadding="0" cellspacing="0" border="0">
										<tr height="20">
											<td colspan="4"></td>
										</tr>
										<tr height="1">
											<td colspan="4" bgcolor="#ececec"></td>
										</tr><% for ii = 0 to UBound(isRows) - 1
										isCols = split(isRows(ii),chr(9)) %>
										<tr height="30">
											<td width="50" align="center">
											<img src="../ad_img/ico_rank_up.gif" style="cursor:pointer;" onClick="ordSun('up','<%=isCols(0)%>','<%=isCols(3)%>');">
											<img src="../ad_img/ico_rank_down.gif" style="cursor:pointer;" onClick="ordSun('dw','<%=isCols(0)%>','<%=isCols(3)%>');">											</td>
											<td width="20" align="center"></td>
											<td width="200" ><%=isCols(1)%></td>
											<td align="right" ID="tdmod<%=ii%>">
											<img src="../yes_rad_img/a_img/bt/bt_23.gif" onClick="EditMode('<%=ii%>','<%=isCols(0)%>','<%=isCols(1)%>');" style="cursor:pointer;">&nbsp;<img src="../yes_rad_img/a_img/bt/bt_24.gif" onClick="CateDelete('<%=isCols(0)%>','<%=isCols(2)%>');" style="cursor:pointer;"></td>
									  </tr>
										<tr height="1">
											<td colspan="4" bgcolor="#ececec"></td>
										</tr><% Next %>
										<tr height="20">
											<td colspan="4"></td>
										</tr>
									</table><% else %>
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr height="100">
											<td align="center">등록된 카테고리 없습니다</td>
										</tr>
										<tr height="20">
											<td></td>
										</tr>
									</table><% end if %>
								  </td>
								</tr>
				</table></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
</table>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->