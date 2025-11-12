<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim abc,sql
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True
Dim perioArry,imgDot,DirectoryPath
DirectoryPath = Server.MapPath("..\..\") & "\ahdma\studimg\"

Dim strnm,strteach,tinfo,intprice,intgigan,categbn,sajin,icon,teach_id,book_idx,group_idx,sub_title,mem_group,ordn,step_check,state
Dim ca1,ca2,inginum

ca1 = abc.item("ca1")
ca2 = abc.item("ca2")
state = abc.item("state")

If Len(ca2) = 0 Then ca2 = 0

step_check = abc.item("step_check")
strnm = abc.item("strnm")
strteach = abc.item("strteach")
tinfo = abc.item("tinfo")
intprice = abc.item("intprice")
intgigan = abc.item("intgigan")
categbn = 0
ordn = abc.item("ordn")
teach_id = abc.item("teach_id")
book_idx = abc.item("book_idx")
group_idx = abc.item("group_idx")
sub_title = abc.item("sub_title")
mem_group = Trim(abc.item("mem_group"))
mem_group = ", "& mem_group &","

If Len(teach_id) = 0 Then teach_id = ""
If Len(book_idx) = 0 Then book_idx = ""
If Len(group_idx) = 0 Then group_idx = 0

sajin = "noimg.gif"

icon = abc.item("icon")
if len(icon) > 0 then
	icon = ", "& icon &","
end If

inginum = abc("inginum")(1)
if inginum = "" then
	inginum = 0
end if	

sub_title = Tag2Txt(sub_title)
strnm = Tag2Txt(strnm)
strteach = Tag2Txt(strteach)
tinfo = replace(tinfo,"'","''")
intprice = Tag2Txt(intprice)
intgigan = Tag2Txt(intgigan)

intprice = Replace(intprice,",","")

Dim objSajin
Set objSajin = abc("sajin")(1)
if objSajin.FileExists then
	if objSajin.Length < 1024 * 1024 * 5  then	''800KB 이상 제한
		perioArry = Split(objSajin.SafeFileName,".")
		imgDot = perioArry(Ubound(perioArry))	''확장자추출
		if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or Lcase(imgDot) = "png" then	''파일 허용
			sajin = "dan_" & svdatefomt & "." & imgDot
			objSajin.Save DirectoryPath & sajin
		end if
	end if
end if
Set objSajin = Nothing


sql = "insert into LecturTab (strnm,strteach,tinfo,icon,intprice,intgigan,categbn,teach_id,book_idx,group_idx,sub_title,mem_group,ordn,step_check,ca1,ca2,inginum,state,sajin) values ('"
sql = sql & strnm & "','"
sql = sql & strteach & "','"
sql = sql & tinfo & "','"
sql = sql & icon & "',"
sql = sql & intprice & ","
sql = sql & intgigan & ","
sql = sql & categbn & ",'"
sql = sql & teach_id & "','"
sql = sql & book_idx & "',"
sql = sql & group_idx & ",'"& sub_title &"','"& mem_group &"',"& ordn &","& step_check &","& ca1 &","& ca2 &","& inginum &","& state &",'"
sql = sql & sajin & "'"
sql = sql & ")"
db.execute(sql)

db.close
set db = nothing

response.redirect "dan_list.asp"
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