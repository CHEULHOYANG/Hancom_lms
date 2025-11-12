<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim sql,idx,idx_check,page
Dim search_go,sdate,edate,strPart,strSearch

page = request("page")
search_go = request("search_go")
sdate = request("sdate")
edate = request("edate")
strPart = request("strPart")
strSearch = request("strSearch")

for each idx in request.form("idx")
idx_check = split(idx,".")

   sql = "delete from mileage where idx =" & idx_check(0) 
   db.execute(sql),,adexecutenorecords

next

response.redirect "mileage.asp?search_go="& search_go &"&sdate="& sdate &"&edate="& edate &"&strPart="& strPart &"&strSearch="& strSearch &"&page="& page
response.end 
%>
<!-- #include file = "../authpg_2.asp" -->