<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

Dim idx,intpg,idxnn
Dim gbnS,varPage
Dim sql,dr,mckey

mckey = request.form("mckey")
idx = request.form("idx")
intpg = request.form("intpg")
idxnn = request.form("idxnn")
gbnS = request.form("gbnS")
varPage = "idx=" & idx & "&intpg=" & intpg & "&gbnS=" & gbnS

Dim lecsum,lecsrc
lecsum = request.form("lecsum")
lecsrc = request.form("lecsrc")

Dim strnm,ordnum,strtime,movlink,flshlink,l_idx,time1,time2,freegbn,movlink1,movlink2,freelink,view_count,view_time,freelink1
Dim video1,video2,video3,video4,video5

video1 = request.form("video1")
video2 = request.form("video2")
video3 = request.form("video3")
video4 = request.form("video4")
video5 = request.form("video5")

strnm = request.form("strnm")
time1 = request.form("time1")
time2 = request.form("time2")
movlink = request.form("movlink")
flshlink = request.form("flshlink")
freegbn = request.form("freegbn")

movlink1 = request.form("movlink1")
movlink2 = request.form("movlink2")

view_count = request.form("view_count")
view_time = request.form("view_time")

If Len(view_count) = 0 Then view_count = 0
If Len(view_time) = 0 Then view_time = 0

freelink = request.form("freelink")
freelink = replace(freelink,"'","")

freelink1 = request.form("freelink1")
freelink1 = replace(freelink1,"'","")

movlink1 = Tag2Txt(movlink1)
movlink2 = Tag2Txt(movlink2)

if time1 = "" then
	time1 = "00"
end if

if time2 = "" then
	time2 = "00"
end if

strtime = time1 & ":" & time2

strnm = Tag2Txt(strnm)
strtime = Tag2Txt(strtime)
movlink = Tag2Txt(movlink)
flshlink  = Tag2Txt(flshlink)
freegbn = Tag2Txt(freegbn)
lecsrc = Tag2Txt(lecsrc)
lecsum = Tag2Txt(lecsum)

sql = "update sectionTab set "
sql = sql & "strnm='" & strnm & "',"
sql = sql & "strtime='" & strtime & "',"
sql = sql & "movlink='" & movlink & "',"
sql = sql & "flshlink='" & flshlink & "',"
sql = sql & "movlink1='" & movlink1 & "',"
sql = sql & "movlink2='" & movlink2 & "',"
sql = sql & "freelink='" & freelink & "',"
sql = sql & "freelink1='" & freelink1 & "',"
sql = sql & "lecsum='" & lecsum & "',"
sql = sql & "lecsrc='" & lecsrc & "',"
sql = sql & "view_count='" & view_count & "',"
sql = sql & "view_time='" & view_time & "',"
sql = sql & "video1='" & video1 & "',"
sql = sql & "video2='" & video2 & "',"
sql = sql & "video3='" & video3 & "',"
sql = sql & "video4='" & video4 & "',"
sql = sql & "video5='" & video5 & "',"
sql = sql & "mckey='" & mckey & "',"
sql = sql & "freegbn=" & freegbn
sql = sql & " where idx=" & idxnn

response.write sql
db.execute(sql)

db.close
set db = nothing

response.redirect "sec_list.asp?" & varPage
Response.end

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function
%>
<!-- #include file = "../authpg_2.asp" -->