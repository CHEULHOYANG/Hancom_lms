<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim abc
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True

Dim perioArry,imgDot,DirectoryPath
DirectoryPath = Server.MapPath("..\..\") & "\ahdma\studimg\"

Dim idx,intpg,varPage
Dim gbnS,strPart,strSearch

idx = abc.item("idx")
intpg = abc.item("intpg")
gbnS = abc.item("gbnS")
strPart = abc.item("strPart")
strSearch = abc.item("strSearch")
ordn = abc.item("ordn")
varPage = "idx=" & idx & "&intpg=" & intpg & "&gbnS=" & gbnS & "&strSearch=" & strSearch & "&strPart=" & strPart

Dim strnm,intprice,intgigan,sajin,recom,strheader,lecnum,dbsajin,gbn,ordn,icon,sub_title,mem_group,teacher,state

state = abc.item("state")
teacher = abc.item("teacher")
strnm = abc.item("strnm")
intprice = abc.item("intprice")
intgigan = abc.item("intgigan")
dbsajin = abc.item("dbsajin")
recom = abc.item("recom")
strheader = abc.item("strheader")
gbn = abc.item("gbn")
sub_title = abc.item("sub_title")
mem_group = Trim(abc.item("mem_group"))
mem_group = ", "& mem_group &","

lecnum = abc.item("projectLectures").Count

icon = abc.item("icon")
if len(icon) > 0 then
	icon = ", "& icon &","
end If

sub_title = Tag2Txt(sub_title)
strnm = Tag2Txt(strnm)
intprice = Tag2Txt(intprice)
intgigan = Tag2Txt(intgigan)
dbsajin = Tag2Txt(dbsajin)
recom = Tag2Txt(recom)
gbn = Tag2Txt(gbn)
strheader = replace(strheader,"'","''")

intprice = replace(intprice,",","")

if recom = "" then
	recom = 0
end if


''타이틀 이미지
sajin = dbsajin
Dim objSajin
Set objSajin = abc("sajin")(1)
if objSajin.FileExists then
	if objSajin.Length < 1024 * 1024 * 10  then	''800KB 이상 제한
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

			sajin = "study_" & svdatefomt & "." & imgDot
			objSajin.Save DirectoryPath & sajin
		end if
	end if
end if
Set objSajin = Nothing

dim sql
sql = "update Lectmast set "
sql = sql & "strnm='" &  strnm & "',"
sql = sql & "intprice=" & intprice & ","
sql = sql & "intgigan=" & intgigan & ","
sql = sql & "strheader='" & strheader & "',"
sql = sql & "sub_title='" & sub_title & "',"
sql = sql & "icon='" & icon & "',"
sql = sql & "sajin='" & sajin & "',"
sql = sql & "recom=" & recom & ","
sql = sql & "mem_group='" & mem_group & "',"
sql = sql & "teacher='" & teacher &"',"
sql = sql & "gbn=" & gbn &","
sql = sql & "state=" & state &","
sql = sql & "ordn=" & ordn
sql =  sql & " where idx=" & idx
db.execute(sql)


''LectAry table 처리
db.execute("delete LectAry where mastidx=" & idx)

''TempAry table 처리
db.execute("delete TempAry")

if int(lecnum) > 0  then
	for ii = 1 to lecnum
		sql = "insert into LectAry (mastidx,lectidx,ordn) values (" & idx & "," & abc.item("projectLectures")(ii) & "," & ii & ")"
		db.execute(sql)
	Next
end if

db.close
set db = nothing

response.redirect "mst_list.asp?" & varPage
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