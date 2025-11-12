<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idxnum : idxnum = Request("idx")

db.execute("Delete PopInfoTab where pop_idx=" & idxnum)
db.close
Set db = Nothing

Response.Redirect "popup_list.asp" %>
<!-- #include file = "../authpg_2.asp" -->