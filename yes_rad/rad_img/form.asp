<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>사이트정보관리</h2>
	</div>
</div>


<span class="stip"></span>

<div class="caution"><p></p></div>


<a href="list_excel.asp?page=<%=page%>" class="sbtn">엑셀로저장하기</a>

class="btns trans"
class="btns"

<% if isRecod Then%>
		<div class="cbtn mb80">
<%
blockPage = int((intpg-1)/10) * 10 + 1
%>
			<div class="paging">
			<% if blockPage > 1 Then %>
				<a href="javascript:go2ListPage('1');"><img src="/yes_rad/rad_img/img/a_prev2.gif" alt="처음페이지"></a>
				<a href="javascript:go2ListPage('<%=int(blockPage-1)%>');"><img src="/yes_rad/rad_img/img/a_prev1.gif" alt="이전페이지" /></a>
			<%End if%>
			<% ii = 1
									Do Until ii > 10 or blockPage > pagecount
									if blockPage = int(intpg) then %>
				<strong><%=blockPage%></strong><% else %>
				<a href="javascript:go2ListPage('<%=blockPage%>');" class="num"><%=blockPage%></a>
				<% end if
									blockPage = blockPage + 1
									ii = ii + 1
									Loop %>
			<% if blockPage > pagecount then 
			else
			%>
				<a href="javascript:go2ListPage('<%=blockPage%>');"><img src="/yes_rad/rad_img/img/a_next1.gif" alt="다음페이지"></a>
				<a href="javascript:go2ListPage('<%=pagecount%>');"><img src="/yes_rad/rad_img/img/a_next2.gif" alt="마지막페이지"></a>
			<%End if%>
			</div>
		</div>
<%End if%>

		<div class="cbtn mb80">
			<div class="paging">
				<a href="?page=1&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>"><img src="/yes_rad/rad_img/img/a_prev2.gif" alt="처음페이지"></a>
<%
blockPage=Int((page-1)/10)*10+1
if blockPage = 1 Then
Else
%>
<a href="?page=<%=blockPage-10%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>"><img src="/yes_rad/rad_img/img/a_prev1.gif" alt="이전페이지" /></a>
<%
End If
   i=1
   Do Until i > 10 or blockPage > pagecount
      If blockPage=int(page) Then
%>
<strong><%=blockPage%></strong>
<%Else%>
<a href="?page=<%=blockPage%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>" class="num"><%=blockPage%></a>
<%
End If    
blockPage=blockPage+1
i = i + 1
Loop

if blockPage > pagecount Then
Else
%>
<a href="?page=<%=blockPage%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>"><img src="/yes_rad/rad_img/img/a_next1.gif" alt="다음페이지"></a>
<%
End If
%>	
				<a href="?page=<%=pagecount%>&searchstr=<%=request("searchstr")%>&searchpart=<%=request("searchpart")%>"><img src="/yes_rad/rad_img/img/a_next2.gif" alt="마지막페이지"></a>			
			</div>
		</div>