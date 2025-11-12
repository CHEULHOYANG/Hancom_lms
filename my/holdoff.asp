<!-- #include file = "../include/set_loginfo.asp" -->
<!-- #include file = "../include/dbcon.asp" --><% if isUsr then
Dim idx : idx = Request("idx")
Dim userid,buygbn,tabidx,diffn,eday,holdil

sql = "select id,buygbn,tabidx,eday,DateDiff(day,holdsday,getdate()),holdil from order_mast where idx=" & idx
set dr = db.execute(sql)

userid = dr(0)
buygbn = dr(1)
tabidx = dr(2)
eday = dr(3)
diffn = dr(4)
holdil = dr(5)

dr.close

''로그인 정보 확인

if userid = str_User_ID then

	Dim neday,tempd

	tempd = Cstr(DateAdd("d",-(holdil-diffn),eday))
	neday = FormatDateTime(tempd,2) & " " & FormatDateTime(tempd,4) & ":00"

	'Response.write "1 : "& tempd &"<br />"
	'Response.write "2 : "& neday &""

	sql = "update order_mast set eday=Convert(smalldatetime,'" & neday & "'),holdsday=getDate(),holdeday=getDate(),holdgbn=0,holdil=holdil-" & diffn & " where idx=" & idx
	db.execute(sql)

	db.close
	set db = Nothing
	
	Response.redirect "01_main.asp"
	Response.end

else %><!-- #include file = "../include/false_pg.asp" --><% end if
else %><!-- #include file = "../include/false_pg.asp" -->
<% end if %>