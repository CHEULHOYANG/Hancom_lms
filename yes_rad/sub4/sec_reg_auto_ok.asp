<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim q_idx,title,content,order_num,gu,dap,r1,r2,r3,r4,r5,haesul,jimun
dim sql,rs,nan,jumsu,code,mname,dap1,i
Dim DirectoryPath,abc,c_idx,ref,re_level,lidx,number
Dim idx,intpg,strPart,gbnS,strSearch,varPage,dr,ordnum

DirectoryPath = Server.MapPath("..\..\") & "\ahdma\pds\"
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True

idx = abc.item("idx")
intpg = abc.item("intpg")
strPart = abc.item("strPart")
gbnS = abc.item("gbnS")
strSearch = abc.item("strSearch")

varPage = "idx=" & idx & "&intpg=" & intpg & "&gbnS=" & gbnS & "&strPart=" & strPart & "&strSearch=" & strSearch

Dim filen : filen = 1024 * 1024 * 20
Dim objSajin,imgDot,perioArry,img_imsi
Dim image1,image2,image3,image4
Dim video1,video2,video3,video4,video5

Set objSajin = abc("file")(1)
if objSajin.FileExists then
 if objSajin.Length < filen  then ''이미지 800KB, 자료 5MB
  img_imsi = objSajin.SafeFileName
  perioArry = Split(img_imsi,".")
  imgDot = perioArry(Ubound(perioArry)) ''확장자추출

  if LCase(imgDot) = "xls" then ''파일 허용
   image4 = "ax_" & svdatefomt & "." & imgDot
   objSajin.Save DirectoryPath & image4
  end if

 end if
end if

dim XlsConn
Dim add0,add1,add2,add3,add7,add8,add4,add6,add5,add9,mckey

Set XlsConn = Server.CreateObject("ADODB.Connection")  
XlsConn.Open "PROVIDER=MICROSOFT.JET.OLEDB.4.0;DATA SOURCE=" & DirectoryPath & image4 &";Mode=ReadWrite|Share Deny None; Extended Properties='Excel 8.0; HDR=YES;';Persist Security Info=False"  

sql = "SELECT * FROM [Sheet1$]"
set rs=XlsConn.execute(sql)

if rs.eof or rs.bof then
else
	i=1
	do until rs.eof

		sql = "select isNull(Max(ordnum),0) + 1 from sectionTab where l_idx=" & idx
		set dr = db.execute(sql)
		ordnum = dr(0)
		dr.close
		set dr = Nothing

		add0 = rs(0)
		add1 = rs(1)
		add2 = rs(2)
		add3 = rs(3)
		add7 = rs(8)
		add8 = rs(9)
		add4 = rs(4)
		add6 = rs(7)
		add5 = rs(5)
		add9 = rs(6)
		video1 = rs(10)
		video2 = rs(11)
		video3 = rs(12)
		video4 = rs(13)
		video5 = rs(14)
		mckey = rs(15)

		If Len(add0) > 0 Then add0 = Replace(add0,"'","''")
		If Len(add1) > 0 Then add1 = Replace(add1,"'","''")
		If Len(add2) > 0 Then add2 = Replace(add2,"'","''")
		If Len(add3) > 0 Then add3 = Replace(add3,"'","''")
		If Len(add7) > 0 Then add7 = Replace(add7,"'","''")
		If Len(add8) > 0 Then add8 = Replace(add8,"'","''")
		If Len(add4) > 0 Then add4 = Replace(add4,"'","''")
		If Len(add6) > 0 Then add6 = Replace(add6,"'","''")
		If Len(add5) > 0 Then add5 = Replace(add5,"'","''")
		If Len(add9) > 0 Then add9 = Replace(add9,"'","''")

If Len(add0) > 0 then

		sql = "insert into sectionTab (strnm,ordnum,strtime,movlink,flshlink,lecsum,sumpath,lecsrc,srcpath,movlink1,movlink2,freelink,freelink1,l_idx,video1,video2,video3,video4,video5,mckey) values ('"
		sql = sql & add0 & "',"
		sql = sql & ordnum & ",'"
		sql = sql & add1 & "','"
		sql = sql & add2 & "','"
		sql = sql & add3 & "','"
		sql = sql & add7 & "','','"
		sql = sql & add8 & "','','"
		sql = sql & add4 & "','"
		sql = sql & add6 & "','"
		sql = sql & add5 & "','"
		sql = sql & add9 & "',"
		sql = sql & idx
		sql = sql & ",'"&  video1 &"','"&  video2 &"','"&  video3 &"','"&  video4 &"','"&  video5 &"','"&  mckey &"')"
		db.execute(sql)

		i=i+1

End if
		
	rs.movenext	
	loop
	rs.close
end if

			Response.write "<script>"
			Response.write "alert('"& i &"개 강좌가 등록되었습니다.');"
			Response.write "self.location.href='sec_list.asp?" & varPage &"';"
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

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function
%> 
<!-- #include file = "../authpg_2.asp" -->