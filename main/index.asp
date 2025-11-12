<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->

<%
Dim i,rs,use_name,rs1,j
Dim b_counts
Dim mtitle1,mtitle2,mtitle3,mtitle4,mtitle5,mtitle6,mtitle7,mtitle8,mtitle9,mtitle10
Dim mlink1,mlink2,mlink3,mlink4,mlink5,mlink6,mlink7,mlink8,mlink9,mlink10
			  
sql="select mtitle1,mtitle2,mtitle3,mtitle4,mtitle5,mtitle6,mtitle7,mtitle8,mtitle9,mtitle10,mlink1,mlink2,mlink3,mlink4,mlink5,mlink6,mlink7,mlink8,mlink9,mlink10 from site_info"
 set rs=db.execute(sql)
			  
if rs.eof or rs.bof then
else
			  
	mtitle1 = rs(0)
	mtitle2 = rs(1)
	mtitle3 = rs(2)
	mtitle4 = rs(3)
	mtitle5 = rs(4)
	mtitle6 = rs(5)
	mtitle7 = rs(6)
	mtitle8 = rs(7)
	mtitle9 = rs(8)
	mtitle10 = rs(9)
	mlink1 = rs(10)
	mlink2 = rs(11)
	mlink3 = rs(12)
	mlink4 = rs(13)
	mlink5 = rs(14)
	mlink6 = rs(15)
	mlink7 = rs(16)
	mlink8 = rs(17)
	mlink9 = rs(18)
	mlink10 = rs(19)

rs.close
end if
%>

<!-- #include file="../include/head1.asp" -->

<%
sql = "select pop_idx from popinfoTab where pop_gbn > 0 and pop_gu = 0"
set dr = db.execute(sql)
Dim isPopup
if not dr.bof or not dr.eof then
	Dim popAry
	isPopup = True
	do until dr.Eof
		popAry = popAry & dr(0) & ","
	dr.moveNext
	Loop
end if
dr.close

if isPopup then %>

<SCRIPT LANGUAGE="JavaScript">
<!--//
	function getCookie(strName) {
	  var strArg = new String(strName + "=");	
	  var nArgLen, nCookieLen, nEnd;
	  var i = 0, j;

	  nArgLen    = strArg.length;
	  nCookieLen = document.cookie.length;

	  if(nCookieLen > 0) {
		while(i < nCookieLen) {
		  j = i + nArgLen;
		  if(document.cookie.substring(i, j) == strArg) {
			nEnd = document.cookie.indexOf (";", j);

			if(nEnd == -1) nEnd = document.cookie.length;
				return unescape(document.cookie.substring(j, nEnd));
			} //end if

			i = document.cookie.indexOf(" ", i) + 1;
			if (i == 0) break; //no end if
		  } //end if
	  }

	  return("");
	}
	
	function setCookie( name, value, expiredays ) { 
	  var todayDate = new Date(); 
	  todayDate.setDate( todayDate.getDate() + expiredays ); 
	  document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";" 
	}
	//-->
</SCRIPT>
<% end if %>


<% if isPopup Then

Dim keyAry
keyAry = split(popAry,",")

for ii = 0 to Ubound(keyAry) - 1
sql = "select pop_nm,pop_neyong,pop_width,pop_height,pop_cookie,pop_top,pop_left from popinfoTab where pop_idx=" & keyAry(ii)
set dr = db.execute(sql)
if int(dr(4)) > 0 then
	if Not Request.Cookies("cook" & keyAry(ii)) = "open" & keyAry(ii) then %>

<div style="position:absolute;top:<%=dr(5)%>px;left:<%=dr(6)%>px;z-index:1000;" ID="divpop<%=keyAry(ii)%>">
<form name="notice_form<%=keyAry(ii)%>">
	<table cellpadding="0" cellspacing="0">
		<tr>
			<td>
			<table cellpadding="0" cellspacing="0" width="<%=dr(2)%>">
				<tr height="<%=(dr(3))%>">
					<td ><%=dr(1)%></td>
				</tr>
			</table>
		  </td>
		</tr>
		<tr height="25">
			<td>
			<table cellpadding="0" cellspacing="0" width="<%=dr(2)%>">
				<tr>
					<td bgcolor="#ffffff" height="25">&nbsp;<input type="checkbox" name="chkbox" value="checkbox" />					  <font color='#000000'>하루동안열지않음</font>
					&nbsp;<b><span style="color:#000000;cursor:pointer;" onMouseOver="this.style.color='#999999';" onMouseOut="this.style.color='#000000';" onClick="javascript:closeWin<%=keyAry(ii)%>();">닫기</span></td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
</form>
</div>

<script language="Javascript">
<!--//
	cookiedata = document.cookie;

	if ( cookiedata.indexOf("maindiv<%=keyAry(ii)%>=done") < 0 ) {
	  document.all['divpop<%=keyAry(ii)%>'].style.visibility = "visible";
	} else {
	  document.all['divpop<%=keyAry(ii)%>'].style.visibility = "hidden"; 
	}

	function closeWin<%=keyAry(ii)%>() { 
	  if ( document.notice_form<%=keyAry(ii)%>.chkbox.checked ){ 
		setCookie( "maindiv<%=keyAry(ii)%>", "done" , 1 ); 
	  } 
	  document.all['divpop<%=keyAry(ii)%>'].style.visibility = "hidden";
	}
//-->  
</script>

<% end if
else %>
<div style="position:absolute;top:<%=dr(5)%>px;left:<%=dr(6)%>px;z-index:1000;" ID="divpop<%=keyAry(ii)%>">
<form name="notice_form<%=keyAry(ii)%>">
	<table width="<%=int(dr(2)) %>" cellpadding="0" cellspacing="0">
		<tr>
		  <td>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr height="<%=(dr(3))%>">
					<td width="5" ></td>
					<td width="<%=dr(2) - 10%>"><%=dr(1)%></td>
					<td width="5" ></td>
				</tr>
			</table>
		  </td>
		</tr>
	</table>
</form>
</div><% end if
dr.close
Next
end if %>

<!-- #include file="../include/top.asp" -->

<div class="mban_zone">
    <div class="mban">

<% 
sql = "select count(idx) from banner where areagbn='010' and (right(banner,3)='jpg' or right(banner,3)='gif' or right(banner,3)='png') "
Set rs = db.execute(sql)

b_counts = rs(0)
rs.close

Dim m_banner(50),m_banner_url(50),m_target(50),m_title(50),m_bgcolor(50)

sql = "select banner,banner_url,target,title,bgcolor from banner where  areagbn='010' and (right(banner,3)='jpg' or right(banner,3)='gif' or right(banner,3)='png') order by  ordnum asc , idx desc"
Set rs = db.execute(sql)

If rs.eof Or rs.bof Then
Else
i=1
Do Until rs.eof
	
	m_banner(i) = rs(0)
	m_banner_url(i) = rs(1)
	m_target(i) = rs(2)
	m_title(i) = rs(3)
	m_bgcolor(i) = rs(4)

rs.movenext
i=i+1
Loop
rs.close
End If

for i = 1 to b_counts
%>
        <ul id="b<%=i%>" style="display:<%If i > 1 Then response.write"none" End if%>;">
        	<li style="background:<%=m_bgcolor(i)%>"><%If Len(m_banner_url(i)) = 0 then%><img src="/ahdma/banner/<%=m_banner(i)%>" /><%else%><a href="<%=m_banner_url(i)%>" target="<%=m_target(i)%>"><img src="/ahdma/banner/<%=m_banner(i)%>" /></a><%End if%></li>
        </ul>
<%
next
%>

<script>
function bview(flag){
<%for i = 1 to b_counts%>
	b<%=i%>.style.display = "none";
<%next%>

	switch (flag)
	{
<%for i = 1 to b_counts%>
		case <%=i%>: b<%=i%>.style.display = ""; break;
<%next%>
	}
} 

function chbanner(ii){

<%for i = 1 to b_counts%>
	if (ii==<%=i%>)	{
	bview(<%=i%>);
	<%If i = b_counts then%>
	setTimeout("chbanner(<%=1%>);",5000);
	<%else%>
	setTimeout("chbanner(<%=i+1%>);",5000);
	<%end if%>
	}
<%next%>
	
}
<%if b_counts > 0 then%>
chbanner(1);
<%end if%>
</script>

        <div class="rban"> <% sql99 = "select top 1 banner,banner_url,filegbn,target from banner where areagbn='011' order by  ordnum asc , idx desc"
	set dr99 = db.execute(sql99)
	if not dr99.bof or not dr99.eof then
	do until dr99.eof 
	response.write BannerOutput(dr99(0),dr99(1),dr99(2),190,dr99(3))
	dr99.movenext
	Loop
	end if
	dr99.close
	
	sql99 = "select top 1 banner,banner_url,filegbn,target from banner where areagbn='012' order by  ordnum asc , idx desc"
	set dr99 = db.execute(sql99)
	if not dr99.bof or not dr99.eof then
	do until dr99.eof 
	response.write " "& BannerOutput(dr99(0),dr99(1),dr99(2),190,dr99(3)) &""
	dr99.movenext
	Loop
	end if
	dr99.close
	%> </div>

    </div>
</div>

<div class="container">
<div class="thr_ban">
        <dl>
            <a href="http://1.1.1.70/study/dan_list.asp?ca1=1">
            <dt><span class="thr_ico mbg"></span><strong>오피스 <br>업무 실무과정</strong></dt>
          
            </a>
        </dl>
        <dl>
            <a href="http://1.1.1.70/study/dan_list.asp?ca1=5">
            <dt><span class="thr_ico ti1 mbg"></span><strong>국가 공인 자격증<br>자격증 취득 과정</strong></dt>
            
            </a>
        </dl>
        <dl>
            <a href="http://1.1.1.70/study/dan_list.asp?ca1=8">
            <dt><span class="thr_ico ti2 mbg"></span><strong>정보 보안<br>시스템 보안과정</strong></dt>
            
            </a>
        </dl>
    </div>
</div>

<div class="container">
    <div class="column">

       <div class="mbox">
            <div class="mtit">
                <h3><strong>신규강의</strong></h3>
                <a href="/study/dan_list.asp" class="imore mbg">더보기</a> 
			</div>
            <div class="samlist">
<%
sql = "select top 4 idx,strnm,strteach,intprice,totalnum,sjin=case sajin when 'noimg.gif' then 'noimage.gif' else sajin end,intgigan,tinfo,icon,book_idx,sub_title,dbo.dan_category_title(ca1) from LecturTab where state = 0 order by idx desc"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
Do Until rs.eof
%>
                <dl>
                    <a href="/study/dan_view.asp?idx=<%=rs(0)%>">
                    <dt><span class="tch_name"><%=rs(11)%></span>
                        <p><font color='#ff6633'><%=rs(1)%></font><br /><%=rs(10)%></p>
                    </dt>
                    <dd><img src="/ahdma/studimg/<%=rs(5)%>" style="width:80px;height:80px" /></dd>
                    </a>
                </dl>
<%
rs.movenext
Loop
rs.close
End if
%>
            </div>
        </div>

<div class="mbox">
            <div class="mtit">
                <h3><strong>추천강의</strong></h3>
                <a href="/study/dan_list.asp" class="imore mbg">더보기</a> 
			</div>
            <div class="samlist">
<%
sql = "select top 4 idx,strnm,strteach,intprice,totalnum,sjin=case sajin when 'noimg.gif' then 'noimage.gif' else sajin end,intgigan,tinfo,icon,book_idx,sub_title,dbo.dan_category_title(ca1) from LecturTab where inginum > 0 and state = 0 order by idx desc"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
Do Until rs.eof
%>
                <dl>
                    <a href="/study/dan_view.asp?idx=<%=rs(0)%>">
                    <dt><span class="tch_name"><%=rs(11)%></span>
                        <p><font color='#ff6633'><%=rs(1)%></font><br /><%=rs(10)%></p>
                    </dt>
                    <dd><img src="/ahdma/studimg/<%=rs(5)%>" style="width:80px;height:80px" /></dd>
                    </a>
                </dl>
<%
rs.movenext
Loop
rs.close
End if
%>
            </div>
        </div>
    
        <div class="mbox">
            <div class="mtit">
                <h3><strong>수강후기</strong></h3>
                <a href="/study/reply_list.asp" class="imore mbg">더보기</a> </div>
            <ul class="relist">
<%
sql = "select top 5 idx,id,name,content,regdate,star,vidx,vcat,(select strnm from LecturTab where idx=A.vidx),(select sajin from LecturTab where idx=A.vidx) from lec_reply A order by idx desc"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
Do Until rs.eof
%>
                <li>
					<a href="/study/dan_view.asp?idx=<%=rs(6)%>"><span class="rename"><%=Left(rs(2),1)%>**</span>
						<div class="retxt"><%=cutstr(rs(3),30)%></div>
                    </a>
				</li>
<%
rs.movenext
Loop
rs.close
End if
%>
            </ul>
        </div>


 

    <div class="column">
        <ul class="ingi_list">
<%
	sql = "select top 6 id,name,title,content1,content2,vod,guk,main,img1,img2,content3,idx from teach_mast where main = 1 order by newid()"
	Set rs=db.execute(Sql)

	If rs.eof Or rs.bof Then
	Else
	Do Until rs.eof
%>
            <li style="background:url(/ahdma/pds/<%=rs(8)%>) no-repeat center bottom">
            	<a href="/teach/v_list.asp?tidx=<%=rs(11)%>">
                <div class="mingi_txt">
                	<strong><%=rs(6)%><br /><%=rs(1)%></strong>
                    <span><%=rs(2)%></span>
                </div></a>
            </li>
<%
	rs.movenext
	Loop
	rs.close
	End If
%>
        </ul>
    </div>
    
    </div>
    <div class="column">
        <div class="csWrap">
            <div class="cs_cen">
                <div class="cstit">
                    <h3>고객센터</h3>
                </div>
                <div class="cstxt"> <strong><%=Replace(help_tel,"-",".")%></strong>
                    <p><%=help_time1%><br />
                        <%=help_time2%></p>
                    <a href="/cs/qlist.asp" class="csbtn"><span>상담 신청하기</span></a>
<%
sql="select top 1 idx,bankname,banknumber,use_name from bank"
set rs = db.execute(sql)

If rs.eof Or rs.bof Then
Else
Do Until rs.eof
%>
                    <p><%=rs(1)%>:<%=rs(2)%><br />(예금주:<%=rs(3)%>)</p>
<%
rs.movenext
Loop
rs.close
End if
%>
                </div>
            </div>
            <div class="cslist">
                <ul>
                    <li><a href="/cs/nlist.asp">공지사항</a></li>
                    <li><a href="/cs/flist.asp">자주묻는질문과답변</a></li>
                    <li><a href="/cs/qlist.asp">문의게시판</a></li>
<%
sql = "select idx,jemok from guideTab where gbn = 1 order by idx"
set dr = db.execute(sql)
if not dr.bof or not dr.eof then
do until dr.eof 
%>
			<li><a href="/cs/page.asp?idx=<%=dr(0)%>"><%=dr(1)%></a></li>
<%
dr.movenext
Loop
else 
end if
dr.close
%>
                </ul>
            </div>
            <div class="column_right">
                <div class="cntit">
                    <h3>공지사항</h3>
                </div>
                <div class="mnotice">
                    <ul>
<%
sql = "select top 6 idx,jemok,wday from notice order by idx desc"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
Do Until rs.eof
%>
                            <li><a href="/cs/nneyong.asp?idx=<%=rs(0)%>"><%=cutstr(rs(1),44)%></a></li>
<%
rs.movenext
Loop
rs.close
End if
%>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" -->
<%
				Function viewProg(v,u)
					if isUsr then
						viewProg = 0
						if int(v) > 1 and Not u = str_User_ID then
							viewProg = 2
						end if
					else
						viewProg = 1
					end if
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