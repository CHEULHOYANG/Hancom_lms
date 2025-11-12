<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,idx,idx_check,page

page=request("page")

for each idx in request.form("idx")
idx_check = split(idx,".")

   sql = "delete from cal_mast where sid = '" & idx_check(0) &"'"
   db.execute(sql),,adexecutenorecords   

   sql = "delete from cal_gu_mast where sid = '" & idx_check(0) &"'"
   db.execute(sql),,adexecutenorecords   
   
next

Response.write "<script>"
Response.write "self.location.href='list.asp?page="& page &"';"
Response.write "parent.left.location.href='../main/left.asp?menu_tree=5';"
Response.write "</script>"
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->