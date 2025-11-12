<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<% 
Dim tabnm : tabnm = "Lectmast"
Dim sPattern : sPattern = "[<][^>]*[>]"
Dim intpg,blockPage,pagecount,recordcount
Dim icon,icon_count,jj
Dim user_group,bimg

sql = "select count(idx) from Lectmast"
Set dr=db.execute(sql)

If dr(0) = 0 Then
	
	Response.redirect "dan_list.asp"
	Response.End

dr.close	
End if

If Len(str_User_ID) > 0 Then

	sql = "select sp1 from member where id = '"& str_User_ID &"'"
	Set dr = db.execute(sql)

	If dr.eof Or dr.bof Then
	Else
		user_group = dr(0)
	dr.close
	End if

End If

categbn = Request("categbn")

if Len(categbn) = 0 Then

	catenm = "패키지"

Else

		sql = "select bname,img from mscate where idx = "& categbn
		set dr = db.execute(sql)

		if not dr.bof or not dr.eof then
			catenm = dr(0)
			bimg = dr(1)
		end if
		dr.close

end If

Dim nowPage : nowPage = Request("URL")

intpg = Request("intpg")
if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

const pagesize = 10

Dim strClmn : strClmn = " idx,strnm,intprice,intgigan,strheader,sjin = case sajin when 'noimg.gif' then 'noimage.gif' else sajin end,cnt=dbo.mstCount(idx),icon,sub_title,book_idx,mem_group,dbo.order_mast_count_mst(idx,'"& str_User_ID &"'),dbo.order_mast_count_pass(idx,'"& str_User_ID &"') "

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
End Function  %>
<!-- #include file="../include/head1.asp" -->



<script language="javascript">
function go2ListPage(intpg,categbn){
	var args = go2ListPage.arguments;
	document.location.href="<%=nowPage%>?categbn=" + categbn + "&intpg=" + intpg;
}
function imgBrdStyle(flg,imobj){
	if(flg){
		imobj.style.border="solid 2px #FF6600";
	}
	else{
		imobj.style.border="none";
	}
}

function go2Basket(flg,ctgbn,idxn){
	if(flg){
		location.href="../member/login.asp?str__Page=" + encodeURIComponent("<%=nowPage%>?categbn=" + ctgbn + "&intpg=<%=intpg%>");
	}else{
		var params = "key=" + encodeURIComponent(idxn);
		sndReq("packagexml.asp",params,pkgBaguny,"POST");
	}
}

function pkgBaguny(){
	if(objXmlhttp.readyState == 4){
		if(objXmlhttp.status==200){
			var xmlDoc = objXmlhttp.responseXML;
			var obj = xmlDoc.getElementsByTagName("isrows");
			var flg =eval(obj[0].getAttribute("flg"));

			if(flg){
				 alert("이미 장바구니에 저장된 강좌입니다.");
			}else{
				var bool = confirm("장바구니에 저장되었습니다.\n지금 확인하시겠습니까?");
				if (bool){
					location.href = "/my/03_bguny.asp";
				}
			}

		}else{
			alert("네트웍 오류 : 개발자에게 문의하세요!");
		}
	}
}

function go2Mst(flg,ctgbn,idxn){
	if(flg){
		location.href="../member/login.asp?str__Page=" + encodeURIComponent("<%=nowPage%>?categbn=" + ctgbn + "&intpg=<%=intpg%>");
	}else{
		var params = "key=" + encodeURIComponent(idxn);
		sndReq("packagebuyxml.asp",params,setMstBuy,"POST");
	}
}

function setMstBuy(){
	if(objXmlhttp.readyState == 4){
		if(objXmlhttp.status==200){
			var xmlDoc = objXmlhttp.responseXML;
			var obj = xmlDoc.getElementsByTagName("isrows");
			var flg =eval(obj[0].getAttribute("flg"));
			var bygbn = obj[0].getAttribute("errgbn");
			bygbn = parseInt(bygbn,10);

			if(flg && bygbn == 3 ){
				location.href="../elpay/pay_mst.asp";
			}else{
				var strMsg = "";
				switch(bygbn){
					case 0:
						strMsg = "Error : 로그인 하지 않았거나, 네트웍에러";
						break;
					case 1:
						strMsg = "프리미엄을 수강하고 있으므로 과정강좌를 구매하실 필요없습니다!";
						break;
					case 2:
						strMsg = "현재 수강 중인 강좌이거나 입금대기중인 강좌입니다!";
						break;
				}
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
    	<div class="cont_tit">
        	<h3><%=catenm%></h3>
        </div>
        <div class="scont">

		<%If Len(bimg) > 0 then%><p style="width:830px;margin:0 0 20px 0;"><img src="/ahdma/quiz/<%=bimg%>" style="width:100%"><p><%End if%>

            <table class="btbl" style="width:830px">
				<colgroup>
				<col style="width:22%" />
				<col style="width:60%" />
				<col style="width:18%" />
				</colgroup>
				<thead>
					<tr>
						<th colspan="2">강의정보</th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody>
<% 
if categbn = "" then
	sql = "select Count(idx) from " & tabnm & " where state = 0"
else
	sql = "select Count(idx) from " & tabnm & " where state = 0 and gbn=" & categbn &""
end if
set dr = db.execute(sql)

recordcount = int(dr(0))
dr.close

if recordcount > 0 then
				
	isRecod = True
	pagecount=int((recordcount-1)/pagesize)+1 

if categbn = "" Then
	sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where state = 0 and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm
	sql = sql & " where state = 0 order by ordn asc) order by ordn asc"
else
	sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where state = 0 and gbn=" & categbn & " and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm
	sql = sql & " where state = 0 and gbn=" & categbn & " order by ordn asc) order by ordn asc"
End if
	set dr = db.execute(sql)
	ii = 0
	Do until dr.eof
%>
						<tr>
							<%If dr(5) <> "noimage.gif" Then%><td><img src="/ahdma/studimg/<%=dr(5)%>" alt="<%=dr(1)%>" onClick="location.href='class_view.asp?categbn=<%=categbn%>&idx=<%=dr(0)%>&intpg=<%=intpg%>';" style="cursor:pointer;max-width:200px;" ></td><%End if%>
							<td <%If dr(5) = "noimage.gif" Then Response.write "colspan='2'" End if%> class="cont"><%

				icon = split(dr(7),",")
				icon_count = ubound(icon)
				for jj=0 to icon_count
					if len(trim(icon(jj))) > 5 then
					response.write "<img src='/ahdma/logo/"& trim(icon(jj)) &"'>&nbsp;"
					end if
				next						
				%><a href="class_view.asp?categbn=<%=categbn%>&idx=<%=dr(0)%>&intpg=<%=intpg%>"><h4><%=dr(1)%></h4></a>
												<p><%=dr(8)%></p>
												구성 : 단과<%=dr(6)%>과목 / 기간 : <%=dr(3)%>일 / 수강료 : <strong class="frprice"><%=formatnumber(dr(2),0)%></strong>원
							</td>
							<td><a href="class_view.asp?categbn=<%=categbn%>&idx=<%=dr(0)%>&intpg=<%=intpg%>" class="sbtn">강의실입장</a>
							
<%If dr(11) = 0 And dr(12) = 0 then%>
								<%If Len(dr(10)) > 3 Then %>
					<%if instr(dr(10),", "& user_group &",") Then%>
					<a href="javascript:go2Basket(<%=strProg%>,'<%=categbn%>','<%=dr(0)%>');" class="sbtn">장바구니</a>
					<a href="javascript:go2Mst(<%=strProg%>,'<%=categbn%>','<%=dr(0)%>');" class="sbtn">수강신청</a>
					<%else%>
					<%End If%>
					<%else%>
					<a href="javascript:go2Basket(<%=strProg%>,'<%=categbn%>','<%=dr(0)%>');" class="sbtn">장바구니</a>
					<a href="javascript:go2Mst(<%=strProg%>,'<%=categbn%>','<%=dr(0)%>');" class="sbtn">수강신청</a>
					<%End if%>
<%End if%>
							
							</td>
						</tr>
<%
	ii = ii + 1
    dr.MoveNext
    Loop
End if
%>
				</tbody>
			</table>

            <!--  테이블 Paging 부분     -->
		<div class="paging">
<%
blockPage = int((intpg-1)/10) * 10 + 1

if blockPage = 1 Then
%>
			<img src="../img/img/a_prev2.gif" alt="처음페이지">
			<img src="../img/img/a_prev1.gif" alt="이전페이지">
<% else %>
			<a href="javascript:go2ListPage('1','<%=categbn%>');"><img src="../img/img/a_prev2.gif" alt="처음페이지"></a>			
			<a href="javascript:go2ListPage('<%=int(blockPage-1)%>','<%=categbn%>');"><img src="../img/img/a_prev1.gif" alt="이전페이지"></a>
<% end if

ii = 1
Do Until ii > 10 or blockPage > pagecount
	if blockPage = int(intpg) then 
%>
			<strong><%=blockPage%></strong>
<%	else	%>
			<a href="javascript:go2ListPage('<%=blockPage%>','<%=categbn%>');" class="pnum"><%=blockPage%></a>
<%
end if
	blockPage = blockPage + 1
    ii = ii + 1
	Loop
	
if blockPage > pagecount then %>
			<img src="../img/img/a_next1.gif" alt="다음페이지">
			<img src="../img/img/a_next2.gif" alt="마지막페이지">
<% else %>
			<a href="javascript:go2ListPage('<%=blockPage%>','<%=categbn%>');"><img src="../img/img/a_next1.gif" alt="다음페이지"></a>			
			<a href="javascript:go2ListPage('<%=pagecount%>','<%=categbn%>');"><img src="../img/img/a_next2.gif" alt="마지막페이지"></a>
<%End if%>
		</div>

        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" -->