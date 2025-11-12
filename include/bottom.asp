<div class="footer">
    <div class="notice">
        <dl>
            <dt>공지사항</dt>
<%
Dim kkkkk,acet

sql = "select top 5 idx,jemok,wday from notice order by idx desc"
set dr = db.execute(sql)
if not dr.bof or not dr.eof Then
kkkkk = 1
do until dr.eof %>
            <dd id="main_e<%=kkkkk%>" style="display:<%If kkkkk > 1 Then response.write"none" End if%>;"><a href="/cs/nneyong.asp?idx=<%=dr(0)%>"><%=dr(1)%></a></dd>
<% dr.movenext
kkkkk = kkkkk + 1
Loop
dr.close
end if
%>
        </dl>
    </div>

<script>
function vbview(flag){
<%for acet = 1 to kkkkk-1 %>
	main_e<%=acet%>.style.display = "none";
<%next%>

	switch (flag)
	{
<%for acet = 1 to kkkkk-1%>
		case <%=acet%>: main_e<%=acet%>.style.display = ""; break;
<%next%>
	}
} 

function vchbanner(ii){

<%for acet = 1 to kkkkk-1%>
	if (ii==<%=acet%>)	{
	vbview(<%=acet%>);
	<%If acet = kkkkk-1 then%>
	setTimeout("vchbanner(<%=1%>);",5000);
	<%else%>
	setTimeout("vchbanner(<%=acet+1%>);",5000);
	<%end if%>
	}
<%next%>
	
}
<%if kkkkk-1 > 1 then%>
vchbanner(1);
<%end if%>
</script>

    <div  class="fme"> <% sql = "select idx,jemok from guideTab where gbn = 0 order by ordnum asc,idx desc"
set dr = db.execute(sql)
if not dr.bof or not dr.eof then
do until dr.eof %><a href="../cs/page.asp?idx=<%=dr(0)%>"><%=dr(1)%></a><span class="slash">|</span><% dr.movenext
Loop
end if
dr.close %><a href="/cs/nlist.asp"><%=t_menu7%></a> </div>
    <div class="fcopy"> 사업자등록번호 : <%=c_number%><span class="slash">|</span>통신판매업신고번호 : <%=c_comnumber%><span class="slash">|</span>개인정보책임자 : <%=c_chage%><br />
        대표이사 : <%=c_ceo%><span class="slash">|</span>주소 : <%=c_juso%><span class="slash">|</span>Tel : <%=help_tel%><span class="slash">|</span>업체명 : <%=c_name%>
        <p><em class="fb">Copyright <%=s_name%> All rights reserved.</em> <em>E-mail : <%=a_email%></em></p>
    </div>
</div>
</body>
</html><%
Function BannerOutput(xbn_name,xbn_url,xbn_file,ban_width,target)

	dim xbn_Value

	if xbn_file = "swf" then
		xbn_Value = "<object classid=""clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"" codebase=""http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0"" WIDTH=""" & ban_width & """>"
			xbn_Value = xbn_Value & "<param name=""movie"" value=""../ahdma/banner/" & xbn_name & """>"
			xbn_Value = xbn_Value & "<param name=""quality"" value=""high"">"
			xbn_Value = xbn_Value & "<param name=""wmode"" value=""transparent"">"
			xbn_Value = xbn_Value & "</object>"
	else
		if xbn_url = "" then
			xbn_Value = xbn_Value & "<a><img src=""/ahdma/banner/" & xbn_name & """ width=""" & ban_width & """ border=""0""></a>"
		else
			xbn_Value = xbn_Value & "<a href=""" & xbn_url & """ target="""& target &"""><img src=""/ahdma/banner/" & xbn_name & """ width=""" & ban_width & """ border=""0""></a>"
		end if
	end if

	BannerOutput = xbn_Value

End Function

Function BannerOutput1(xbn_name,xbn_url,xbn_file,ban_width,target)

	dim xbn_Value

	if xbn_file = "swf" then
		xbn_Value = "<object classid=""clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"" codebase=""http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0"" WIDTH=""" & ban_width & """>"
			xbn_Value = xbn_Value & "<param name=""movie"" value=""../ahdma/banner/" & xbn_name & """>"
			xbn_Value = xbn_Value & "<param name=""quality"" value=""high"">"
			xbn_Value = xbn_Value & "<param name=""wmode"" value=""transparent"">"
			xbn_Value = xbn_Value & "</object>"
	else
		if xbn_url = "" then
			xbn_Value = xbn_Value & "<a class=""bleft""><img src=""/ahdma/banner/" & xbn_name & """ width=""" & ban_width & """ border=""0""></a>"
		else
			xbn_Value = xbn_Value & "<a href=""" & xbn_url & """ target="""& target &""" class=""bleft""><img src=""/ahdma/banner/" & xbn_name & """ width=""" & ban_width & """ border=""0""></a>"
		end if
	end if

	BannerOutput1 = xbn_Value

End Function

Function BannerOutput2(xbn_name,xbn_url,xbn_file,ban_width,target)

	dim xbn_Value

	if xbn_file = "swf" then
		xbn_Value = "<object classid=""clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"" codebase=""http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0"" WIDTH=""" & ban_width & """>"
			xbn_Value = xbn_Value & "<param name=""movie"" value=""../ahdma/banner/" & xbn_name & """>"
			xbn_Value = xbn_Value & "<param name=""quality"" value=""high"">"
			xbn_Value = xbn_Value & "<param name=""wmode"" value=""transparent"">"
			xbn_Value = xbn_Value & "</object>"
	else
		if xbn_url = "" then
			xbn_Value = xbn_Value & "<a class=""bright""><img src=""/ahdma/banner/" & xbn_name & """ width=""" & ban_width & """ border=""0""></a>"
		else
			xbn_Value = xbn_Value & "<a href=""" & xbn_url & """ target="""& target &""" class=""bright""><img src=""/ahdma/banner/" & xbn_name & """ width=""" & ban_width & """ border=""0""></a>"
		end if
	end if

	BannerOutput2 = xbn_Value

End Function
%>
<%If Len(sns_kakao) > 0 then%>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
      Kakao.init('<%=sns_kakao%>');
      
      // 카카오 로그인 버튼을 생성합니다.
  function createKakaotalkLogin(){
      Kakao.Auth.login({
		persistAccessToken: true,
		persistRefreshToken: true,
        success: function(authObj) {
          
          // 로그인 성공시 API를 호출합니다.
          Kakao.API.request({
          url: '/v2/user/me',
          success: function(res) {
            var sData = JSON.stringify(res);
            //alert(sData);
            
            sData = JSON.parse(sData);
            var route = "kakao"
            var id = sData.id+"@"+route;
            var nickname = sData.properties.nickname;
            var thumbnail_image = sData.properties.thumbnail_image;
            var profile_image = sData.properties.profile_image;
            
            //alert(id);
            //alert(nickname);
            //document.write(id);
            //document.writeln("<br><br><br>");
            //document.write(nickname+"님(카카오톡 닉네임) 반갑습니다. ^^");
            //document.writeln("<br><br><br>");
            //document.writeln("썸네일 이미지 <br> <img src='"+thumbnail_image+"'>");
            //document.writeln("<br>");
            //document.writeln("프로필 이미지 <br> <img src='"+profile_image+"'>");
            //document.writeln("<br>");
            var f = document.createElement("form");
            f.setAttribute("method","post");
            f.setAttribute("action","");
            f.setAttribute("target","_self");
            document.body.appendChild(f);
            var i_id=document.createElement("input");
            i_id.setAttribute("type","hidden");
            i_id.setAttribute("name","kakao_id");
            i_id.setAttribute("value",id);
            f.appendChild(i_id);
            var i_nick=document.createElement("input");
            i_nick.setAttribute("type","hidden");
            i_nick.setAttribute("name","kakao_nick");
            i_nick.setAttribute("value",nickname);
            f.appendChild(i_nick);
            var i_thum=document.createElement("input");
            i_thum.setAttribute("type","hidden");
            i_thum.setAttribute("name","kakao_thumbnail_image");
            i_thum.setAttribute("value",thumbnail_image);
            f.appendChild(i_thum);
            var i_profile=document.createElement("input");
            i_profile.setAttribute("type","hidden");
            i_profile.setAttribute("name","kakao_profile_image");
            i_profile.setAttribute("value",profile_image);
            f.appendChild(i_profile);
            var i_accessToken=document.createElement("input");
            i_accessToken.setAttribute("type","hidden");
            i_accessToken.setAttribute("name","accessToken");
            i_accessToken.setAttribute("value",accessToken);
            f.appendChild(i_accessToken);
            var i_refreshToken=document.createElement("input");
            i_refreshToken.setAttribute("type","hidden");
            i_refreshToken.setAttribute("name","refreshToken");
            i_refreshToken.setAttribute("value",refreshToken);
            f.appendChild(i_refreshToken);
            f.submit();
          }
          });
      var accessToken = Kakao.Auth.getAccessToken();
      var refreshToken = Kakao.Auth.getRefreshToken();
   
          //document.writeln("액세스 토큰 : "+accessToken);
          //document.writeln("<br>");
          //document.writeln("리프레시 토큰 : "+refreshToken);
          //document.writeln("<br>");
          
        }
      });
}
	  function ktout(){
	  Kakao.Auth.logout(function (){
		setTimeout(function(){
			location.href="?";
			},1000);
			});
	}
    </script>
<%If Len(request.Form("kakao_id")) > 0 And Len(request.cookies("userInfo")) = 0 then%>
<form name="formaa" method="post" action="/sns_kakao/kakao_ok.asp">
<input type="hidden" name="kakao_id" value="<%=request.Form("kakao_id")%>">
<input type="hidden" name="kakao_nick" value="<%=request.form("kakao_nick")%>">
<input type="hidden" name="kakao_thumbnail_image" value="<%=request.form("kakao_thumbnail_image")%>">
<input type="hidden" name="kakao_profile_image" value="<%=request.form("kakao_profile_image")%>">
<input type="hidden" name="accessToken" value="<%=request.form("accessToken")%>">
<input type="hidden" name="refreshToken" value="<%=request.form("refreshToken")%>">
</form>
<script>
document.formaa.submit();
</script>
<%End if%>
<%End if%>