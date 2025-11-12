<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,idx,idx_check,sid,ThisDate

sid = request("sid")
ThisDate = request("ThisDate")

for each idx in request.form("idx")
idx_check = split(idx,".")

   sql = "delete from cal_content where idx =" & idx_check(0) 
   db.execute(sql),,adexecutenorecords   

next

response.redirect "view.asp?sid="& sid &"&ThisDate="& ThisDate
Response.End
%>
<!-- #include file = "../authpg_2.asp" -->