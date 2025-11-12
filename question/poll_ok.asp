<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<% if isUsr Then

dim rs,idx
dim reply,munje_total,user_dap
dim j,i

idx = request("idx")

sql = "select count(idx) from question_mast where ca = "& idx
Set rs = db.execute(sql)

munje_total = rs(0)
rs.close

dim a()
redim a(munje_total)

for i=0 to int(munje_total)-1
a(i) =  "reply"& i+1 &""
next

j=1
		user_dap = ""

		for i = 0 to int(munje_total)-1
		
		user_dap = ""& user_dap &""& i+1 &".("&request(a(i))&") "

		sql = "insert into question_result_detail (id,p_idx,q_idx,q_result)values"
		sql = sql & "('" & str_User_ID & "'"
		sql = sql & "," & idx
		sql = sql & "," & i+1
		sql = sql & ",'" & PadSingleQuote(request(a(i))) & "'"
		sql = sql & ")"
		db.execute sql,,adexecutenorecords

		j=j+1
		Next
		

	sql = "insert into question_result (id,p_idx,result)values"
	sql = sql & "('" & str_User_ID & "'"
	sql = sql & "," & idx
	sql = sql & ",'" & PadSingleQuote(user_dap) & "'"
	sql = sql & ")"
	db.execute sql,,adexecutenorecords
	
	response.write"<script>"
	response.write"alert('설문에 참여해주셔서 감사합니다.');"
	response.write"self.location.href='ing.asp';"
	response.write"</script>"
	response.end

Function PadSingleQuote(str)
	PadSingleQuote = replace(str, "'", "''")
End Function
%><%else %><!-- #include file = "../include/false_pg.asp" --><% end if%>