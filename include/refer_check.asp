<%
''리퍼체크 -- 조소창에 직업 URL 치고 들어오는 경우 처리
Dim vReferer,vPage
vReferer = request.ServerVariables("HTTP_REFERER")
vPage = "http://" & request.ServerVariables("HTTP_HOST") & ""
'vPage = "http://" & request.ServerVariables("HTTP_HOST") & "/pstudy"
%>