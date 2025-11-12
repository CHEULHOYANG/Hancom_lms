<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim tabnm : tabnm = Request("tabnm")
dim idx : idx = request("idx")
dim sql,dr

if tabnm = "" then
	sql = "select top 1 idx from board_mast order by idx"
	set dr = db.execute(sql)
	tabnm = dr(0)
end if

Dim bbsJemok,pgbn,ygbn,mgbn
sql = "select jemok,pgbn,ygbn,mgbn from board_mast where idx=" & tabnm
set dr = db.execute(sql)
bbsJemok = dr(0)
pgbn = dr(1)
ygbn = dr(2)
mgbn = dr(3)
dr.close

Dim gbnS,strPart,strSearch,intpg
intpg = Request("intpg")
gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")
Dim varPage : varPage = "tabnm=" & tabnm & "&gbnS=" & gbnS & "&strPart=" & strPart & "&strSearch=" & strSearch & "&intpg=" & intpg

sql = "select title,content,regdate,readnum,writer,image1,image2,wrtid from board_board where idx=" & idx
set dr = db.execute(sql)
dim title,content,regdate,readnum,writer,image1,image2,wrtid
title = dr(0)
content = dr(1)
regdate = dr(2)
readnum = dr(3)
writer = dr(4)
image1 = dr(5)
image2 = dr(6)
wrtid = dr(7)
dr.close

dim dwnTxt : dwnTxt = "읽음"
if int(ygbn) < 2 then
	dwnTxt = "다운로드"
end if

dim imgDot,pAry,IMgis
IMgis = False
pAry = split(image1,".")
if UBound(pAry) > 0 then
	imgDot = pAry(UBound(pAry))
	if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" then
		IMgis = True
	end if
end if %>
<!--#include file="../main/top.asp"-->

<script language="javascript"><% if IMgis then %>
function imgResize(im){
	imgID = document.images[im];
	if(imgID.offsetWidth >= 650) imgID.style.width="650";
}
imgResize('pdsimg');
<% end if %>
function delLicen(){
	delok = confirm("이 게시글을 정말로 삭제하시겠습까?");
	if(delok){
		location.href="delete.asp?idx=<%=idx%>&tabnm=<%=tabnm%>";
	}
}

function bbsDel(bbcn){
	if(bbcn < 2){
		alert("게시판은 최소 1개 이상이 있어야 합니다!");
		return;
	}

	var delok = confirm("이 <%=bbsJemok%> 게시판을 정말로 삭제하시겠습니까?");
	if(delok){
		location.href="deleteb.asp?tabnm=<%=tabnm%>";
	}
}
function CheckByte(FieldName, fmName, textlimitName){
		var strCount = 0;
		var tempStr, tempStr2;
		var frm = fmName.neyong;
		var size = frm.value.length;
		for(i = 0;i < size;i++)
		{
			tempStr = frm.value.charAt(i);
			if(escape(tempStr).length > 4) strCount += 2;
				else strCount += 1 ;
		}
		if (strCount > FieldName){
			alert("최대 " + FieldName + "byte이므로 초과된 글자수는 자동으로 삭제됩니다.");
			strCount = 0;
			tempStr2 = "";
			for(i = 0; i < size; i++)
			{
				tempStr = frm.value.charAt(i);
				if(escape(tempStr).length > 4) strCount += 2;
				else strCount += 1 ;
				if (strCount > FieldName)
				{
					if(escape(tempStr).length > 4) strCount -= 2;
					else strCount -= 1 ;
					break;
				}
				else tempStr2 += tempStr;
			}
			frm.value = tempStr2;
		}
		document.getElementById(textlimitName).innerHTML = strCount;
}
function go2Write_memo(fm){

	var clmn;
	clmn = fm.neyong;
	if(clmn.value==""){
		alert("메모 내용을 입력해주세요!");
		clmn.focus();
		return;
	}
	fm.submit();
}

function replyDel(idxn){
	delok = confirm("정말로 삭제하시겠습니까?");
	if(delok){
		location.href="reply_del.asp?intpg=<%=Request("intpg")%>&gbnS=<%=Request("gbnS")%>&strPart=<%=Request("strPart")%>&strSearch=<%=Request("strSearch")%>&tabnm=<%=tabnm%>&tabidx=<%=idx%>&idx=" + idxn;
	}
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span><%=bbsJemok%></h2>

<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:15%" />
				<col style="width:35%" />
				<col style="width:15%" />
				<col style="width:35%" />
				</colgroup>
				<tbody>
					<tr>
						<th>제목</th>
						<td colspan="3"><%=title%></td>
					</tr>
					<tr>
						<th>글쓴이</th>
						<td><%=wrtid%>(<%=writer%>)</td>
						<th><%=dwnTxt%></th>
						<td><%=readnum%></td>
					</tr>
					<tr>
						<th>등록일</th>
						<td colspan="3"><%=right(FormatDateTime(regdate,2),10)%>&nbsp;<%=FormatDateTime(regdate,4)%></td>
					</tr>
					<tr>
						<th>내용</th>
						<td colspan="3">
						<% if IMgis then %><img src="/ahdma/pds/<%=image1%>" ID="pdsimg"><br /><br /><% end if %>
						<%=content%>
						<% if not image1 = "" then %><br /><img src="../rad_img/icon_file.gif"> <span style="cursor:pointer;color:#0000CC;" onMouseOver="this.style.color='#FF6600';" onMouseOut="this.style.color='#0000CC';" onClick="location.href='dwn.asp?idx=<%=idx%>';"><%=image2%></span><% end if %>
						</td>
					</tr>
					
				</tbody>
			</table>

		<div class="rbtn">
			<% if int(ygbn) > 2 then %><a href="write.asp?idx=<%=idx%>&<%=varPage%>" class="btn">답변</a><% end if %>
			<a href="edit.asp?idx=<%=idx%>&<%=varPage%>" class="btn trans">수정</a>		
			<a href="javascript:delLicen();" class="btn trans">삭제</a>		
			<a href="list.asp?<%=varPage%>" class="btn trans">목록</a>		
		</div>

<form name="rpfm" method="post" action="reply_write.asp" style="display:inline;">
<input type="hidden" name="tabnm" value="<%=tabnm%>">
<input type="hidden" name="tabidx" value="<%=idx%>">

<input type="hidden" name="intpg" value="<%=Request("intpg")%>">
<input type="hidden" name="gbnS" value="<%=Request("gbnS")%>">
<input type="hidden" name="strPart" value="<%=Request("strPart")%>">
<input type="hidden" name="strSearch" value="<%=Request("strSearch")%>">

		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:15%" />
				<col style="width:85%" />
				</colgroup>
				<tbody>
					<tr>
						<th>댓글</th>
						<td><textarea name="neyong" style="width:670px;height:40px;" class="inptxt1" onkeyup="CheckByte(600,rpfm,'textlimit');"></textarea> <a href="javascript:go2Write_memo(rpfm);" class="btn" >저장하기</a>
						<br /><span class="stip"><span ID="textlimit">0</span> / 600byte</span></td>
					</tr>					
				</tbody>
			</table>
</form>

		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:8%" />
			<col />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:8%" />
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>	
					<th>내용</th>
					<th>작성자</th>
					<th>작성일</th>	
					<th>기능</th>								
				</tr>				
			</thead>
			<tbody>
<%
ii = 0
sql = "select idx,usrid,neyong,regdate from replyTab where tabnm='" & tabnm & "' and tabidx=" & idx
set dr = db.execute(sql)

if not dr.bof or not dr.eof then
Do Until dr.eof
ii = ii + 1
%>
				<tr>
					<td><%=ii%></td>
					<td class="tl"><%=dr(2)%></td>
					<td><%=dr(1)%></td>
					<td><%=right(FormatDateTime(dr(3),2),10)%>&nbsp;<%=FormatDateTime(dr(3),4)%></td>
					<td><a href="javascript:replyDel('<%=dr(0)%>');" class="btns">삭제</a></td>
					
				</tr>
<%
dr.moveNext
Loop
end if
dr.close
%>
			</tbody>
		</table>

		<p class="mb80"></p>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->