<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
dim sql,rs,rs1
dim ThisDate,ThisYear,ThisMonth,PrevThisYear,PrevMonth,NextMonth,LastDay,LoopWeek,NextThisYear
dim FirstDay,FirstWeekDay,Today,NowThisDay,PrintDay,Stop_Flag,Loopday,Thisday
dim endweek,ThisMonth1,PrintDay1,idx,title,gu,sid,check_date

sid = request("sid")
ThisDate = Request("ThisDate")
	
	If ThisDate = "" Then
		ThisYear = year(now)
		ThisMonth = month(now)
	Else
		ThisDate = Split(Request("ThisDate"),"/")
		ThisYear = ThisDate(0)
		ThisMonth = ThisDate(1)
	End If

	If ThisMonth = 1 Then

		PrevThisYear = ThisYear -1
		PrevMonth = 12
		NextMonth = 2

		PrevMonth = PrevThisYear & "/" & PrevMonth
		NextMonth = ThisYear & "/" & NextMonth


	ElseIf ThisMonth = 12 Then

		PrevMonth = 11
		NextThisYear = ThisYear +1
		NextMonth= 1

		PrevMonth = ThisYear & "/" & PrevMonth
		NextMonth = NextThisYear & "/" & NextMonth

	Else

		PrevMonth = ThisMonth -1
		NextMonth = ThisMonth +1

		PrevMonth = ThisYear & "/" & PrevMonth
		NextMonth = ThisYear & "/" & NextMonth

	End If
	
	FirstDay = DateSerial(ThisYear,ThisMonth,1)
	FirstWeekDay = WeekDay(FirstDay,vbSunday)



	
	PrintDay = 1

	Select Case ThisMonth
		Case 1, 3, 5, 7, 8, 10, 12
			LastDay = 31
		Case 4, 6, 9, 11
			LastDay = 30
		Case 2
			If IsDate("February 29, " & ThisYear) Then
				LastDay = 29
			Else
				LastDay = 28
			End If
	End Select

	Today = year(now) & "/" & month(now)
	NowThisDay = day(now)


dim cal_counter	
	
sql = "select count(idx) from cal_content where sid='"& sid &"' and DATEDIFF (month,getdate(),date1) = 0"
set rs=db.execute(sql)

cal_counter = rs(0)
rs.close
%>

<!--#include file="../main/top.asp"-->

<script>
function ToggleCheckAll(button) {
	var sa=true;
	if(button.checked) sa=false;
	for (var i=0;i<document.frmlist.elements.length;i++) {
		var e = document.frmlist.elements[i];
		if(sa) e.checked=false;
		else e.checked=true;
	}
	if(sa) button.checked=false;
	else button.checked=true;
}

function check_del(theForm){

var num = <%=cal_counter%>;
var sel_check = false;

if(num == 0) alert("삭제할 일정이 없습니다");


else if(num == 1) {


    if(frmlist.idx.checked) sel_check = true;
    if(sel_check){
            var del_check = window.confirm("체크한 일정을 일괄삭제합니다");
            if(del_check) 
			document.frmlist.action="view_check_del.asp";
			document.frmlist.submit();
    } else alert("삭제할 일정을 선택해주세요.");


} else if(num > 1) {


    var idx_len = theForm.idx.length;

    for (i=0; i < idx_len; i++){
         if(theForm.idx[i].checked){
            sel_check = true;
            break;
         }
    }



    if(sel_check){
         var del_check = window.confirm("체크한 일정을 일괄삭제합니다"); 
         if(del_check)
		 document.frmlist.action="view_check_del.asp";
		 document.frmlist.submit();
     } else alert("삭제할 일정을 선택해주세요");


}
} 
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>일정관리</h2>

			<div class="paging">
				<a href="?ThisDate=<%=PrevMonth%>&sid=<%=sid%>"><img src="../rad_img/img/a_prev1.gif" alt="이전페이지" /></a>
				<strong><%=Thisyear%>년<%=ThisMonth%>월</strong>
				<a href="?ThisDate=<%=NextMonth%>&sid=<%=sid%>"><img src="../rad_img/img/a_next1.gif" alt="다음페이지"></a>
			</div>

		<div class="tbl_top">

<form name="frmlist" method="post" >	
<input type="hidden" name="sid" value="<%=sid%>">
<input type="hidden" name="ThisDate" value="<%=ThisYear%>/<%=ThisMonth%>">

		<input type="checkbox" name="CheckAll" onClick="ToggleCheckAll(this)"> 전체선택&nbsp;&nbsp;

			<%
		sql="select idx,title,bg_color,font_color from cal_gu_mast where sid = '"& sid &"' order by ordnum asc,idx desc"
		set rs1 = db.execute(sql)
		if rs1.eof or rs1.bof then
		else
		do until rs1.eof						
						%><span style="padding:5px 5px;background-color:<%=rs1(2)%>;font-size:8pt; color:<%=rs1(3)%>;letter-spacing:-1px;"><%=rs1(1)%></span>&nbsp;<%
						rs1.movenext
						loop
						rs1.close
						end if
						%>
			<span class="tbl_total"><a href="edit.asp?sid=<%=sid%>" class="fbtn">일정수정</a></span>
		</div>


          <table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:14%" />
			<col style="width:14%" />
			<col style="width:14%" />
			<col style="width:14%" />
			<col style="width:14%" />
			<col style="width:14%" />
			<col style="width:14%" />	
			</colgroup>
			<thead>
				<tr>
					<th>일</th>	
					<th>월</th>
					<th>화</th>
					<th>수</th>	
					<th>목</th>
<th>금</th>
<th>토</th>
				</tr>				
			</thead>
			<tbody>
                <%
if FirstWeekDay > 5 then	
	if FirstWeekDay =6 and LastDay >= 30 then
		endweek = 5	
	elseif FirstWeekDay =6 and LastDay >= 31 then
		endweek = 6	
	elseif FirstWeekDay > 6 and LastDay >= 30 then	
		endweek = 6
	else		
		endweek = 6			
	end if
else
	endweek = 5	
end if	

	  	For LoopWeek = 1 To endweek

  	Response.Write "<tr>" & chr(13)

  		For LoopDay = 1 To 7



if len(ThisMonth) = 1 then
			ThisMonth1 = "0"& ThisMonth &""
		else
			ThisMonth1 = ThisMonth	
		end if
		if len(PrintDay) = 1 then
			PrintDay1 = "0"& PrintDay &""
		else
			PrintDay1 = PrintDay	
		end if			
		
		check_date = ThisYear &"-"& ThisMonth1 &"-"& PrintDay1
		

if PrintDay <= LastDay then

		sql = "select count(idx) from cal_content where DateDiff(dd, '"& check_date &"',date2) >=0 and DateDiff(dd, date1,'"& check_date &"') >= 0 and sid='"& sid &"'"
		set rs=db.execute(sql)
		
		if rs.eof or rs.bof then
			idx = 0
		else		
			idx = rs(0)	
		rs.close
		end if	

else
		
	idx = ""

end if

			If FirstWeekDay > 1 Then	
				Response.Write "<td class=""tl"" style=""height:100px"">"
  				FirstWeekDay = FirstWeekDay - 1

	 		Else

				If PrintDay > LastDay Then

  					Response.Write "<td class=""tl"" style=""height:100px"">"
	
				Else						

  					If PrintDay = NowThisDay Then
						
						NowThisDay = year(now) & "/" & month(now)
						If Request("ThisDate") = "" Then
							ThisDay =  year(now) & "/" & month(now)
						Else
							ThisDay = Request("ThisDate")
						End If

						If NowThisDay = ThisDay Then%>
  <td class="tl" style="height:100px">	
<a href="#" onClick="window.open('calender_write.asp?check_date=<%=check_date%>&sid=<%=sid%>','cal','width=720,height=500,menubar=no,scrollbars=no');"><strong><%=PrintDay%></strong></a></a>
<%if len(idx) > 0 then%>  
<%
		sql="select a.idx,a.title,(select bg_color from cal_gu_mast where sid=a.sid and idx=a.gu),(select font_color from cal_gu_mast where sid=a.sid and idx=a.gu) from cal_content a where DateDiff(dd, '"& check_date &"',a.date2) >=0 and DateDiff(dd, a.date1,'"& check_date &"') >= 0 and sid='"& sid &"' order by a.idx desc"
		set rs1 = db.execute(sql)
		if rs1.eof or rs1.bof then
		else
		do until rs1.eof						
						%><br /><input type="checkbox" name="idx" value="<%=rs1(0)%>">&nbsp;<a href="javascript:window.open('calender_edit.asp?idx=<%=rs1(0)%>','cal','width=720,height=500,menubar=no,scrollbars=no');"><span style="padding:5px 5px;background-color:<%=rs1(2)%>;font-size:8pt; color:<%=rs1(3)%>;letter-spacing:-1px;"><%=rs1(1)%></span></a><%
						rs1.movenext
						loop
						rs1.close
						end if
						%>
<%end if%> 



          <%	Else%>
    <td class="tl" style="height:100px">
<a href="#" onClick="window.open('calender_write.asp?check_date=<%=check_date%>&sid=<%=sid%>','cal','width=720,height=500,menubar=no,scrollbars=no');"><strong><%=PrintDay%></strong></a></a>
<%if len(idx) > 0 then%>  
<%
		sql="select a.idx,a.title,(select bg_color from cal_gu_mast where sid=a.sid and idx=a.gu),(select font_color from cal_gu_mast where sid=a.sid and idx=a.gu) from cal_content a where DateDiff(dd, '"& check_date &"',a.date2) >=0 and DateDiff(dd, a.date1,'"& check_date &"') >= 0 and sid='"& sid &"' order by a.idx desc"
		set rs1 = db.execute(sql)
		if rs1.eof or rs1.bof then
		else
		do until rs1.eof						
						%><br /><input type="checkbox" name="idx" value="<%=rs1(0)%>">&nbsp;<a href="javascript:window.open('calender_edit.asp?idx=<%=rs1(0)%>','cal','width=720,height=500,menubar=no,scrollbars=no');"><span style="padding:5px 5px;background-color:<%=rs1(2)%>;font-size:8pt; color:<%=rs1(3)%>;letter-spacing:-1px;"><%=rs1(1)%></span></a><%
						rs1.movenext
						loop
						rs1.close
						end if
						%>
<%end if%> 

	
          <%						End If

  					ElseIf LoopDay = 7 Then%>
      <td class="tl" style="height:100px">
	  
<a href="#" onClick="window.open('calender_write.asp?check_date=<%=check_date%>&sid=<%=sid%>','cal','width=720,height=500,menubar=no,scrollbars=no');"><strong><%=PrintDay%></strong></a></a>
<%if len(idx) > 0 then%>  
<%
		sql="select a.idx,a.title,(select bg_color from cal_gu_mast where sid=a.sid and idx=a.gu),(select font_color from cal_gu_mast where sid=a.sid and idx=a.gu) from cal_content a where DateDiff(dd, '"& check_date &"',a.date2) >=0 and DateDiff(dd, a.date1,'"& check_date &"') >= 0 and sid='"& sid &"' order by a.idx desc"
		set rs1 = db.execute(sql)
		if rs1.eof or rs1.bof then
		else
		do until rs1.eof						
						%><br /><input type="checkbox" name="idx" value="<%=rs1(0)%>">&nbsp;<a href="javascript:window.open('calender_edit.asp?idx=<%=rs1(0)%>','cal','width=720,height=500,menubar=no,scrollbars=no');"><span style="padding:5px 5px;background-color:<%=rs1(2)%>;font-size:8pt; color:<%=rs1(3)%>;letter-spacing:-1px;"><%=rs1(1)%></span></a><%
						rs1.movenext
						loop
						rs1.close
						end if
						%>
<%end if%> 

	  
	  
          <%  					ElseIf LoopDay = 1 Then%>
      <td class="tl" style="height:100px">

<a href="#" onClick="window.open('calender_write.asp?check_date=<%=check_date%>&sid=<%=sid%>','cal','width=720,height=500,menubar=no,scrollbars=no');"><strong><%=PrintDay%></strong></a></a>
<%if len(idx) > 0 then%>  
<%
		sql="select a.idx,a.title,(select bg_color from cal_gu_mast where sid=a.sid and idx=a.gu),(select font_color from cal_gu_mast where sid=a.sid and idx=a.gu) from cal_content a where DateDiff(dd, '"& check_date &"',a.date2) >=0 and DateDiff(dd, a.date1,'"& check_date &"') >= 0 and sid='"& sid &"' order by a.idx desc"
		set rs1 = db.execute(sql)
		if rs1.eof or rs1.bof then
		else
		do until rs1.eof						
						%><br /><input type="checkbox" name="idx" value="<%=rs1(0)%>">&nbsp;<a href="javascript:window.open('calender_edit.asp?idx=<%=rs1(0)%>','cal','width=720,height=500,menubar=no,scrollbars=no');"><span style="padding:5px 5px;background-color:<%=rs1(2)%>;font-size:8pt; color:<%=rs1(3)%>;letter-spacing:-1px;"><%=rs1(1)%></span></a><%
						rs1.movenext
						loop
						rs1.close
						end if
						%>
<%end if%> 

	  
	  
          <%
  					Else%>
      <td class="tl" style="height:100px">
<a href="#" onClick="window.open('calender_write.asp?check_date=<%=check_date%>&sid=<%=sid%>','cal','width=720,height=500,menubar=no,scrollbars=no');"><strong><%=PrintDay%></strong></a></a>
<%if len(idx) > 0 then%>  
<%
		sql="select a.idx,a.title,(select bg_color from cal_gu_mast where sid=a.sid and idx=a.gu),(select font_color from cal_gu_mast where sid=a.sid and idx=a.gu) from cal_content a where DateDiff(dd, '"& check_date &"',a.date2) >=0 and DateDiff(dd, a.date1,'"& check_date &"') >= 0 and sid='"& sid &"' order by a.idx desc"
		set rs1 = db.execute(sql)
		if rs1.eof or rs1.bof then
		else
		do until rs1.eof						
						%><br /><input type="checkbox" name="idx" value="<%=rs1(0)%>">&nbsp;<a href="javascript:window.open('calender_edit.asp?idx=<%=rs1(0)%>','cal','width=720,height=500,menubar=no,scrollbars=no');"><span style="padding:5px 5px;background-color:<%=rs1(2)%>;font-size:8pt; color:<%=rs1(3)%>;letter-spacing:-1px;"><%=rs1(1)%></span></a><%
						rs1.movenext
						loop
						rs1.close
						end if
						%>
<%end if%> 

	  
          <%  					End If

				End If

  				PrintDay = PrintDay + 1
				idx=""

				If PrintDay > LastDay Then

					Stop_Flag=1

				End If  			

  			End If

  		Response.Write "</td>" & chr(13)
		
  		Next

  		Response.Write "</tr>" & chr(13)

  	Next

  %>
</tbody>                
</table>

</form>

		<div class="tbl_btm mb80">
			<div class="caution"><p>날짜를 클릭하시면 일정을 등록하실수 있습니다.</p></div>
			<div class="rbtn">
				<a href="javascript:check_del(document.frmlist);" class="btn">선택삭제</a>
			</div>
		</div>

		


<p></p>

	</div>
</div>


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->