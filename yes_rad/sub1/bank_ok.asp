<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,rs,idx,bankname,banknumber,use_name

bankname=trim(request("bankname"))
banknumber=trim(request("banknumber"))
use_name=trim(request("use_name"))

bankname = TextChk(bankname)
banknumber = TextChk(banknumber)
use_name =TextChk(use_name)

	sql = "insert into bank (bankname,banknumber,use_name)values"
	sql = sql & "('" & bankname & "'"
	sql = sql & ",'" & banknumber & "'"
	sql = sql & ",'" & use_name & "'"
	sql = sql & ")"
	db.execute(sql)

	Function TextChk(strClmn)
		TextChk = Replace(strClmn,"'","''")
		TextChk = Replace(strClmn,"<","&lt;")
		TextChk = Replace(strClmn,">","&gt;")
	End Function

	Response.Redirect "bank_list.asp"
%>
<!-- #include file = "../authpg_2.asp" -->