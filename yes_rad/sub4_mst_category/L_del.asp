<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim sql,rs,idx,sub_count

idx=request("idx")

sql = " delete from mscate where idx = " & idx
db.execute sql,,adexecutenorecords

response.write"<script language='javascript'>"
response.write"self.location.href='list.asp';"
response.write"</script>"
response.end
%>
<!-- #include file = "../authpg_2.asp" -->