<!-- #include file="../include/set_loginfo.asp" -->
<% if isUsr then
	response.redirect "../main/index.asp"
	response.end
end if %>
<!-- #include file = "../include/refer_check.asp" -->
<!-- #include file="../include/md5.asp"--><%
vPage = vPage & "/member/memberin.asp"

if vReferer = vPage then

	Dim id,pwd,name,juminno1,juminno2,tel1,tel2,email,zipcode1,zipcode2,juso1,juso2,b_year,b_month,b_day,b_type,sms_res,email_res,rs

	id = Trim(Request.Form("usrid"))
	pwd = Request.Form("pwd1")
	name = Request.Form("uname")
	juminno1 = Request.Form("juminno1")
	juminno2 = Request.Form("jumin2")
	tel1 = Request.Form("tel1") & "-" & Request.Form("tel2") & "-" & Request.Form("tel3")
	tel2 = Request.Form("hp1") & "-" & Request.Form("hp2") & "-" & Request.Form("hp3")
	email = Request.Form("email")
	zipcode1 = Request.Form("zipcode1")
	zipcode2 = Request.Form("zipcode2")
	juso1 = Request.Form("juso1")
	juso2 = Request.Form("juso2")
	b_year = Request.Form("b_year")
	b_month = Request.Form("b_month")
	b_day = Request.Form("b_day")
	b_type = Request.Form("b_type")
	sms_res = Request.Form("sms_res")
	email_res = Request.Form("email_res")

	id = Tag2Txt(id)
	pwd = Tag2Txt(pwd)
	name = Tag2Txt(name)
	juminno1 = Tag2Txt(juminno1)
	juminno2 = Tag2Txt(juminno2)
	tel1 = Tag2Txt(tel1)
	tel2 = Tag2Txt(tel2)
	email = Tag2Txt(email)
	zipcode1 = Tag2Txt(zipcode1)
	zipcode2 = Tag2Txt(zipcode2)
	juso1 = Tag2Txt(juso1)
	juso2 = Tag2Txt(juso2)
	b_year = 0
	b_month = 0
	b_day = 0
	b_type = 0
	sms_res = Tag2Txt(sms_res)
	email_res = Tag2Txt(email_res)

	if sms_res = "" then
		sms_res = 0
	end If

	if email_res = "" then
		email_res = 0
	end If

%><!-- #include file = "../include/dbcon.asp" --><%

	pwd = md5(pwd)

	sql = "insert into member (id,pwd,name,juminno1,juminno2,tel1,tel2,email,zipcode1,zipcode2,juso1,juso2,mileage,b_year,b_month,b_day,b_type,sms_res,email_res) values ('"
	sql = sql & id & "','"
	sql = sql & pwd & "','"
	sql = sql & name & "','"
	sql = sql & juminno1 & "','"
	sql = sql & juminno2 & "','"
	sql = sql & tel1 & "','"
	sql = sql & tel2 & "','"
	sql = sql & email & "','"
	sql = sql & zipcode1 & "','"
	sql = sql & zipcode2 & "','"
	sql = sql & juso1 & "','"
	sql = sql & juso2 & "',"
	sql = sql & mem_mileage & ",'"
	sql = sql & b_year & "','"
	sql = sql & b_month & "','"
	sql = sql & b_day & "',"
	sql = sql & b_type & ","
	sql = sql & sms_res & ","
	sql = sql & email_res & ")"
	db.execute(sql)

	If int(mem_mileage) > 0 then

		sql = "insert into mileage (id,gu,price,g_title,otp)values"
		sql = sql & "('" & id &"'"
		sql = sql & ",2,"& mem_mileage &""
		sql = sql & ",'회원가입 "& mem_mileage &"원 적립'"
		sql = sql & ",''"
		sql = sql & ")"
		db.execute sql,,adexecutenorecords

	End if

	db.close
	set db = Nothing

	response.write"<script>"
	response.write"alert('정상적으로 회원가입이 되었습니다.\n\n로그인을 하신후 서비스를 이용해주시기 바랍니다.');"
	response.write"self.location.href='login.asp?usrid="& id &"';"
	response.write"</script>"
	response.end

	Function Tag2Txt(s)
		s = Replace(s,"'","''")
		s = Replace(s,"<","&lt;")
		s = Replace(s,">","&gt;")
		s = Replace(s,"&","&amp;")
		Tag2Txt = s
	End Function

else %>
<!-- #include file = "../include/false_pg.asp" -->
<% end if %>