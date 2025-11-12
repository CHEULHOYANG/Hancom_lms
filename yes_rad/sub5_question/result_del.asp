<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,rs,idx,searchpart,searchstr,page

page = request("page")
idx = request("idx")
searchstr = request("searchstr")
searchpart = request("searchpart")

sql = " delete from question_result where idx = " & idx
db.execute sql,,adexecutenorecords

response.redirect"result.asp?page="& page &"&searchpart="& request("searchpart") &"&searchstr="& request("searchstr") &""
Response.End
%>
<!-- #include file = "../authpg_2.asp" -->