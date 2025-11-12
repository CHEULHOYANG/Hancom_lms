<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/refer_check.asp" --><%
vPage = vPage & "/yes_rad/sub3_group_mast/setinput.asp"
if inStr(vReferer,vPage) > 0 then %>
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,dr,rs,strMsg
dim idx,buygbn,categbn,tabidx,strsday,intgigan,paytype,paytime,payday,huday
Dim tabnm,strnm,clmn,tableidx,dbbuygbn

idx = Request.Form("idx")
buygbn = Request.Form("buygbn")
categbn = Request.Form("categbn")
tabidx = Request.Form("tabidx")
strsday = Request.Form("strsday")
intgigan = Request.Form("intgigan")
paytype = Request.Form("paytype")
paytime = formatdatetime(now,4)

idx = Txt2str(idx)
buygbn = Txt2str(buygbn)
categbn = Txt2str(categbn)
tabidx = Txt2str(tabidx)
strsday = Txt2str(strsday)
intgigan = Txt2str(intgigan)
paytype = Txt2str(paytype)
payday = strsday & " " & paytime & ":00"

sql = "select huday from site_info"
set dr = db.execute(sql)

If dr.eof Or dr.bof Then
	huday = 0
Else
	huday = dr(0)
dr.close
End if


select case int(buygbn)
	case 1
		tabnm = "premTab"
		strnm = "프리미엄 : "
		tableidx = categbn
		dbbuygbn = 0
	case 2
		tabnm = "Lectmast"
		strnm = "과정 : "
		tableidx = tabidx
		dbbuygbn = 1
	case 3
		tabnm = "LecturTab"
		strnm = "단과 : "
		tableidx = tabidx
		dbbuygbn = 2
end select

Dim bycnt,bbycnt,idx_check,munje_idx,munje_idx_count,i


munje_idx = split(idx,",")
munje_idx_count = ubound(munje_idx)

For i = 0 To munje_idx_count

	sql="select id,name from member where sp1 = '"& munje_idx(i) &"' order by idx desc"
	Set rs = db.execute(sql)

	If rs.eof Or rs.bof Then
	Else
	Do Until rs.eof

		sql = "select count(idx) from order_mast where bookidx=0 and id='" & rs(0) & "' and buygbn=0 and eday > convert(smalldatetime,getdate())"
		set dr = db.execute(sql)

		bycnt = int(dr(0))
		dr.close	

		sql = "select count(idx) from order_mast where bookidx=0 and id='" & rs(0) & "' and buygbn=" & dbbuygbn & " and tabidx=" & tableidx & " and eday > convert(smalldatetime,getdate())"
		set dr = db.execute(sql)
	
		bbycnt = int(dr(0))
		dr.close

		If bycnt = 0 And bbycnt = 0 Then

			sql = "select intprice from " & tabnm & " where idx=" & tableidx
			Dim intprice,huil
			set dr = db.execute(sql)
			intprice = dr(0)
			dr.close

			''휴학기간 설정
			''기간이 30 - 60일 과정 : 7일 휴학
			''기간이 61 - 180일 과정 : 15일 휴학
			''기간이 181 이상인 과정 : 30일 휴학 가능

			huil = huday

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
			sql = sql & rs(0) & "'," & dbbuygbn & "," & tableidx & "," & categbn & ",'" & strnm & "',convert(smalldatetime,'" & sday & "'),convert(smalldatetime,'" & eday & "')," & paytype & "," &  intprice & ",convert(smalldatetime,'" & payday & "'),"
			sql = sql & yy & "," & mm & "," & dd & ",0," & huil & ")"
			db.execute(sql)

			''response.write sql

		End if


	rs.movenext
	loop
	rs.close
	End if

next

%>

<script language="javascript">

	alert("수강등록을 마쳤습니다!");
	opener.location.reload();
	self.close();

</script>
</head>
<% else %><!-- #include file = "../../include/false_pg.asp" -->
<% end if

function Txt2str(str)
	str = replace(str,"<","&lt;")
	str = replace(str,">","&gt;")
	str = replace(str,"'","''")
	Txt2str = str
end function
%>
<!-- #include file = "../authpg_2.asp" -->