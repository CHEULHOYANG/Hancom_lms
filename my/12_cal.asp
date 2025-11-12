<!-- #include file="../include/set_loginfo.asp" -->
<% if  isUsr then %>
<!-- #include file = "../include/dbcon.asp" -->
<%
dim idx,cat1,show,title,module_idx,ca,cal_type,sun_check,check_date1,re_check,m_level
dim rs,rs1,rs2,rs3,check_value1,check_value2,check_value3,check_value4
dim ThisDate,ThisYear,ThisMonth,PrevThisYear,PrevMonth,NextMonth,LastDay,LoopWeek,NextThisYear
dim FirstDay,FirstWeekDay,Today,NowThisDay,PrintDay,Stop_Flag,Loopday,Thisday
dim endweek,ThisMonth1,PrintDay1,gu,sid,check_date,viewcheck
dim user_point1,user_board1,user_reply1,user_login1,user_level1
dim rest_day : rest_day = "01-01,03-01,05-05,05-28,06-06,08-15,10-03,10-09,12-25"

viewcheck = "T"

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
%>
<!-- #include file="../include/head1.asp" -->
<!-- #include file="../include/top.asp" -->

<div class="smain">    
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3>출석현황</h3>
        </div>
        <div class="scont">
<p style="margin:20px 0 20px 0"><a href="?ThisDate=<%=PrevMonth%>"><img src='/img/img/a_prev1.gif'></a><span style="color:#000000;font-size:16px;margin:0 20px 0 20px;font-weight:bold;"><%=Thisyear%>년&nbsp;<%=ThisMonth%>월</span><a href="?ThisDate=<%=NextMonth%>"><img src='/img/img/a_next1.gif'></a></p>

<table class="btbl" style="width:830px">
			<colgroup>
				<col style="width:14%" />
				<col style="width:14%" />
				<col style="width:14%" />
				<col style="width:14%" />
				<col style="width:14%" />
				<col style="width:14%" />
				<col style="width:14%" />
			</colgroup>
			<tbody>
				<tr>
					<th>일</th>
					<th>월</th>
					<th>화</th>
					<th>수</th>
					<th>목</th>
					<th>금</th>
					<th>토</th>
				</tr>
                    <%


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
		re_check = ThisMonth1 &"-"& PrintDay1	

if PrintDay <= LastDay then

		sql = "select count(idx) from user_ip_check where DateDiff(dd, '"& check_date &"',regdate) =0 and uid = '"& str_User_ID &"'"
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
				Response.Write "<td>"
  				FirstWeekDay = FirstWeekDay - 1

	 		Else

				If PrintDay > LastDay Then

  					Response.Write "<td>"
	
				Else						

  					If PrintDay = NowThisDay Then
						
						NowThisDay = year(now) & "/" & month(now)
						If Request("ThisDate") = "" Then
							ThisDay =  year(now) & "/" & month(now)
						Else
							ThisDay = Request("ThisDate")
						End If

						If NowThisDay = ThisDay Then%><td class='tl' style="height:90px;vertical-align: top;">
<%=PrintDay%>
<%if instr(rest_day,re_check) then
		response.Write "&nbsp;<font color=cc0000>공휴일</font>"
		end if%>

    <%if len(idx) > 0 then%>
<%
		sql="select count(idx) from user_ip_check where DateDiff(dd, '"& check_date &"',regdate) =0 and uid = '"& str_User_ID &"'"
		set rs1 = db.execute(sql)

		If rs1(0) > 0 Then response.write "<br /><br /><font color='#336699'><strong>출석</strong></font>" End If
		rs1.close
		%>

    <%end if%>

          <%	Else%>
		  <td class='tl' style="height:90px;vertical-align: top;"><%=PrintDay%>
		  <%if instr(rest_day,re_check) then
		response.Write "&nbsp;<font color=cc0000>공휴일</font>"
		end if%>

          <%if len(idx) > 0 then%>
<%
		sql="select count(idx) from user_ip_check where DateDiff(dd, '"& check_date &"',regdate) =0 and uid = '"& str_User_ID &"'"
		set rs1 = db.execute(sql)

		If rs1(0) > 0 Then response.write "<br /><br /><font color='#336699'><strong>출석</strong></font>" End If
		rs1.close
		%>
          <%end if%>

        <%						End If

  					ElseIf LoopDay = 7 Then%><td class='tl' style="height:90px;vertical-align: top;"><%=PrintDay%><%if instr(rest_day,re_check) then
		response.Write "&nbsp;<font color=cc0000>공휴일</font>"
		end if%>
          <%if len(idx) > 0 then%>
<%
		sql="select count(idx) from user_ip_check where DateDiff(dd, '"& check_date &"',regdate) =0 and uid = '"& str_User_ID &"'"
		set rs1 = db.execute(sql)

		If rs1(0) > 0 Then response.write "<br /><br /><font color='#336699'><strong>출석</strong></font>" End If
		rs1.close
		%>
          <%end if%>

          <%  					ElseIf LoopDay = 1 Then%>
      <td class='tl' style="height:90px;vertical-align: top;"><%=PrintDay%>
<%if instr(rest_day,re_check) then
		response.Write "&nbsp;<font color=cc0000>공휴일</font>"
		end if%>
          <%if len(idx) > 0 then%>
<%
		sql="select count(idx) from user_ip_check where DateDiff(dd, '"& check_date &"',regdate) =0 and uid = '"& str_User_ID &"'"
		set rs1 = db.execute(sql)

		If rs1(0) > 0 Then response.write "<br /><br /><font color='#336699'><strong>출석</strong></font>" End If
		rs1.close
		%>
          <%end if%>
          <%
  					Else%>
      <td class='tl' style="height:90px;vertical-align: top;"><%=PrintDay%><%if instr(rest_day,re_check) then
		response.Write "&nbsp;<font color=cc0000>공휴일</font>"
		end if%>
          <%if len(idx) > 0 then%>
 <%
		sql="select count(idx) from user_ip_check where DateDiff(dd, '"& check_date &"',regdate) =0 and uid = '"& str_User_ID &"'"
		set rs1 = db.execute(sql)

		If rs1(0) > 0 Then response.write "<br /><br /><font color='#336699'><strong>출석</strong></font>" End If
		rs1.close
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
                    </table>

        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" --><% else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>