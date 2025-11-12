<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim sql,idx,page

idx = request("idx")
page = request("page")

sql = "delete from cal_mast where idx = "& idx
db.execute(sql),,adexecutenorecords

Response.write "<script>"
Response.write "self.location.href='list.asp?page="& page &"';"
response.write "parent.left.location.href='../main/left.asp?menu_tree=5';"
Response.write "</script>"
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->