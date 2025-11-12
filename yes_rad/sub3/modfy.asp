<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<!-- #include file="../../include/md5.asp"-->
<%
dim idx,intpg,gbnS,strPart,strSearch,pwd,gm

gm = Request("gm")
idx = Request("idx")
intpg = Request("intpg")
gbnS = Request("gbnS")
strPart = Request("strPart")
strSearch = Request("strSearch")

Dim varPage
varPage = "gm="& gm &"&idx=" & idx & "&intpg=" & intpg & "&gbnS=" & gbnS & "&strPart=" & strPart & "&strSearch=" & strSearch

Dim codzip
codzip = split(Request.Form("codzip"),"-")

Dim tel1,tel2,email,zipcode1,zipcode2,juso1,juso2,birth,b_type,sms_res,email_res,mileage,state,sp1,sp2,sp3,memo,juminno1
Dim ip1,ip2,ip3,name

name = Request.Form("name")
juminno1 = Request.Form("juminno1")
tel1 = Request.Form("tel1") & "-" & Request.Form("tel2") & "-" & Request.Form("tel3")
tel2 = Request.Form("hp1") & "-" & Request.Form("hp2") & "-" & Request.Form("hp3")
email = Request.Form("email")
zipcode1 = Request.Form("zipcode1")
zipcode2 = Request.Form("zipcode2")
juso1 = Request.Form("juso1")
juso2 = Request.Form("juso2")
birth = Request.Form("birth")
b_type = Request.Form("b_type")
sms_res = Request.Form("sms_res")
email_res = Request.Form("email_res")
mileage = Request.Form("mileage")
state = Request.Form("state")
pwd = Request.Form("pwd")

sp1 = Request.Form("sp1")
sp2 = Request.Form("sp2")

ip1 = Request.Form("ip1")
ip2 = Request.Form("ip2")
ip3 = Request.Form("ip3")

memo = Request.Form("memo")

if mileage = "" then
	mileage = 0
end if

If Len(email_res) = 0 Then email_res = 1

tel1 = Tag2Txt(tel1)
tel2 = Tag2Txt(tel2)
email = Tag2Txt(email)
zipcode1 = Tag2Txt(zipcode1)
zipcode2 = Tag2Txt(zipcode2)
juso1 = Tag2Txt(juso1)
juso2 = Tag2Txt(juso2)
birth = Tag2Txt(birth)
b_type = Tag2Txt(b_type)
sms_res = Tag2Txt(sms_res)
email_res = Tag2Txt(email_res)
mileage = Tag2Txt(mileage)
state = Tag2Txt(state)
pwd = Tag2Txt(pwd)
memo = Tag2Txt(memo)

birth = split(birth,"-")

Dim sql,o_mileage,uid,rs

sql = "select mileage,id from member where idx=" & idx
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
	o_mileage = rs(0)
	uid = rs(1)
rs.close
End if
	
If Len(pwd) > 0 Then

	pwd = md5(pwd)

	sql = "update member set pwd = '"& pwd &"' where idx=" & idx
	db.execute(sql)

End if

sql = "update member set "
sql = sql & "tel1='" & tel1 & "'"
sql = sql & ",tel2='" & tel2 & "'"
sql = sql & ",email='" & email & "'"
sql = sql & ",memo='" & memo & "'"
sql = sql & ",zipcode1='" & zipcode1 & "'"
sql = sql & ",zipcode2='" & zipcode2  & "'"
sql = sql & ",juso1='" & juso1 & "'"
sql = sql & ",juso2='" & juso2 & "'"
sql = sql & ",sms_res=" & sms_res
sql = sql & ",email_res=" & email_res
sql = sql & ",mileage=" & mileage
sql = sql & ",state=" & state
sql = sql & ",sp1=" & sp1
sql = sql & ",sp2=" & sp2
sql = sql & ",ip1='" & ip1 & "'"
sql = sql & ",ip2='" & ip2 & "'"
sql = sql & ",ip3='" & ip3 & "'"
sql = sql & ",name='" & name & "'"
sql = sql & ",juminno1='" & juminno1 & "'"
sql = sql & " where idx=" & idx
db.execute(sql)

if int(mileage) > int(o_mileage) then

		sql = "insert into mileage (id,gu,price,g_title,otp)values"
		sql = sql & "('" & uid &"'"
		sql = sql & ",2,"& int(mileage-o_mileage)
		sql = sql & ",'운영자 "& int(mileage-o_mileage) &"포인트 적립'"
		sql = sql & ",''"
		sql = sql & ")"
		db.execute sql,,adexecutenorecords

elseif int(mileage) < int(o_mileage) then

		sql = "insert into mileage (id,gu,price,g_title,otp)values"
		sql = sql & "('" & uid &"'"
		sql = sql & ",1,"& int(o_mileage-mileage)
		sql = sql & ",'운영자 "& int(o_mileage-mileage) &"포인트 차감'"
		sql = sql & ",''"
		sql = sql & ")"
		db.execute sql,,adexecutenorecords

end if


db.close
set db = nothing

	Function Tag2Txt(s)
		s = Replace(s,"'","''")
		s = Replace(s,"<","&lt;")
		s = Replace(s,">","&gt;")
		s = Replace(s,"&","&amp;")
		Tag2Txt = s
	End Function

response.redirect "view.asp?" & varPage
Response.end
%>
<!-- #include file = "../authpg_2.asp" -->