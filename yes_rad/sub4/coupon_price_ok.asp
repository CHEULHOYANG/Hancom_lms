<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim q_idx,title,content,order_num,gu,dap,r1,r2,r3,r4,r5,haesul,jimun
dim sql,rs,nan,jumsu,code,mname,dap1,i
Dim DirectoryPath,abc,c_idx,ref,re_level,lidx,number,end_date

DirectoryPath = Server.MapPath("..\..\") & "\ahdma\pds\"
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True

lidx = abc.item("lidx")
title = abc.item("title")
title = replace(title,"'","")
end_date = abc.item("end_date")

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
   image4 = "x_" & svdatefomt & "." & imgDot
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
	i=1
	do until rs.eof

	sql = "insert into coupon_price_mast (cnumber,price,end_date)values"
	sql = sql & "('" & rs(0) &"'"
	sql = sql & "," & rs(1)
	sql = sql & ",'" & end_date &"'"
	sql = sql & ")"
	db.execute sql,,adexecutenorecords
		
	rs.movenext
	i=i+1
	loop
	rs.close
end if

			Response.write "<script>"
			Response.write "alert('할인쿠폰 "& i &"장이 등록되었습니다.');"
			Response.write "self.location.href='coupon_price_list.asp';"
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