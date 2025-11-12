<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idxnum,sql,Dr,pop_height
Dim pop_nm,pop_neyong,pop_cookie

idxnum = Request("idxnum")
pop_height = Request("pop_height")

sql = "select pop_nm,pop_neyong,pop_cookie from PopInfoTab where pop_idx=" & idxnum
Set Dr = db.execute(sql)

If dr.eof Or dr.bof Then

	response.write"<script>"
	response.write"alert('데이터에러!!');"
	response.write"history.back();"
	response.write"</script>"
	response.end

Else

	pop_nm = Dr(0)
	pop_neyong = Dr(1)
	pop_cookie = int(Dr(2))

Dr.Close
End if

Dim intHeight,isLoadCookie
if pop_cookie > 0 then
	isLoadCookie = True
	intHeight = int(pop_height) - 30
else
	isLoadCookie = False
	intHeight = int(pop_height)
end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<head>
<title><%=pop_nm%></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="/img/default.css" type="text/css">
</HEAD>
<BODY>
<%=pop_neyong%>
<% if isLoadCookie then %>
<br />오늘은 이 창을 다시 열지 않음 <input type="checkbox"><% end if %>
</BODY>
</HTML>
<!-- #include file = "../authpg_2.asp" -->