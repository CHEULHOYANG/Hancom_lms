<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx,intpg
Dim gbnS,varPage,strPart,strSearch
Dim sql,dr,i,j,mckey

mckey = request.form("mckey")
i = request.form("i")
idx = request.form("idx")
intpg = request.form("intpg")
gbnS = request.form("gbnS")
strPart = request.form("strPart")
strSearch = request.form("strSearch")
varPage = "idx=" & idx & "&intpg=" & intpg & "&gbnS=" & gbnS & "&strPart=" & strPart & "&strSearch=" & strSearch

Dim strnm,ordnum,strtime,movlink,flshlink,lecsum,sumpath,lecsrc,srcpath,l_idx,time1,time2,movlink1,movlink2,freelink,view_count,view_time,freelink1
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
lecsum = request.form("lecsum")
lecsrc = request.form("lecsrc")
l_idx = idx

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

sql = "select isNull(Max(ordnum),0) + 1 from sectionTab where l_idx=" & idx
set dr = db.execute(sql)
ordnum = dr(0)
dr.close
set dr = nothing

strnm = Tag2Txt(strnm)
strtime = Tag2Txt(strtime)
movlink = Tag2Txt(movlink)
flshlink  = Tag2Txt(flshlink)
lecsum = Tag2Txt(lecsum)
lecsrc = Tag2Txt(lecsrc)

sql = "insert into sectionTab (strnm,ordnum,strtime,movlink,flshlink,lecsum,sumpath,lecsrc,srcpath,movlink1,movlink2,freelink,freelink1,view_count,view_time,l_idx,video1,video2,video3,video4,video5,mckey) values ('"
sql = sql & strnm & "',"
sql = sql & ordnum & ",'"
sql = sql & strtime & "','"
sql = sql & movlink & "','"
sql = sql & flshlink & "','"
sql = sql & lecsum & "','"
sql = sql & sumpath & "','"
sql = sql & lecsrc & "','"
sql = sql & srcpath & "','"
sql = sql & movlink1 & "','"
sql = sql & movlink2 & "','"
sql = sql & freelink & "','"
sql = sql & freelink1 & "',"
sql = sql & view_count & ","
sql = sql & view_time & ","
sql = sql & l_idx
sql = sql & ",'"&  video1 &"','"&  video2 &"','"&  video3 &"','"&  video4 &"','"&  video5 &"','"&  mckey &"')"
''response.write sql

for j = 1 To i
db.execute(sql)
next

sql = "update LecturTab set totalnum = totalnum + "& i &" where idx=" & idx
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