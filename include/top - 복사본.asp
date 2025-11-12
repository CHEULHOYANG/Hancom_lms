<%
db.execute("sp_HoldOff '" & date & "'")

Dim user_IP1
user_IP1 = Request.Servervariables("REMOTE_ADDR")

Dim Dr1,CountIN1
Set Dr1 = db.execute("select Count(user_IP) from Chk_IP where user_IP='" & user_IP1 & "' and regdate='"& date() &"'")
CountIN1 = Dr1(0)

Dr1.Close

if CountIN1 < 1 then

Dim temp1

temp1 = split(request.ServerVariables("HTTP_USER_AGENT"),";")

dim vBrowser1, vOS1

if ubound(temp1) > 1 then
	vBrowser1 = temp1(1)
	vOS1 = temp1(2)
	vOS1 = replace(vOS1,")","")

	vBrowser1 = trim(vBrowser1)
	vOS1 = trim(vOS1)
	vBrowser1 = replace(vBrowser1,"'","''")
	vOS1 = replace(vOS1,"'","''")
end if

dim vReferer1,vDW1,vTarget1

vReferer1 = request.ServerVariables("HTTP_REFERER")
vTarget1 = request.ServerVariables("SCRIPT_NAME") & "?" & request.ServerVariables("QUERY_STRING")
vDW1 = weekday(date)

dim vSeason1
select case month(date)
	case 1,2,3
		vSeason1 = 1
	case 4,5,6
		vSeason1 = 2
	case 7,8,9
		vSeason1 = 3
	case 10,11,12
		vSeason1 = 4
end select

db.execute("insert into Chk_IP (user_IP,regdate) values ('" & user_IP1 & "','"& date &"')")

sql = "delete from Chk_IP where regdate <> '"& date() &"'"
db.execute sql,,adexecutenorecords

sql = "insert into Visit_Counter (vIP,vYY,vMM,vDD,vHH,vMT,vSeason,vDW,vBrowser,vOS,VReferer,vTarget) values ('"
sql = sql & user_IP1 & "'," & year(date) & "," & month(date) & "," & day (date) & "," & hour(now) & "," & minute(now) & ","
sql = sql & vSeason1 & "," & vDW1 & ",'" & vBrowser1 &"','" & vOS1 & "','" & vReferer1 &"','"& vTarget1 &"')"
db.execute(sql)

end if


str__Page = Request("str__Page")

if str__Page = "" then
	str__Page = Request.ServerVariables("PATH_INFO") & str__Var
end if

'if inStr(str__Page,"/pstudy") = 1 then
'	str__Page = Replace(str__Page,"/pstudy","")
'end if

if InStr(str__Page,"/member/") > 0 then
	str__Page = "/main/index.asp"
end if

dim logoimg : logoimg = "logo.gif"
sql = "select imgsrc from logoTab where gbn=1"
set dr = db.execute(sql)
if not dr.bof or not dr.eof then
	logoimg = dr(0)
end if
dr.close

if len(str_User_ID) > 0 then

	dim new_ip,m_ip,dr99,sql99,check_login_code
		
	new_ip = Request.ServerVariables("HTTP_X_FORWARDED_FOR")'클라이언트의 리얼IP받음
	
	If new_ip = "" Then '리얼Ip아닐때 동적IP받음(클라이언트)
	   new_ip = Request.ServerVariables("REMOTE_ADDR")
	end If
	
	if new_ip="" or len(new_ip)=0 then
	   response.write "<script language=javascript>alert('불법적인 접근입니다.1');location.href='../member/logout.asp';</script>"
	   response.end
	end if

	sql99 = "select ins_my from member where id = '"& str_User_ID &"'"
	set dr99 = db.execute(sql99)

	if not dr99.bof or not dr99.eof then
		m_ip = dr99(0)
	dr99.close
	end if		

	if Trim(m_ip) <> Trim(new_ip) then
	   response.write "<script language=javascript>alert('불법적인 접근입니다.');location.href='../member/logout.asp';</script>"
	   response.end
	end if	

end if

Function cutStrEv(strev, cutLenev)
	Dim strLenev, strByteev, strCutev, strResev, charev, iev
	strLenev = 0
	strByteev = 0
	strLenev = Len(strev)
	for iev = 1 to strLenev
		charev = ""
		strCutev = Mid(strev, iev, 1)
		charev = Asc(strCutev)
		charev = Left(charev, 1)
		if charev = "-" then
			strByteev = strByteev + 2
		else
			strByteev = strByteev + 1
		end if
		if cutLenev < strByteev then
			strResev = strResev & ".."
			exit for
		else
			strResev = strResev & strCutev
		end if
	next
	cutStrEv = strResev
End Function %>
<script language="javascript">
function go2Logpg(flg,ul){
	if(flg){
		alert("로그인후 서비스 이용이 가능합니다!");
		location.href="../member/login.asp?str__Page=" + encodeURIComponent(ul);
	}else{
		location.href=".." + ul;
	}
}
function go2Logpg1(flg,ul){
	if(flg){
		alert("로그인후 서비스 이용이 가능합니다!");
		location.href="/member/login.asp?str__Page=" + encodeURIComponent(ul);
	}else{
		location.href="" + ul;
	}
}

function go2Search(sKey,sfm){
	if(sKey || event) event.returnValue = false;
	clmn = sfm.searchStr;
	if(clmn.value==""){
		alert("검색어를 입력해주세요!");
		clmn.focus();
		return;
	}
	if(clmn.value.replace(/ /g,"") == ""){
		alert("검색어를 입력해주세요!");
		clmn.select();
		return;
	}
	if(clmn.value.length < 2){
		alert("검색어는 2자 이상 입력하셔야 합니다!");
		clmn.select();
		return;
	}
sfm.submit();
}

function bookmarksite() { 
     bookmark_url  = "<%=shop_url%>"; 
     bookmark_name = "<%=s_name%>"; 
     
     try {
      window.external.AddFavorite(bookmark_url,bookmark_name);
     } catch(e) {
      alert('이 브라우저는 즐겨찾기 추가 기능을 지원하지 않습니다.');
      return false;
     }
 }

</script>

<body>
<div class="header">
    <!--  TOP 메뉴  -->
    <div class="tmenu">
        <ul>
            <li class="left"><a href="javascript:bookmarksite('<%=s_name%>', '<%=shop_url%>');" class="favor">+ 즐겨찾기 추가</a></li>
<% if isUsr then %>
            <li class="right"><a href="/member/logout.asp">로그아웃</a><span class="slash">|</span><a href="/my/05_myinfo.asp">정보수정</a><span class="slash">|</span><a href="/my/01_main.asp">나의강의실</a></li>
<%else%>
            <li class="right"><a href="/member/login.asp">로그인</a><span class="slash">|</span><a href="/member/agree.asp">회원가입</a><span class="slash">|</span><a href="javascript:go2Logpg(<%=strProg%>,'/my/01_main.asp');">나의강의실</a></li>
<%End if%>
        </ul>
    </div>
    <div class="tWrap">
        <!--  LOGO, 검색폼, 이벤트배너   -->
        <div class="tban"><a href=""><img src="/img/img/tban_01.png" alt="독립형 이러닝솔루션 1,790,000원" /></a></div>
        <h1><a href="/main/index.asp"><img src="/ahdma/logo/<%=logoimg%>" /></a></h1>

<form name="searfm" method="post" action="../search/main.asp" style="display:inline;">
		<div class="tsearch">
            <input type="text" id="searchStr" name="searchStr" placeholder="검색어를 입력해 주세요!" />
            <a href="javascript:go2Search(false,searfm);" class="btn_sch mbg">검색하기</a>
		</div>
</form>

    </div>
    <!--  메뉴 부분   -->
    <div class="meWrap">
        <div class="menu">
            <a href="/page/page.asp" onmouseover="mopen(1);">학원소개</a> <a href="/study/class_list.asp" onmouseover="mopen(1);">수강신청</a><a href="/teach/teach.asp" onmouseover="mopen(1);">선생님소개</a> <a href="/book/list.asp" onmouseover="mopen(1);">교재소개</a><a href="/quiz/list.asp" onmouseover="mopen(1);">테스트</a><a href="/cumm/list.asp" onmouseover="mopen(1);">학습커뮤니티</a> <a href="/cs/nlist.asp" onmouseover="mopen(1);">고객센터</a>
        </div>
    </div>
    <div class="tlogWrap">
<% if isUsr then 

dim lsql,lrs,my_count,qa_count

lsql = "select count(*) from order_mast where id='" & str_User_ID & "' and state=0 and holdgbn=0"
set lrs = db.execute(lsql)

my_count = lrs(0)
lrs.close

lsql = "select count(*) from oneone where quserid='" & str_User_ID & "' "
set lrs = db.execute(lsql)

qa_count = lrs(0)
lrs.close
%>
            <div class="tlog">
                <dl>
                    <dt><strong class="fb"><%=str_User_Nm%></strong>님 반갑습니다.</dt>
                    <dd><span>나의 질문현황 : </span><em><%=qa_count%>건</em></dd>
                    <dd><span>수강중인 강좌 : </span><em><%=my_count%>개</em></dd>
                </dl>
                <div class="tlog_btn">
                    <a href="/my/05_myinfo.asp">정보수정</a><a href="/member/logout.asp">로그아웃</a>
                </div>
            </div>
<%else%>
<script language="javascript">
function strOnSubmit(isKey,theform){

	if(isKey || event) event.returnValue = false;

	clmn = theform.usrid;
	if(clmn.value.replace(/ /g,"") == ""){
		alert("아이디를 입력해주세요!");
		clmn.focus();
		return;
	}
	clmn = theform.usrpwd;
	if(clmn.value == ""){
		alert("비밀번호를 입력해주세요!");
		return;
	}

	theform.submit();

}
</script>
            <div class="tlog">
<form name="tlogfm" action="../member/login_ok.asp" method="post" style="display:inline;">
                <fieldset>
                    <input name="usrid" type="text" class="inptxt" placeholder="아이디" tabindex="1" onkeypress="if(event.keyCode==13) strOnSubmit(true,document.tlogfm);" />
                    <input name="usrpwd" type="password" class="inptxt" id="usrpwd" tabindex="2" placeholder="비밀번호" onkeypress="if(event.keyCode==13) strOnSubmit(true,document.tlogfm);"/>
                    <a href="javascript:strOnSubmit(false,document.tlogfm);" class="log_btn">LOGIN</a>
                </fieldset>
</form>
                <div class="tmem_me">
                	<a href="/member/cmsid.asp">아이디/비밀번호찾기</a>
                </div>
            </div>
<%End if%>
        </div>

<script type="text/javascript">
var TimeOut         = 300;
var currentLayer    = null;
var currentitem     = null;

var currentLayerNum = 0;
var noClose         = 0;
var closeTimer      = null;

function mopen(n)
{
    var l  = document.getElementById("menu"+n);
    var mm = document.getElementById("mmenu"+n);
   
    if(l)
    {
        mcancelclosetime();
        l.style.visibility='visible';

        if(currentLayer && (currentLayerNum != n))
            currentLayer.style.visibility='hidden';

        currentLayer = l;
        currentitem = mm;
        currentLayerNum = n;           
    }
    else if(currentLayer)
    {
        currentLayer.style.visibility='hidden';
        currentLayerNum = 0;
        currentitem = null;
        currentLayer = null;
    }
}

function mclosetime()
{
    closeTimer = window.setTimeout(mclose, TimeOut);
}

function mcancelclosetime()
{
    if(closeTimer)
    {
        window.clearTimeout(closeTimer);
        closeTimer = null;
    }
}

function mclose()
{
    if(currentLayer && noClose!=1)
    {
        currentLayer.style.visibility='hidden';
        currentLayerNum = 0;
        currentLayer = null;
        currentitem = null;
    }
    else
    {
        noClose = 0;
    }

    currentLayer = null;
    currentitem = null;
}
document.onclick = mclose;
</script>

    <div class="smeWrap" id="menu1" onMouseOver="mcancelclosetime();" onMouseOut="mclosetime();">
    	<div class="smenu">
            <dl>
            	<dt>학원소개</dt>
                <dd><a href="">고등대비</a>
                	<a href="">특목고 대비</a>
                    <a href="">인증시험</a>
                    <a href="">영역별</a>
                    <a href="">영어특별코스</a></dd>
            </dl>
            <dl>
            	<dt>수강신청</dt>
                <dd><a href="">국어</a>
                	<a href="">영어</a>
                    <a href="">수학</a>
                    <a href="">사회/역사</a>
                    <a href="">과학</a>
                    <a href="">예체능/기타</a>
                    <a href="">Yes쌤</a></dd>
            </dl>
            <dl>
            	<dt>선생님소개</dt>
                <dd><a href="">고등대비</a>
                	<a href="">특목고 대비</a>
                    <a href="">인증시험</a>
                    <a href="">영역별</a>
                    <a href="">영어특별코스</a></dd>
            </dl>
            <dl>
            	<dt>교재소개</dt>
                <dd><a href="">국어</a>
                	<a href="">영어</a>
                    <a href="">수학</a>
                    <a href="">사회/역사</a>
                    <a href="">과학</a>
                    <a href="">예체능/기타</a>
                    <a href="">Yes쌤</a></dd>
            </dl>
            <dl>
            	<dt>테스트</dt>
                <dd><a href="">국어</a>
                	<a href="">영어</a>
                    <a href="">수학</a>
                    <a href="">사회/역사</a>
                    <a href="">과학</a>
                    <a href="">예체능/기타</a>
                    <a href="">Yes쌤</a></dd>
            </dl>
            <dl>
            	<dt>커뮤니티</dt>
                <dd><a href="">고입정보</a>
                	<a href="">입시전략</a>
                    <a href="">학습전략</a>
                    <a href="">진로탐색</a>
                    <a href="">시험정보</a>
                    <a href="">수행평가자료</a></dd>
            	<dt>자료실</dt>
                <dd><a href="">고입정보</a>
                	<a href="">입시전략</a>
                    <a href="">학습전략</a>
                    <a href="">진로탐색</a>
                    <a href="">시험정보</a>
                    <a href="">수행평가자료</a></dd>
            </dl>
            <dl>
            	<dt>고객센터</dt>
                <dd><a href="">FAQ</a>
                	<a href="">초보자가이드</a>
                    <a href="">공지사항</a>
                    <a href="">1:1상담</a>
                    <a href="">프로그램다운</a></dd>
            	<dt>설문</dt>
                <dd><a href="">FAQ</a>
                	<a href="">초보자가이드</a>
                    <a href="">공지사항</a>
                    <a href="">1:1상담</a>
                    <a href="">프로그램다운</a></dd>
            </dl>
    	</div>
    </div>
</div>