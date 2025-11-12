<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,rs,idx,bankname,banknumber,use_name

idx = trim(request("idx"))
bankname = trim(request("bankname"))
banknumber = trim(request("banknumber"))
use_name = trim(request("use_name"))

idx = TextChk(idx)
bankname = TextChk(bankname)
banknumber = TextChk(banknumber)
use_name =TextChk(use_name)

sql = "update bank set bankname ='"& bankname & "'"
sql = sql & ",banknumber = '"& banknumber & "'"
sql = sql & ",use_name = '"& use_name & "'"
sql = sql & " where idx = '"& idx &"'"
db.execute sql,,adexecutenorecords

Function TextChk(strClmn)
	TextChk = Replace(strClmn,"'","''")
	TextChk = Replace(strClmn,"<","&lt;")
	TextChk = Replace(strClmn,">","&gt;")
End Function

Response.Redirect "bank_list.asp"
%>
<!-- #include file = "../authpg_2.asp" -->