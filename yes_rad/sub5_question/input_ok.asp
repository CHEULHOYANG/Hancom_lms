<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,rs
Dim idx,title,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r_gu,ordnum,ca

title = request("title")
r1 = request("r1")
r2 = request("r2")
r3 = request("r3")
r4 = request("r4")
r5 = request("r5")
r6 = request("r6")
r7 = request("r7")
r8 = request("r8")
r9 = request("r9")
r10 = request("r10")
r_gu = request("r_gu")
ordnum = request("ordnum")
ca = request("ca")

title = Tag2Txt(title)
r1 = Tag2Txt(r1)
r2 = Tag2Txt(r2)
r3 = Tag2Txt(r3)
r4 = Tag2Txt(r4)
r5 = Tag2Txt(r5)
r6 = Tag2Txt(r6)
r7 = Tag2Txt(r7)
r8 = Tag2Txt(r8)
r9 = Tag2Txt(r9)
r10 = Tag2Txt(r10)
r_gu = Tag2Txt(r_gu)
ordnum = Tag2Txt(ordnum)

sql = "insert into question_mast (title,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r_gu,ordnum,ca)values"
sql = sql & "('" & title & "'"
sql = sql & ",'" & r1 & "'"
sql = sql & ",'" & r2 & "'"
sql = sql & ",'" & r3 & "'"
sql = sql & ",'" & r4 & "'"
sql = sql & ",'" & r5 & "'"
sql = sql & ",'" & r6 & "'"
sql = sql & ",'" & r7 & "'"
sql = sql & ",'" & r8 & "'"
sql = sql & ",'" & r9 & "'"
sql = sql & ",'" & r10 & "'"
sql = sql & "," & r_gu
sql = sql & "," & ordnum
sql = sql & "," & ca
sql = sql & ")"
db.execute sql,,adexecutenorecords

Response.write "<script>"
Response.write "alert('등록되었습니다');"
Response.write "self.location.href='input.asp';"
Response.write "</script>"
response.end

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function
%> 
<!-- #include file = "../authpg_2.asp" -->