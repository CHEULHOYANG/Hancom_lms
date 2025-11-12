<!--METADATA TYPE="typelib" NAME="ADODB Type Library" File="c:\program files\common files\system\ado\msado15.dll"-->
<%
Option Explicit
Response.Buffer=true
Response.CacheControl = "no-cache"
Response.AddHeader "pragma","no-cache"
Response.Expires = -1

Session.Codepage = 949
Response.CharSet = "EUC-KR"

%>
<!-- #include file="../include/injection.asp" -->
<%
Dim str_Cookies_Ary
Dim str_User_ID
Dim str_User_Nm

Dim isUsr			''회원
Dim strProg : strProg = "true"		''client login blean

if Replace(Request.Cookies("userInfo")," ","") = "" then		''로그인 정보가 없으면...

	isUsr = False

else		''로그인 정보가 있으면...

	str_Cookies_Ary = Split(Request.Cookies("userInfo"),",")

	if UBOund(str_Cookies_Ary) = 3 then	'' |로 split 길이는 3이어야 한다 -- 쿠키 변조 방지

		str_User_ID =  replace(str_Cookies_Ary(0),chr(13),"")
		str_User_Nm = replace(str_Cookies_Ary(1),chr(13),"")

		''회원구분
		isUsr = True
		strProg = "false"

	else

		isUsr = False

	end if

end if	''로그인 정보 끝

Dim str__Page,str__Var
if Not request.ServerVariables("QUERY_STRING") = "" then
	str__Var = "?" & request.ServerVariables("QUERY_STRING")
end if

''//-----------------td 나열 변수

	Dim tdnum,lineL,strNum,splitNum,lineNum,rowsNum

''//-----------------sql query용 변수

Dim sql,dr,ii,isRecod,isRows,isCols
%>
<!--#include file="../include/siteinfo.asp" -->