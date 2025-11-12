<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<%
dim tabnm : tabnm = Request("tabnm")
dim idx : idx = request("idx")
Dim nowPage : nowPage = Request("URL")
Dim bbsJemok,pgbn,ygbn,mgbn,mem_group,logincheck,top_message,bottom_message
Dim gbnS,strPart,strSearch,intpg
intpg = Request("intpg")
gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")
Dim varPage : varPage = "tabnm=" & tabnm & "&gbnS=" & gbnS & "&strPart=" & strPart & "&strSearch=" & strSearch & "&intpg=" & intpg

sql = "select jemok,pgbn,ygbn,mgbn,mem_group,logincheck,top_message,bottom_message from board_mast where idx=" & tabnm
set dr = db.execute(sql)
bbsJemok = dr(0)
pgbn = dr(1)
ygbn = dr(2)
mgbn = dr(3)
mem_group = dr(4)
logincheck = dr(5)
top_message = dr(6)
bottom_message = dr(7)
dr.close

''회원만
If (logincheck) = 1 Then

	If Len(str_User_ID) = 0 Then

			response.redirect "/member/login.asp?str__Page="& server.urlencode(nowPage) &"?"& server.urlencode(Request.ServerVariables("QUERY_STRING")) &""
			response.End

	End If
	
End If

''수강회원만
If (logincheck) = 2 Then

		sql = "select count(idx) from order_mast where id='" & str_User_ID & "' and eday > convert(smalldatetime,getdate()) and state=0 and holdgbn=0"
		set dr = db.execute(sql)
	
		If dr(0) = 0 Then

			response.write"<script>"
			response.write"alert('해당 게시판은 수강회원만 이용이 가능합니다.');"
			response.write"self.location.href='../main/index.asp';"
			response.write"</script>"
			response.End
			
		End If
		
End If

sql = "select title,content,regdate,readnum,writer,image1,image2,wrtid,pwd from board_board where idx=" & idx
set dr = db.execute(sql)
dim title,content,regdate,readnum,writer,image1,image2,wrtid,pwd
title = dr(0)
content = dr(1)
regdate = dr(2)
readnum = dr(3)
writer = dr(4)
image1 = dr(5)
image2 = dr(6)
wrtid = dr(7)
pwd = dr(8)
dr.close

If Len(pwd) > 0 Then

	If Len(request.cookies("user_pwd")) = 0 and Len(request("user_pwd")) = 0 Then

		response.redirect "pwd_check.asp?idx="& request("idx") &"&intpg="& request("intpg") &"&tabnm="& request("tabnm") &"&gbnS="& request("gbnS") &"&strPart="& request("strpart") &"&strSearch="& request("strSearch") &""

	Else
	
		If Len(request("user_pwd")) > 0 Then

			If Trim(request("user_pwd")) <> Trim(pwd) Then

				response.write"<script>"
				response.write"alert('비밀번호를 확인해주세요.');"
				response.write"self.location.href='pwd_check.asp?idx="& request("idx") &"&intpg="& request("intpg") &"&tabnm="& request("tabnm") &"&gbnS="& request("gbnS") &"&strPart="& request("strpart") &"&strSearch="& request("strSearch") &"';"
				response.write"</script>"
				response.End

			Else
				
				Response.Cookies("user_pwd") = request("user_pwd")
				
			End if
		
		End If
		
		If Len(request.cookies("user_pwd")) > 0 Then

			If Trim(request.cookies("user_pwd")) <> Trim(pwd) Then

				Response.Cookies("user_pwd") = ""

				response.write"<script>"
				response.write"alert('비밀번호를 확인해주세요.');"
				response.write"self.location.href='pwd_check.asp?idx="& request("idx") &"&intpg="& request("intpg") &"&tabnm="& request("tabnm") &"&gbnS="& request("gbnS") &"&strPart="& request("strpart") &"&strSearch="& request("strSearch") &"';"
				response.write"</script>"
				response.End
				
			End If
			
		End if

	End If
	
End if

If Len(mem_group) > 3 Then

	sql = "select sp1 from member where id = '"& str_User_ID &"'"
	Set dr = db.execute(sql)

	If dr.eof Or dr.bof Then

			response.redirect "/member/login.asp?str__Page="& server.urlencode(nowPage) &"?"& server.urlencode(Request.ServerVariables("QUERY_STRING")) &""
			response.End

	Else

		if instr(mem_group,", "& dr(0) &",") Then
		else

			response.write"<script>"
			response.write"alert('해당 게시판은 그룹권한을 가진 회원만 접속이 가능합니다.');"
			response.write"history.back();"
			response.write"</script>"
			response.End
			
		End If
		
	dr.close
	End if

End if

dim imgDot,pAry,IMgis
IMgis = False
pAry = split(image1,".")
if UBound(pAry) > 0 then
	imgDot = pAry(UBound(pAry))
	if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "png" then
		IMgis = True
	end if
end if

db.execute("update board_board set readnum=readnum+1 where idx=" & idx) %>
<!-- #include file="../include/head1.asp" -->

<script language="javascript">
function go2dwn(flg){
	if(flg){
		alert("로그인 후에 이용하실 수 있습니다!");
		return;
	}
	location.href="../jalyo/dwn.asp?idx=<%=idx%>";
}

function go2Del(){
	delok = confirm("정말로 삭제하시겠습니까?");
	if(delok){
		location.href="delete.asp?idx=<%=idx%>&tabnm=<%=tabnm%>";
	}
}<% if IMgis then %>
function imgResize(im){
	imgID = document.images[im];
	if(imgID.offsetWidth >= 700) imgID.style.width="700";
}<% end if %>

function go2Ans(flg){
	if(flg){
		alert("로그인 후 이용하세요!");
	}else{
		location.href="write.asp?idx=<%=idx%>&<%=varPage%>";
	}
}
</script>

<!-- #include file="../include/top.asp" -->
    
<div class="smain">    
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3><%=bbsJemok%></h3>
        </div>
        <div class="scont">

		<%If Len(top_message) > 0 then%>
		<p style="margin:0 0 20px 0"><%=top_message%></p>
        <%End if%>      

            <table class="ftbl" style="width:830px">
                    <colgroup>
                    <col style="width:20%" />
                    <col style="width:60%" />
                    <col style="width:20%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>제목</th>
                            <td colspan="2"><%=title%></td>
                        </tr>
                        <tr>
                            <th>글쓴이</th>
                            <td><%=writer%> / <%=regdate%></td>
                            <td>조회수 : <%=readnum%></td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="cmt" colspan="3">
                            <p><% if IMgis then %><img src="../ahdma/pds/<%=image1%>" ID="pdsimg"><br /><br /><%End if%><%=content%><% if not image1 = "" then %><br /><br /><img src="../img/disk.png" align="absmiddle">&nbsp;<span onclick="go2dwn(<%=strProg%>);" style="cursor:pointer;"><u><%=image2%></u></span><%End if%></p></td>
                        </tr>
                    </tbody>
                </table>

            <div class="cbtn"> <%
if int(pgbn) > 0 then 
	if int(ygbn) > 2 then 
%>
			<a href="javascript:go2Ans(<%=strProg%>);" class="mbtn grey">답변하기</a>
<% end If
	if wrtid = str_User_ID then %>
			<a href="edit.asp?idx=<%=idx%>&<%=varPage%>" class="mbtn grey">수정하기</a>
			<a href="javascript:go2Del();" class="mbtn grey">삭제하기</a>
<%
	End if
End if%>
			<a href="list.asp?<%=varPage%>" class="mbtn">목록으로</a> </div>




<% if int(mgbn) > 0 then %>	
<script language="javascript">
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
function go2Write_memo(fm,flg){
	if(flg){
		alert("로그인 후에 이용하실 수 있습니다!");
		return;
	}

	var clmn;
	clmn = fm.neyong;
	if(clmn.value==""){
		alert("내용을 입력해주세요!");
		clmn.focus();
		return;
	}
	fm.submit();
}

function replyDel(idxn){
	delok = confirm("정말로 삭제하시겠습니까?");
	if(delok){
		location.href="reply_del.asp?intpg=<%=request("intpg")%>&gbnS=<%=request("gbnS")%>&strpart=<%=request("strpart")%>&strsearch=<%=request("strsearch")%>&tabnm=<%=tabnm%>&tabidx=<%=idx%>&idx=" + idxn;
	}
}
</script>
<form name="rpfm" method="post" action="reply_write.asp" style="display:inline;">
<input type="hidden" name="tabnm" value="<%=request("tabnm")%>">
<input type="hidden" name="tabidx" value="<%=request("idx")%>">
<input type="hidden" name="gbnS" value="<%=request("gbnS")%>">
<input type="hidden" name="strpart" value="<%=request("strpart")%>">
<input type="hidden" name="strsearch" value="<%=request("strsearch")%>">
<input type="hidden" name="intpg" value="<%=request("intpg")%>">
		<dl class="reple">
				<dt>댓글</dt>
				<dd>
					<textarea name="neyong" id="neyong" cols="45" rows="5" class="txtarea" style="width:95%" onKeyUp="CheckByte(250,rpfm,'textlimit');"></textarea>
				</dd>
				<dd><div class="stip">기타의견은 250자 내외로 입력하실 수 있습니다. <strong class="fb" ID="textlimit">0</strong>/250Byte</div>
					<a href="javascript:go2Write_memo(rpfm,<%=strProg%>);" class="ssbtn blue">댓글달기</a>
				</dd>
		</dl>
</form>

		<ul class="re_list">
<%
sql = "select idx,usrid,neyong,regdate from replyTab where tabnm='" & tabnm & "' and tabidx=" & idx
set dr = db.execute(sql)

If dr.eof Or dr.bof Then
else
Do Until dr.eof
%>
			<li><div class="re_tdl">
						<div class="re_img"><img src="../img/img/profile_img.gif" /></div>
						<div class="re_text">
							<div class="re_top"><strong><%=dr(1)%></strong><span><%=Replace(right(FormatDateTime(dr(3),2),8),"-",".")%>&nbsp;<%=FormatDateTime(dr(3),4)%></span></div>
							<p><%=replace(dr(2),chr(13) & chr(10),"<br>")%></p>
							<%If dr(1) = str_User_ID then%><a href="javascript:replyDel(<%=dr(0)%>);" class="smbtn">삭제</a><%End if%></div>
					</div>
			</li>
<%
dr.movenext
Loop
dr.close
End If
%>
		</ul>
<%end if%>

        <%If Len(bottom_message) > 0 then%>
                <p style="margin:0 0 10px 0"><%=bottom_message%></p>
        <%End if%>        

        </div>
    </div>
</div>    

<% if IMgis then %>
<script>imgResize('pdsimg');</script>
<% end if %>    

<!-- #include file="../include/bottom.asp" -->