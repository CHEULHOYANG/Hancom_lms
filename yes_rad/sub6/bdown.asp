<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim sql,rs,idx,b_id,rs1,now_order,use_gu
dim change_idx,change_order_num,gbn

idx = request("idx")

sql="select ordnum,ygbn from board_mast where idx='"& idx &"'"
set rs1=db.execute(sql)
	
if rs1.eof or rs1.bof then
	now_order = 1
else
	now_order = rs1(0)
	gbn = rs1(1)
rs1.close
end if

If gbn = 1 then
	sql = "select idx,ordnum from board_mast where ordnum > '"& now_order &"' and ygbn = 1 order by ordnum desc"
Else
	sql = "select idx,ordnum from board_mast where ordnum > '"& now_order &"' and (ygbn = 2 or ygbn = 3) order by ordnum desc"
End if
set rs=db.execute(sql)

if rs.eof or rs.bof then
else
	change_idx = 0
	change_order_num = 0
do until rs.eof
	change_idx = rs(0)
	change_order_num = rs(1)
rs.movenext
loop
rs.close
end if

sql = "update board_mast set ordnum = '"& change_order_num &"' where idx= '"& idx &"'"
db.execute sql,,adexecutenorecords

sql = "update board_mast set ordnum = '"& now_order &"' where idx= '"& change_idx &"'"
db.execute sql,,adexecutenorecords


response.write"<script language='javascript'>"
response.write"self.location.href='blist.asp';"
response.write"</script>"
response.end
%>
<!-- #include file = "../authpg_2.asp" -->