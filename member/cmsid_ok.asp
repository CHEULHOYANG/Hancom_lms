<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file = "../include/refer_check.asp" -->
<%
vPage = vPage & "/member/cmsid.asp"

if vReferer = vPage then %><!-- #include file = "../include/dbcon.asp" --><%	Dim username,email,tel2

	username = Request.Form("username")
	email = Request.Form("email")
	tel2 = Request.Form("tel1") &"-"& Request.Form("tel2") &"-"& Request.Form("tel3")

	username = Tag2Txt(username)
	email = Tag2Txt(email)
	tel2 = Tag2Txt(tel2)

	Dim FindRecod

	sql = "select id,regdate from member where name='" & username & "' and email='" & email & "' and tel2='" & tel2 & "' "
	set dr = db.execute(sql)

	if not dr.Bof or not dr.Eof then
		Dim userid,regdate
		userid = dr(0)
		regdate = dr(1)
		FindRecod = True
	end if
	dr.close

Function Tag2Txt(s)
			s = Replace(s,"'","''")
			s = Replace(s,"<","&lt;")
			s = Replace(s,">","&gt;")
			s = Replace(s,"&","&amp;")
			Tag2Txt = s
End Function
%>
<!-- #include file="../include/head1.asp" -->
<!-- #include file = "../include/top.asp" -->

<div class="scontent">

    	<h3 class="stit mt30">아이디찾기</h3>

		<table class="ftbl" style="width:980px">
				<colgroup>
					<col style="width:20%" />
					<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>아이디</th>
						<td><% if FindRecod then %><%=username%>님은 <%=formatdatetime(regdate,2)%>&nbsp;<%=formatdatetime(regdate,4)%>에 아이디 <strong><%=userid%></strong>(으)로 가입하셨습니다.<%else%><font color="cc0000"><strong>죄송합니다!</strong></font><br />입력한 정보로 일치하는 회원정보를 찾지 못했습니다.<br />가입할 때 입력한 <font color="cc0000">회원정보</font>가 정확한지 확인해주시기 바랍니다!<%end if%></td>
					</tr>
				</tbody>
			</table>

        <div class="cbtn"> <a href="login.asp" class="mbtn grey">로그인</a><a href="cmsid.asp" class="mbtn">아이디/비밀번호찾기</a> </div>
</div>

<!-- #include file = "../include/bottom.asp" -->
<% else %>
<!-- #include file = "../include/false_pg.asp" -->
<% end if %>
