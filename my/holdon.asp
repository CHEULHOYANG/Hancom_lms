<!-- #include file = "../include/set_loginfo.asp" -->
<!-- #include file = "../include/dbcon.asp" -->
<% if isUsr then
Dim idx : idx = Request("idx")

Dim userid,buygbn,tabidx,huil,eday

sql = "select id,buygbn,tabidx,holdil,eday from order_mast where idx=" & idx
set dr = db.execute(sql)

userid = dr(0)
buygbn = dr(1)
tabidx = dr(2)
huil = dr(3)
eday = dr(4)

dr.close

''로그인 정보 확인

if userid = str_User_ID Then

	Dim neday,tempd

	tempd = Cstr(DateAdd("d",huil,eday))
	neday = FormatDateTime(tempd,2) & " " & FormatDateTime(tempd,4) & ":00"

	sql = "update order_mast set eday=Convert(smalldatetime,'" & neday & "'),holdgbn=1,holdsday=getdate(),holdeday=DateAdd(day," & huil & ",getdate()) where idx=" & idx

	db.execute(sql)
	db.close
	set db = nothing
	
	Response.redirect "01_main.asp"
	Response.end

else %><!-- #include file = "../include/false_pg.asp" --><% end if
else %><!-- #include file = "../include/false_pg.asp" -->
<% end if %>
