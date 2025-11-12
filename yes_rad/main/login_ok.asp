<!--METADATA TYPE="typelib" NAME="ADODB Type Library" File="c:\program files\common files\system\ado\msado15.dll"-->
<%
Option Explicit

Response.Buffer=true
Response.Expires=0
Response.ExpiresAbsolute=Now()-1
Response.AddHeader"Pragma","no-cache"
Response.AddHeader"Cache-Control","private"
Response.CacheControl="no-cache"

Dim strID,strPwd
strID = Replace(Request("strID"),"'","''")
strPwd = Replace(Request("strPwd"),"'","''")
%>
<!-- #include file = "../../include/dbcon.asp" -->
<!-- #include file = "../../include/injection.asp" -->
<%
Dim Dr
Dim intProg

Set Dr = db.execute("dbo.sp_Login_Admin '" & strID & "','" & strPwd & "'")
intProg = int(Dr(0))
Dim go2page

if intProg > 0 then
	go2page = "login.asp"
else
	Response.Cookies("strInfo") = intProg
	Response.Cookies("adminid") = strID
	go2page = "main.asp"
end if

Dr.Close
Set Dr = Nothing

db.Close
Set db = Nothing

Response.redirect go2page
Response.End
%>