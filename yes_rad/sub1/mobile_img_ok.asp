<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim sql,rs
dim b_type,b_width,b_height
dim b_img1,b_img2,b_img3,b_img4,b_img5,b_img6,b_img7,b_img8,b_img9,b_img10
dim b_link1,b_link2,b_link3,b_link4,b_link5,b_link6,b_link7,b_link8,b_link9,b_link10
dim b_title1,b_title2,b_title3,b_title4,b_title5,b_title6,b_title7,b_title8,b_title9,b_title10
dim b_content1,b_content2,b_content3,b_content4,b_content5,b_content6,b_content7,b_content8,b_content9,b_content10
dim check_del1,check_del2,check_del3,check_del4,check_del5,check_del6,check_del7,check_del8,check_del9,check_del10

Dim DirectoryPath,abc
DirectoryPath = Server.MapPath("..\..\") & "\ahdma\"
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True

check_del1 = abc("check_del1")(1)
check_del2 = abc("check_del2")(1)
check_del3 = abc("check_del3")(1)
check_del4 = abc("check_del4")(1)
check_del5 = abc("check_del5")(1)
check_del6 = abc("check_del6")(1)
check_del7 = abc("check_del7")(1)
check_del8 = abc("check_del8")(1)
check_del9 = abc("check_del9")(1)
check_del10 = abc("check_del10")(1)

	b_link1 = abc("b_link1")(1)
	b_link2 = abc("b_link2")(1)
	b_link3 = abc("b_link3")(1)
	b_link4 = abc("b_link4")(1)
	b_link5 = abc("b_link5")(1)
	b_link6 = abc("b_link6")(1)
	b_link7 = abc("b_link7")(1)
	b_link8 = abc("b_link8")(1)
	b_link9 = abc("b_link9")(1)
	b_link10 = abc("b_link10")(1)

	b_link1 = replace(b_link1,"'","")
	b_link2 = replace(b_link2,"'","")
	b_link3 = replace(b_link3,"'","")
	b_link4 = replace(b_link4,"'","")
	b_link5 = replace(b_link5,"'","")
	b_link6 = replace(b_link6,"'","")
	b_link7 = replace(b_link7,"'","")
	b_link8 = replace(b_link8,"'","")
	b_link9 = replace(b_link9,"'","")
	b_link10 = replace(b_link10,"'","")


	b_title1 = abc("b_title1")(1)
	b_title2 = abc("b_title2")(1)
	b_title3 = abc("b_title3")(1)
	b_title4 = abc("b_title4")(1)
	b_title5 = abc("b_title5")(1)	
	b_title6 = abc("b_title6")(1)
	b_title7 = abc("b_title7")(1)
	b_title8 = abc("b_title8")(1)
	b_title9 = abc("b_title9")(1)
	b_title10 = abc("b_title10")(1)	

	b_title1 = replace(b_title1,"'","")
	b_title2 = replace(b_title2,"'","")
	b_title3 = replace(b_title3,"'","")
	b_title4 = replace(b_title4,"'","")
	b_title5 = replace(b_title5,"'","")	
	b_title6 = replace(b_title6,"'","")
	b_title7 = replace(b_title7,"'","")
	b_title8 = replace(b_title8,"'","")
	b_title9 = replace(b_title9,"'","")
	b_title10 = replace(b_title10,"'","")


	Dim filen : filen = 1024 * 1024 * 5
	Dim objSajin,imgDot,perioArry,img_imsi
	Dim image1,image2,image3,image4,image5,image6,image7,image8,image9,image10
	
	Set objSajin = abc("file1")(1)
	if objSajin.FileExists then
	 if objSajin.Length < filen  then ''이미지 800KB, 자료 5MB
	  img_imsi = objSajin.SafeFileName
	  perioArry = Split(img_imsi,".")
	  imgDot = perioArry(Ubound(perioArry)) ''확장자추출
		  if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "png" then ''파일 허용
		   image1 = "b1_" & svdatefomt & "." & imgDot
		   objSajin.Save DirectoryPath & image1
		  end if
	 end if
	end if
	Set objSajin = abc("file2")(1)
	if objSajin.FileExists then
	 if objSajin.Length < filen  then ''이미지 800KB, 자료 5MB
	  img_imsi = objSajin.SafeFileName
	  perioArry = Split(img_imsi,".")
	  imgDot = perioArry(Ubound(perioArry)) ''확장자추출
		  if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "png" then ''파일 허용
		   image2 = "b2_" & svdatefomt & "." & imgDot
		   objSajin.Save DirectoryPath & image2
		  end if
	 end if
	end if
	Set objSajin = abc("file3")(1)
	if objSajin.FileExists then
	 if objSajin.Length < filen  then ''이미지 800KB, 자료 5MB
	  img_imsi = objSajin.SafeFileName
	  perioArry = Split(img_imsi,".")
	  imgDot = perioArry(Ubound(perioArry)) ''확장자추출
		  if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "png" then ''파일 허용
		   image3 = "b3_" & svdatefomt & "." & imgDot
		   objSajin.Save DirectoryPath & image3
		  end if
	 end if
	end if
	Set objSajin = abc("file4")(1)
	if objSajin.FileExists then
	 if objSajin.Length < filen  then ''이미지 800KB, 자료 5MB
	  img_imsi = objSajin.SafeFileName
	  perioArry = Split(img_imsi,".")
	  imgDot = perioArry(Ubound(perioArry)) ''확장자추출
		  if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "png" then ''파일 허용
		   image4 = "b4_" & svdatefomt & "." & imgDot
		   objSajin.Save DirectoryPath & image4
		  end if
	 end if
	end if
	Set objSajin = abc("file5")(1)
	if objSajin.FileExists then
	 if objSajin.Length < filen  then ''이미지 800KB, 자료 5MB
	  img_imsi = objSajin.SafeFileName
	  perioArry = Split(img_imsi,".")
	  imgDot = perioArry(Ubound(perioArry)) ''확장자추출
		  if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "png" then ''파일 허용
		   image5 = "b5_" & svdatefomt & "." & imgDot
		   objSajin.Save DirectoryPath & image5
		  end if
	 end if
	end if				
	Set objSajin = abc("file6")(1)
	if objSajin.FileExists then
	 if objSajin.Length < filen  then ''이미지 800KB, 자료 5MB
	  img_imsi = objSajin.SafeFileName
	  perioArry = Split(img_imsi,".")
	  imgDot = perioArry(Ubound(perioArry)) ''확장자추출
		  if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "png" then ''파일 허용
		   image6 = "b6_" & svdatefomt & "." & imgDot
		   objSajin.Save DirectoryPath & image6
		  end if
	 end if
	end if	
	Set objSajin = abc("file7")(1)
	if objSajin.FileExists then
	 if objSajin.Length < filen  then ''이미지 800KB, 자료 5MB
	  img_imsi = objSajin.SafeFileName
	  perioArry = Split(img_imsi,".")
	  imgDot = perioArry(Ubound(perioArry)) ''확장자추출
		  if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "png" then ''파일 허용
		   image7 = "b7_" & svdatefomt & "." & imgDot
		   objSajin.Save DirectoryPath & image7
		  end if
	 end if
	end if	
	Set objSajin = abc("file8")(1)
	if objSajin.FileExists then
	 if objSajin.Length < filen  then ''이미지 800KB, 자료 5MB
	  img_imsi = objSajin.SafeFileName
	  perioArry = Split(img_imsi,".")
	  imgDot = perioArry(Ubound(perioArry)) ''확장자추출
		  if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or LCase(imgDot) = "png" then ''파일 허용
		   image8 = "b8_" & svdatefomt & "." & imgDot
		   objSajin.Save DirectoryPath & image8
		  end if
	 end if
	end if	

sql = "select * from m_banner_mast"
set rs=db.execute(sql)

if rs.eof or rs.bof then

	sql = "insert into m_banner_mast (b_type,b_img1,b_img2,b_img3,b_img4,b_img5,b_img6,b_img7,b_img8,b_img9,b_img10,b_link1,b_link2,b_link3,b_link4,b_link5,b_link6,b_link7,b_link8,b_link9,b_link10,b_title1,b_title2,b_title3,b_title4,b_title5,b_title6,b_title7,b_title8,b_title9,b_title10,b_content1,b_content2,b_content3,b_content4,b_content5,b_content6,b_content7,b_content8,b_content9,b_content10)values"
	sql = sql & "('" & b_type & "'"	
	sql = sql & ",'" & image1 & "'"
	sql = sql & ",'" & image2 & "'"
	sql = sql & ",'" & image3 & "'"
	sql = sql & ",'" & image4 & "'"
	sql = sql & ",'" & image5 & "'"
	sql = sql & ",'" & image6 & "'"
	sql = sql & ",'" & image7 & "'"
	sql = sql & ",'" & image8 & "'"
	sql = sql & ",'" & image9 & "'"
	sql = sql & ",'" & image10 & "'"	
	sql = sql & ",'" & b_link1 &"'"
	sql = sql & ",'" & b_link2 &"'"
	sql = sql & ",'" & b_link3 &"'"
	sql = sql & ",'" & b_link4 &"'"
	sql = sql & ",'" & b_link5 &"'"
	sql = sql & ",'" & b_link6 &"'"
	sql = sql & ",'" & b_link7 &"'"
	sql = sql & ",'" & b_link8 &"'"
	sql = sql & ",'" & b_link9 &"'"
	sql = sql & ",'" & b_link10 &"'"	
	sql = sql & ",'" & b_title1 &"'"	
	sql = sql & ",'" & b_title2 &"'"	
	sql = sql & ",'" & b_title3 &"'"	
	sql = sql & ",'" & b_title4 &"'"	
	sql = sql & ",'" & b_title5 &"'"	
	sql = sql & ",'" & b_title6 &"'"	
	sql = sql & ",'" & b_title7 &"'"	
	sql = sql & ",'" & b_title8 &"'"	
	sql = sql & ",'" & b_title9 &"'"	
	sql = sql & ",'" & b_title10 &"'"		
	sql = sql & ",'" & b_content1 &"'"	
	sql = sql & ",'" & b_content2 &"'"	
	sql = sql & ",'" & b_content3 &"'"	
	sql = sql & ",'" & b_content4 &"'"	
	sql = sql & ",'" & b_content5 &"'"	
	sql = sql & ",'" & b_content6 &"'"	
	sql = sql & ",'" & b_content7 &"'"	
	sql = sql & ",'" & b_content8 &"'"	
	sql = sql & ",'" & b_content9 &"'"	
	sql = sql & ",'" & b_content10 &"'"	
	sql = sql & ")"
	db.execute sql,,adexecutenorecords
	
else
	
	if len(image1) > 0 then
		sql = "update m_banner_mast set b_img1='"& image1 &"'"
		db.execute sql,,adexecutenorecords		
	end if
	if len(image2) > 0 then
		sql = "update m_banner_mast set b_img2='"& image2 &"'"
		db.execute sql,,adexecutenorecords		
	end if
	if len(image3) > 0 then
		sql = "update m_banner_mast set b_img3='"& image3 &"'"
		db.execute sql,,adexecutenorecords		
	end if
	if len(image4) > 0 then
		sql = "update m_banner_mast set b_img4='"& image4 &"'"
		db.execute sql,,adexecutenorecords		
	end if
	if len(image5) > 0 then
		sql = "update m_banner_mast set b_img5='"& image5 &"'"
		db.execute sql,,adexecutenorecords		
	end if
	if len(image6) > 0 then
		sql = "update m_banner_mast set b_img6='"& image6 &"'"
		db.execute sql,,adexecutenorecords		
	end if
	if len(image7) > 0 then
		sql = "update m_banner_mast set b_img7='"& image7 &"'"
		db.execute sql,,adexecutenorecords		
	end if
	if len(image8) > 0 then
		sql = "update m_banner_mast set b_img8='"& image8 &"'"
		db.execute sql,,adexecutenorecords		
	end if
	if len(image9) > 0 then
		sql = "update m_banner_mast set b_img9='"& image9 &"'"
		db.execute sql,,adexecutenorecords		
	end if
	if len(image10) > 0 then
		sql = "update m_banner_mast set b_img10='"& image10 &"'"
		db.execute sql,,adexecutenorecords		
	end if								

	if Len(check_del1) > 0 then
		sql = "update m_banner_mast set b_img1=''"
		db.execute sql,,adexecutenorecords		
	end if
	if Len(check_del2) > 0 then
		sql = "update m_banner_mast set b_img2=''"
		db.execute sql,,adexecutenorecords		
	end if
	if Len(check_del3) > 0 then
		sql = "update m_banner_mast set b_img3=''"
		db.execute sql,,adexecutenorecords		
	end if
	if Len(check_del4) > 0 then
		sql = "update m_banner_mast set b_img4=''"
		db.execute sql,,adexecutenorecords		
	end if
	if Len(check_del5) > 0 then
		sql = "update m_banner_mast set b_img5=''"
		db.execute sql,,adexecutenorecords		
	end if
	if Len(check_del6) > 0 then
		sql = "update m_banner_mast set b_img6=''"
		db.execute sql,,adexecutenorecords		
	end if
	if Len(check_del7) > 0 then
		sql = "update m_banner_mast set b_img7=''"
		db.execute sql,,adexecutenorecords		
	end if
	if Len(check_del8) > 0 then
		sql = "update m_banner_mast set b_img8=''"
		db.execute sql,,adexecutenorecords		
	end if
	if Len(check_del9) > 0 then
		sql = "update m_banner_mast set b_img9=''"
		db.execute sql,,adexecutenorecords		
	end if
	if Len(check_del10) > 0 then
		sql = "update m_banner_mast set b_img10=''"
		db.execute sql,,adexecutenorecords		
	end if	

	
	sql = "update m_banner_mast set b_type='"& b_type &"',b_link1 = '"& b_link1 &"',b_link2 = '"& b_link2 &"' , b_link3 ='"& b_link3 & "',b_link4 = '"& b_link4 & "',b_link5 = '"& b_link5 & "',b_link6 = '"& b_link6 & "',b_link7 = '"& b_link7 & "',b_link8 = '"& b_link8 & "',b_link9 = '"& b_link9 & "',b_link10 = '"& b_link10 & "',b_title1 = '"& b_title1 &"',b_title2 = '"& b_title2 &"' , b_title3 ='"& b_title3 & "',b_title4 = '"& b_title4 & "',b_title5 = '"& b_title5 & "',b_title6 = '"& b_title6 & "',b_title7 = '"& b_title7 & "',b_title8 = '"& b_title8 & "',b_title9 = '"& b_title9 & "',b_title10 = '"& b_title10 & "',b_content1 = '"& b_content1 &"',b_content2 = '"& b_content2 &"' , b_content3 ='"& b_content3 & "',b_content4 = '"& b_content4 & "',b_content5 = '"& b_content5 & "',b_content6 = '"& b_content6 & "',b_content7 = '"& b_content7 & "',b_content8 = '"& b_content8 & "',b_content9 = '"& b_content9 & "',b_content10 = '"& b_content10 & "'"
	db.execute sql,,adexecutenorecords
	
end if

response.write"<script language='javascript'>"
response.write"alert('저장되었습니다.');"
response.write"self.location.href='mobile_img.asp';"
response.write"</script>"
response.End


Function svdatefomt()
		Dim dt1,dt2,dt3
		dt1 = FormatDateTime(now(),2)
		dt2 = FormatDateTime(now(),4)
		dt3 = second(now)
		dt1 = replace(dt1,"-","")
		dt2 = replace(dt2,":","")

		if dt3 < 10 then
			dt3 = "0" & dt3
		end if
svdatefomt = dt1 & dt2 & dt3
End Function
%>
<!-- #include file = "../authpg_2.asp" -->