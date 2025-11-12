<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<!-- #include file = "../../include/md5.asp" -->
<%
dim id,pwd,name,juminno1,juminno2,tel1,tel2,email,zipcode1,zipcode2,juso1,juso2,mileage,b_year,b_month,b_day,b_type,sms_res,email_res
dim sql,rs
Dim DirectoryPath,abc,rs1,j,k
Dim sp1,sp2

DirectoryPath = Server.MapPath("..\..\") & "\ahdma\pds\"
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True

sp1 = abc.item("sp1")
sp2 = abc.item("sp2")

Dim filen : filen = 1024 * 1024 * 20
Dim objSajin,imgDot,perioArry,img_imsi
Dim image1,image2,image3,image4

Set objSajin = abc("file")(1)
if objSajin.FileExists then
 if objSajin.Length < filen  then ''이미지 800KB, 자료 5MB
  img_imsi = objSajin.SafeFileName
  perioArry = Split(img_imsi,".")
  imgDot = perioArry(Ubound(perioArry)) ''확장자추출

  if LCase(imgDot) = "xls" then ''파일 허용
   image4 = "ma_" & svdatefomt & "." & imgDot
   objSajin.Save DirectoryPath & image4
  end if

 end if
end if

dim XlsConn

Set XlsConn = Server.CreateObject("ADODB.Connection")  
XlsConn.Open "PROVIDER=MICROSOFT.JET.OLEDB.4.0;DATA SOURCE=" & DirectoryPath & image4 &";Mode=ReadWrite|Share Deny None; Extended Properties='Excel 8.0; HDR=YES;';Persist Security Info=False"  

sql = "SELECT * FROM [Sheet1$]"
set rs=XlsConn.execute(sql)

if rs.eof or rs.bof then
else
	k = 1
	j = 0
	do until rs.eof

	id = trim(rs(0))
	pwd = trim(rs(1))
	if len(pwd) > 0 then	pwd = md5(pwd)
	name = rs(2)
	juminno1 = rs(3)
	tel2 = rs(4)
	If Len(tel2) = 0 Then
		tel2 = "--"
	End if

	sms_res = rs(5)
	email = rs(6)
	email_res = rs(7)
	
	juminno2 = ""
	zipcode1 = ""
	zipcode2 = ""
	juso1 = ""
	juso2 = ""
	mileage = 0

	b_year = ""
	b_month = ""
	b_day = ""
	b_type = 0
	tel1 = "--"

if len(id) > 0 then

	sql = "select count(idx) from member where upper(id)='"& ucase(id) &"'"
	Set rs1=db.execute(sql)

	If rs1(0) = 0 then

		sql = "insert into member (id,pwd,name,juminno1,juminno2,tel1,tel2,email,zipcode1,zipcode2,juso1,juso2,mileage,b_year,b_month,b_day,b_type,sms_res,email_res,sp1,sp2)values"
		sql = sql & "('" & id &"'"
		sql = sql & ",'" & pwd &"'"
		sql = sql & ",'" & name &"'"
		sql = sql & ",'" & juminno1 &"'"
		sql = sql & ",'" & juminno2 &"'"
		sql = sql & ",'" & tel1 &"'"
		sql = sql & ",'" & tel2 &"'"
		sql = sql & ",'" & email &"'"
		sql = sql & ",'" & zipcode1 &"'"
		sql = sql & ",'" & zipcode2 &"'"
		sql = sql & ",'" & juso1 &"'"
		sql = sql & ",'" & juso2 &"'"
		sql = sql & "," & mileage
		sql = sql & ",'" & b_year &"'"
		sql = sql & ",'" & b_month &"'"
		sql = sql & ",'" & b_day &"'"
		sql = sql & "," & b_type
		sql = sql & "," & sms_res
		sql = sql & "," & email_res
		sql = sql & "," & sp1
		sql = sql & "," & sp2
		sql = sql & ")"		
		db.execute sql,,adexecutenorecords
	
		k=k+1
	Else

		j = j+1

	rs1.close
	End if

end if
		
	rs.movenext	
	loop
	rs.close
end if

			Response.write "<script>"
			Response.write "alert('회원 "& k &"명(중복"& j &"명제외)이 등록되었습니다.');"
			Response.write "self.location.href='member_input.asp';"
			Response.write "</script>"
			Response.End


Function svdatefomt()
	Dim dt1,dt2,dt3
	dt1 = replace(Date,"-","")
	dt2 = FormatDateTime(now(),4)
	dt3 = second(now)
	dt1 = Right(dt1,8)
	dt2 = replace(dt2,":","")

	if dt3 < 10 then
		dt3 = "0" & dt3
	end if
svdatefomt = dt1 & dt2 & dt3
End Function			
%> 
<!-- #include file = "../authpg_2.asp" -->