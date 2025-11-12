<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
	Dim idxnum
	idxnum = Request("idxnum")
	db.execute("delete admin_mast where idx=" & idxnum)
	db.close
	Set db = Nothing

	Response.Redirect "admin_list.asp"
	Response.End
	
%>
<!-- #include file = "../authpg_2.asp" -->