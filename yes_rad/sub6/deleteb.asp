<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim idx : idx = Request("idx")

db.execute("delete board_mast where idx=" & idx)
db.execute("delete board_board where tabnm=" & idx)
db.execute("delete replyTab where tabnm=" & idx)

response.redirect "blist.asp"
%>
<!-- #include file = "../authpg_2.asp" -->