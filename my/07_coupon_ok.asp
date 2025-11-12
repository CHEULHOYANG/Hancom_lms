<!-- #include file = "../include/set_loginfo.asp" -->
<% if isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
dim rs,cnum,rs1
dim idx,buygbn,categbn,tabidx,strsday,intgigan,paytype,paytime,payday,intprice

cnum = request.form("cnum")

sql = "select huday from site_info"
set dr = db.execute(sql)

If dr.eof Or dr.bof Then
	huil = 0
Else
	huil = dr(0)
dr.close
End if

sql = "select lidx,gu from coupon_mast where cnum='"& cnum &"' and used=0 and DATEDIFF (day,getdate(),end_date) >= 0"
set rs = db.execute(sql)

if rs.eof or rs.bof then

	response.write"<script>"
	response.write"alert('쿠폰정보및 유효기간을 확인해주세요!!');"
	response.write"self.location.href='07_coupon.asp';"	
	response.write"</script>"
	response.end

else	
	
	
	db.execute("update coupon_mast set used = 1, uid = '"& str_User_ID &"' , used_date = '"& date() &"' where cnum='"& cnum &"' and used=0")


If rs(1) = 2 then
	sql = "select intgigan,categbn,intprice from LecturTab where idx = "& rs(0)
Else
	sql = "select intgigan,gbn,intprice from LectMast where idx = "& rs(0)
End if
	set rs1= db.execute(sql)
	
	if rs1.eof or rs1.bof then

		response.write"<script>"
		response.write"alert('쿠폰사용가능한 동영상강의가 없습니다.\n\n관리자에게 문의해주세요!');"
		response.write"self.location.href='07_coupon.asp';"	
		response.write"</script>"
		response.end
		
	else

		idx = Request.Form("idx")
		buygbn = 3
		categbn = rs1(1)
		tabidx = rs(0)
		strsday = date()
		intgigan = rs1(0)
		intprice = rs1(2)
		paytype = 6
		paytime = formatdatetime(now,4)
		payday = strsday & " " & paytime & ":00"

		dim tabnm,strnm,tableidx,dbbuygbn,huil

If rs(1) = 2 then
		tabnm = "LecturTab"
		strnm = "단과 : "
		tableidx = tabidx
		dbbuygbn = 2	
Else
		tabnm = "Lectmast"
		strnm = "과정 : "
		tableidx = tabidx
		dbbuygbn = 1	
End if

		dim tempd,eday
		tempd = Cstr(DateAdd("d",intgigan,strsday))
		eday = tempd & " " & FormatDateTime(now(),4) & ":00"	

		dim sday,yy,mm,dd,dary
		sday = payday
	
		''매출통계변수
		dary = split(strsday,"-")
		yy = int(dary(0))
		mm = int(dary(1))
		dd = int(dary(2))
		sql = "insert into order_mast (id,buygbn,tabidx,categbn,title,sday,eday,paytype,intprice,payday,yy,mm,dd,state,holdil) values ('"
		sql = sql & str_User_ID & "'," & dbbuygbn & "," & tableidx & "," & categbn & ",'" & strnm & "',convert(smalldatetime,'" & sday & "'),convert(smalldatetime,'" & eday & "')," & paytype & "," &  intprice & ",convert(smalldatetime,'" & payday & "'),"
		sql = sql & yy & "," & mm & "," & dd & ",0," & huil & ")"
		db.execute(sql)			
	
		response.write"<script>"
		response.write"alert('정상등록되었습니다.');"
		response.write"self.location.href='07_coupon.asp';"	
		response.write"</script>"
		response.end
	
	rs1.close
	end if
	
rs.close	
end if

ELSE %>
<!-- #include file = "../include/false_pg.asp" -->
<% End IF %>