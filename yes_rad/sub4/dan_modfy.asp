<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim abc
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True
Dim perioArry,imgDot,DirectoryPath
DirectoryPath = Server.MapPath("..\..\") & "\ahdma\studimg\"

Dim idx,intpg
Dim gbnS,varPage,strPart,strSearch,icon
Dim sql,dr,rs
Dim sca1,sca2

sca1 = abc.item("sca1")
sca2 = abc.item("sca2")

idx = abc.item("idx")
intpg = abc.item("intpg")
gbnS = abc.item("gbnS")
strPart = abc.item("strPart")
strSearch = abc.item("strSearch")

varPage = "ca1="& sca1 &"&ca2="& sca2 &"&idx=" & idx & "&intpg=" & intpg & "&gbnS=" & gbnS & "&strPart=" & strPart & "&strSearch=" & strSearch

Dim strnm,strteach,tinfo,intprice,intgigan,categbn,sajin,inginum,teach_id,book_idx,group_idx,sub_title,check_del,mem_group,ordn,step_check,state
Dim o_ordn

sql = "select ordn from LecturTab where idx = "& idx
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
	
	response.write"<script>"
	response.write"alert('데이터에러!!');"
	response.write"self.location.href='dan_list.asp';"
	response.write"</script>"
	response.End
	
Else
	o_ordn = rs(0)
rs.close
End if

ordn = abc.item("ordn")
If Len(ordn) = 0 Then ordn = 0

Dim ca1,ca2

ca1 = abc.item("ca1")
ca2 = abc.item("ca2")
If Len(ca2) = 0 Then ca2 = 0

state = abc.item("state")

step_check = abc.item("step_check")
check_del = abc.item("check_del")
strnm = abc.item("strnm")
strteach = abc.item("strteach")
tinfo = abc.item("tinfo")
intprice = abc.item("intprice")
intgigan = abc.item("intgigan")
categbn = 0
sajin = abc.item("strSajin")
inginum = abc("inginum")(1)
sub_title = abc.item("sub_title")
mem_group = Trim(abc.item("mem_group"))
mem_group = ", "& mem_group &","

icon = abc.item("icon")
if len(icon) > 0 then
	icon = ", "& icon &","
end If

if inginum = "" then
	inginum = 0
end if	


teach_id = abc.item("teach_id")
book_idx = abc.item("book_idx")
group_idx = abc.item("group_idx")

If Len(teach_id) = 0 Then teach_id = ""
If Len(book_idx) = 0 Then book_idx = ""
If Len(group_idx) = 0 Then group_idx = 0

sub_title = Tag2Txt(sub_title)
strnm = Tag2Txt(strnm)
strteach = Tag2Txt(strteach)
tinfo = replace(tinfo,"'","''")
intprice = Tag2Txt(intprice)
intgigan = Tag2Txt(intgigan)
categbn = Tag2Txt(categbn)

intprice = Replace(intprice,",","")

Dim objSajin
Set objSajin = abc("sajin")(1)
if objSajin.FileExists then
	if objSajin.Length < 1024 * 1024 * 5  then	''800KB 이상 제한
		perioArry = Split(objSajin.SafeFileName,".")
		imgDot = perioArry(Ubound(perioArry))	''확장자추출
		if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or Lcase(imgDot) = "png" then	''파일 허용

			''기존이미지 삭제
			if Not sajin = "noimg.gif" then
				Dim objFso,strFile
				set objFso = server.CreateObject("scripting.filesystemobject")
				strFile = DirectoryPath & sajin
				if objFso.FileExists(strFile) then
					objFso.DeleteFile(strFile)
				end if
				set objFso = nothing
			end if

			sajin = "dan_" & svdatefomt & "." & imgDot
			objSajin.Save DirectoryPath & sajin
		end if
	end if
end if
Set objSajin = Nothing

If ordn <> o_ordn then

	sql = "update LecturTab set ordn = ordn + 1 where ordn >= "& ordn
	db.execute(sql)

End if

sql = "update LecturTab set "
sql = sql & "strnm='" & strnm & "',"
sql = sql & "strteach='" & strteach & "',"
sql = sql & "tinfo='" & tinfo & "',"
sql = sql & "icon='" & icon & "',"
sql = sql & "intprice=" & intprice & ","
sql = sql & "intgigan=" & intgigan & ","
sql = sql & "categbn=" & categbn & ","
sql = sql & "teach_id='" & teach_id & "',"
sql = sql & "sub_title='" & sub_title & "',"
sql = sql & "book_idx='" & book_idx & "',"
sql = sql & "group_idx=" & group_idx & ","
sql = sql & "inginum=" & inginum & ","
sql = sql & "ca1=" & ca1 & ","
sql = sql & "ca2=" & ca2 & ","
sql = sql & "state=" & state & ","
sql = sql & "sajin='" & sajin & "',"
sql = sql & "ordn=" & ordn & ","
sql = sql & "step_check=" & step_check & ","
sql = sql & "mem_group='" & mem_group & "'"
sql = sql & " where idx=" & idx
db.execute(sql)

If Len(check_del) > 0 Then

	sql = "update LecturTab set sajin='noimg.gif' where idx=" & idx
	db.execute(sql)

End if

response.redirect "dan_list.asp?" & varPage
Response.end

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function

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