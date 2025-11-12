<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim idx
Dim reply,reply_count,i,rs
Dim gbnS,strsday,streday,strPart,strSearch,intpg

gbnS = Request("gbnS")
strsday = Request("strsday")
streday = Request("streday")
strPart = Request("strPart")
strSearch = Request("strSearch")
intpg = Request("intpg")
idx = Request("idx")

Dim dary,yy,mm,dd		''매출통계변수
dary = split(date,"-")
yy = int(dary(0))
mm = int(dary(1))
dd = int(dary(2))

dim tempd,eday

''order_mast info call

dim sql,dr,a
sql = "select idx,intgigan=case buygbn when 2 then (select intgigan from LecturTab where idx=A.tabidx) when 0 then (select intgigan from premtab where idx=A.tabidx) when 3 then (select ca1 from book_mast where idx=A.tabidx) else (select intgigan from Lectmast where idx=A.tabidx) end"
sql = sql & ",tabnm=case buygbn when 2 then 'LecturTab' when 0 then 'premtab' else 'LecturTab' end,tabidx,cnumber,id,bookidx,order_id from order_mast A where bankidx=" & idx &" order by idx desc"
set dr = db.execute(sql)

Dim isRecod,isRows,isCols

if not dr.bof or not dr.eof then
	isRecod = True
	isRows = split(dr.getstring(2),chr(13))
end if
dr.close
set dr = nothing

if isRecod then
	for ii = 0 to UBound(isRows) - 1
		isCols = split(isRows(ii),chr(9))		
		If Len(isCols(1)) = 0 Then 
			a = 1
		Else
			a = isCols(1)
		End if
		tempd = Cstr(DateAdd("d",a,date))
		eday = tempd & " " & FormatDateTime(now(),4) & ":00"

		reply = split(isCols(4),",")
		reply_count = ubound(reply)

		For i = 1 To reply_count

			sql = "select count(idx) from coupon_price_mast where state=0 and cnumber = '"& reply(i) &"'"
			Set rs=db.execute(sql)

			If rs(0) = 1 then

				sql = "update coupon_price_mast set state=1 , id = '"& isCols(5) &"' , use_date = '"& Date() &"', order_id = '"& isCols(7) &"' where cnumber = '" & reply(i) & "' and state=0"
				db.execute(sql)
			
			rs.close
			End if

		Next

		''order_mast update
		sql = "update order_mast set sday=getdate(),eday=convert(smalldatetime,'" & eday & "'),payday=getdate(),yy=" & yy & ",mm=" & mm & ",dd=" & dd & ",state=0 where idx=" & isCols(0)
		db.execute(sql)

		db.execute("update " & isCols(2) & " set inginum=inginum+1 where idx=" & isCols(3))
	Next

	db.execute("update bank_order set paystate=1,payday=getdate() where idx=" & idx)
else
	db.execute("delete bank_order where idx=" & idx)
end if

db.close
set db = nothing

Response.redirect "onlist.asp?intpg="& intpg &"&gbnS=" & gbnS & "&strsday=" & strsday & "&streday=" & streday & "&strPart=" & strPart & "&strSearch=" & strSearch &""
Response.End

%>
<!-- #include file = "../authpg_2.asp" -->