<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim sql,rs,idx,b_id,rs1,now_order,use_gu
dim change_idx,change_ordnum,location

idx = request("idx")

sql="select ordnum from dan_category where idx='"& idx &"'"
set rs1=db.execute(sql)

if rs1.eof or rs1.bof then
	now_order = 1
else
	now_order = rs1(0)
rs1.close
end if

sql = "select idx,ordnum from dan_category where ordnum < '"& now_order &"' order by ordnum asc"
set rs=db.execute(sql)

if rs.eof or rs.bof then
else
	change_idx = 0
	change_ordnum = 0
do until rs.eof
	change_idx = rs(0)
	change_ordnum = rs(1)
rs.movenext
loop
rs.close
end if

sql = "update dan_category set ordnum = '"& now_order &"' where idx= '"& change_idx &"'"
db.execute sql,,adexecutenorecords

sql = "update dan_category set ordnum = '"& change_ordnum &"' where idx= '"& idx &"'"
db.execute sql,,adexecutenorecords

response.write"<script language='javascript'>"
response.write"self.location.href='list.asp';"
response.write"</script>"
response.end
%>
<!-- #include file = "../authpg_2.asp" -->