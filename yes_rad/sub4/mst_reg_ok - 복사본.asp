<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim abc
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True

Dim perioArry,imgDot,DirectoryPath
DirectoryPath = Server.MapPath("..\..\") & "\ahdma\studimg\"

Dim strnm,intprice,intgigan,sajin,recom,strheader,lecnum,gbn,icon,sub_title,mem_group,teacher,state

state = abc.item("state")
teacher = abc.item("teacher")
strnm = abc.item("strnm")
intprice = abc.item("intprice")
intgigan = abc.item("intgigan")
sajin = "noimg.gif"
recom = abc.item("recom")
strheader = abc.item("strheader")
lecnum = abc.item("projectLectures").Count
gbn = abc.item("gbn")
sub_title = abc.item("sub_title")
mem_group = Trim(abc.item("mem_group"))
mem_group = ", "& mem_group &","

icon = abc.item("icon")
if len(icon) > 0 then
	icon = ", "& icon &","
end If

strnm = Tag2Txt(strnm)
sub_title = Tag2Txt(sub_title)
intprice = Tag2Txt(intprice)
intgigan = Tag2Txt(intgigan)
recom = Tag2Txt(recom)
strheader = replace(strheader,"'","''")
gbn = Tag2Txt(gbn)

intprice = replace(intprice,",","")

if recom = "" then
	recom = 0
end if

Dim idxnum,ordnum
Dim sql,dr
sql = "select isNull(Max(idx),0) + 1 from lectMast"
set dr = db.execute(sql)
idxnum = dr(0)
dr.close
set dr = nothing

sql = "select isNull(Max(ordn),0) + 1 from Lectmast where gbn=" & gbn
set dr = db.execute(sql)
ordnum = dr(0)
dr.close

''타이틀 이미지

Dim objSajin
Set objSajin = abc("sajin")(1)
if objSajin.FileExists then
	if objSajin.Length < 1024 * 1024 * 10  then	''800KB 이상 제한
		perioArry = Split(objSajin.SafeFileName,".")
		imgDot = perioArry(Ubound(perioArry))	''확장자추출
		if LCase(imgDot) = "gif" or LCase(imgDot) = "jpg" or Lcase(imgDot) = "png" then	''파일 허용
			sajin = "study_" & svdatefomt & "." & imgDot
			objSajin.Save DirectoryPath & sajin
		end if
	end if
end if
Set objSajin = Nothing

sql = "insert into LectMast (idx,strnm,intprice,intgigan,strheader,icon,gbn,sajin,recom,sub_title,mem_group,teacher,state,ordn) values ("
sql = sql & idxnum & ",'"
sql = sql & strnm & "',"
sql = sql & intprice & ","
sql = sql & intgigan & ",'"
sql = sql & strheader & "','"
sql = sql & icon & "',"
sql = sql & gbn & ",'"
sql = sql & sajin & "',"
sql = sql & recom & ",'"
sql = sql & sub_title & "','"
sql = sql & mem_group & "','"& teacher &"',"& state &","
sql = sql & ordnum
sql =  sql & ")"
db.execute(sql)


''LectAry table INsert
if int(lecnum) > 0  then
	for ii = 1 to lecnum
		sql = "insert into LectAry (mastidx,lectidx,ordn) values (" & idxnum & "," & abc.item("projectLectures")(ii) & "," & ii & ")"
		db.execute(sql)
	Next
end if

db.close
set db = nothing

response.redirect "mst_list.asp"
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