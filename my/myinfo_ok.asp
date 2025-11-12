<!-- #include file = "../include/set_loginfo.asp" -->
<!-- #include file = "../include/dbcon.asp" -->
<!-- #include file="../include/md5.asp"-->
<% if isUsr then

	Dim codzip,idx
	codzip = split(Request.Form("codzip"),"-")

	Dim pwd,tel1,tel2,email,zipcode1,zipcode2,juso1,juso2,b_year,b_month,b_day,b_type,sms_res,email_res
	idx = Request.Form("idx")
	pwd = Request.Form("pwd1")
	tel1 = Request.Form("tel1") & "-" & Request.Form("tel2") & "-" & Request.Form("tel3")
	tel2 = Request.Form("hp1") & "-" & Request.Form("hp2") & "-" & Request.Form("hp3")
	zipcode1 = Request.Form("zipcode1")
	zipcode2 = Request.Form("zipcode2")
	email = Request.Form("email")
	juso1 = Request.Form("juso1")
	juso2 = Request.Form("juso2")
	b_year = Request.Form("b_year")
	b_month = Request.Form("b_month")
	b_day = Request.Form("b_day")
	b_type = Request.Form("b_type")
	sms_res = Request.Form("sms_res")
	email_res = Request.Form("email_res")

	pwd = Tag2Txt(pwd)
	tel1 = Tag2Txt(tel1)
	tel2 = Tag2Txt(tel2)
	email = Tag2Txt(email)
	zipcode1 = Tag2Txt(zipcode1)
	zipcode2 = Tag2Txt(zipcode2)
	juso1 = Tag2Txt(juso1)
	juso2 = Tag2Txt(juso2)
	b_year = Tag2Txt(b_year)
	b_month = Tag2Txt(b_month)
	b_day = Tag2Txt(b_day)
	b_type = Tag2Txt(b_type)
	sms_res = Tag2Txt(sms_res)
	email_res = Tag2Txt(email_res)

	if sms_res = "" then
		sms_res = 0
	end If

	if email_res = "" then
		email_res = 0
	end If

	if b_type = "" then
		b_type = 1
	end If
	
	If Len(pwd) > 0 Then

		pwd = md5(pwd)

		sql = "update member set pwd = '"& pwd &"' where idx=" & idx
		db.execute(sql)
	
	End if

	sql = "update member set "
	sql = sql & "tel1='" & tel1 & "'"
	sql = sql & ",tel2='" & tel2 & "'"
	sql = sql & ",email='" & email & "'"
	sql = sql & ",b_year='" & b_year & "'"
	sql = sql & ",b_month='" & b_month & "'"
	sql = sql & ",b_day='" & b_day & "'"
	sql = sql & ",b_type=" & b_type
	sql = sql & ",sms_res=" & sms_res
	sql = sql & ",email_res=" & email_res
	sql = sql & ",zipcode1='" & zipcode1 & "'"
	sql = sql & ",juso1='" & juso1 & "'"
	sql = sql & ",juso2='" & juso2 & "'"
	sql = sql & " where idx=" & idx
	db.execute(sql)
	db.close
	set db = nothing

	response.redirect  "05_myinfo.asp"

	Function Tag2Txt(s)
		s = Replace(s,"'","''")
		s = Replace(s,"<","&lt;")
		s = Replace(s,">","&gt;")
		s = Replace(s,"&","&amp;")
		Tag2Txt = s
	End Function

Else %>
<!-- #include file = "../include/false_pg.asp" -->
<% End IF %>