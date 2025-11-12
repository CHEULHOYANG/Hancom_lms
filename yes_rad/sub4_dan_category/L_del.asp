<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim sql,rs,idx,sub_count

idx=request("idx")

sql = " delete from dan_category where idx = " & idx
db.execute sql,,adexecutenorecords

sql = " delete from dan_category where uidx = " & idx
db.execute sql,,adexecutenorecords

response.write"<script language='javascript'>"
''response.write"alert('분류리스트가 삭제되었습니다.');"
response.write"self.location.href='list.asp';"
response.write"</script>"
response.end
%>
<!-- #include file = "../authpg_2.asp" -->