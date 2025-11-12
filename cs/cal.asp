<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<%
dim idx,cat1,show,title,module_idx,ca,cal_type,sun_check,check_date1,re_check,m_level
dim rs,rs1,rs2,rs3,check_value1,check_value2,check_value3,check_value4
dim ThisDate,ThisYear,ThisMonth,PrevThisYear,PrevMonth,NextMonth,LastDay,LoopWeek,NextThisYear
dim FirstDay,FirstWeekDay,Today,NowThisDay,PrintDay,Stop_Flag,Loopday,Thisday
dim endweek,ThisMonth1,PrintDay1,gu,sid,check_date,viewcheck
dim user_point1,user_board1,user_reply1,user_login1,user_level1,i

sql = "select google_pwd from site_info "
set rs=db.execute(sql)

if rs.eof or rs.bof then
	response.write"<script>"
	response.write"alert('데이터 오류');"
	response.write"history.back();"
	response.write"</script>"
	response.end			
else
	
	dim rest_day : rest_day = rs(0)

rs.close
end if

idx = Request("cal_idx")

sql = "select sid,gu,m_level,title from cal_mast where idx = "& idx
set rs=db.execute(sql)

if rs.eof or rs.bof then
	response.write"<script>"
	response.write"alert('데이터 오류');"
	response.write"history.back();"
	response.write"</script>"
	response.end			
else
	sid = rs(0)
	cal_type = rs(1)
	m_level = rs(2)
	title = rs(3)
end if

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
        	<h3><%=title%></h3>
        </div>
        <div class="scont">

<p style="margin:20px 0 20px 0"><a href="?ThisDate=<%=PrevMonth%>&cal_idx=<%=request("cal_idx")%>"><img src='/img/img/a_prev1.gif'></a><span style="color:#000000;font-size:16px;margin:0 20px 0 20px;font-weight:bold;"><%=Thisyear%>년&nbsp;<%=ThisMonth%>월</span><a href="?ThisDate=<%=NextMonth%>&cal_idx=<%=request("cal_idx")%>"><img src='/img/img/a_next1.gif'></a></p>
<%
sql="select idx,title,bg_color,font_color from cal_gu_mast where sid = '"& sid &"' order by ordnum asc,idx desc"
set rs1 = db.execute(sql)
if rs1.eof or rs1.bof then
Else
response.write "<p style='margin:0 0 20px 0'>"
do until rs1.eof
%>
<span style="background-color:<%=rs1(2)%>;border-color:<%=rs1(2)%>;font-size:4pt;padding-left:3px;font-weight:bold;letter-spacing:-1pt;">&nbsp;</span>&nbsp;<span class="grey1"><%=rs1(1)%></span>&nbsp;
<%
rs1.movenext
loop
rs1.close
response.write "</p>"
end if
%>
<%if cal_type = 0 then%>
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
		response.Write "<br /><font color=cc0000>공휴일</font>"
		end if%>

    <%if len(idx) > 0 then%>
<%
		sql="select a.idx,a.title,(select bg_color from cal_gu_mast where sid=a.sid and idx=a.gu),(select font_color from cal_gu_mast where sid=a.sid and idx=a.gu) from cal_content a where DateDiff(dd, '"& check_date &"',a.date2) >=0 and DateDiff(dd, a.date1,'"& check_date &"') >= 0 and sid='"& sid &"' order by a.idx desc"
		set rs1 = db.execute(sql)
		if rs1.eof or rs1.bof then
		else
		do until rs1.eof						
%><br /><span style="cursor:pointer" onclick="layer_open('layer2',<%=rs1(0)%>);return false;"><%=rs1(1)%></span><%
						rs1.movenext
						loop
						rs1.close
						end if
						%>

    <%end if%>

          <%	Else%>
    <td class='tl' style="height:90px;vertical-align: top;"><%=PrintDay%>
<%if instr(rest_day,re_check) then
		response.Write "<br /><font color=cc0000>공휴일</font>"
		end if%>

          <%if len(idx) > 0 then%>
<%
		sql="select a.idx,a.title,(select bg_color from cal_gu_mast where sid=a.sid and idx=a.gu),(select font_color from cal_gu_mast where sid=a.sid and idx=a.gu) from cal_content a where DateDiff(dd, '"& check_date &"',a.date2) >=0 and DateDiff(dd, a.date1,'"& check_date &"') >= 0 and sid='"& sid &"' order by a.idx desc"
		set rs1 = db.execute(sql)
		if rs1.eof or rs1.bof then
		else
		do until rs1.eof						
						%><br /><span style="cursor:pointer" onclick="layer_open('layer2',<%=rs1(0)%>);return false;"><%=rs1(1)%></span><%
						rs1.movenext
						loop
						rs1.close
						end if
						%>

          <%end if%>

        <%						End If

  					ElseIf LoopDay = 7 Then%>
<td class='tl' style="height:90px;vertical-align: top;"><%=PrintDay%>
<%if instr(rest_day,re_check) then
		response.Write "<br /><font color=cc0000>공휴일</font>"
		end if%>
          <%if len(idx) > 0 then%>
<%
sql="select a.idx,a.title,(select bg_color from cal_gu_mast where sid=a.sid and idx=a.gu),(select font_color from cal_gu_mast where sid=a.sid and idx=a.gu) from cal_content a where DateDiff(dd, '"& check_date &"',a.date2) >=0 and DateDiff(dd, a.date1,'"& check_date &"') >= 0 and sid='"& sid &"' order by a.idx desc"
set rs1 = db.execute(sql)
if rs1.eof or rs1.bof then
else
do until rs1.eof						
%><br /><span style="cursor:pointer" onclick="layer_open('layer2',<%=rs1(0)%>);return false;"><%=rs1(1)%></span><%
						rs1.movenext
						loop
						rs1.close
						end if
%>
          <%end if%>

          <%  					ElseIf LoopDay = 1 Then%>
<td class='tl' style="height:90px;vertical-align: top;"><%=PrintDay%>
<%if instr(rest_day,re_check) then
		response.Write "<br /><font color=cc0000>공휴일</font>"
		end if%>
          <%if len(idx) > 0 then%><%
		sql="select a.idx,a.title,(select bg_color from cal_gu_mast where sid=a.sid and idx=a.gu),(select font_color from cal_gu_mast where sid=a.sid and idx=a.gu) from cal_content a where DateDiff(dd, '"& check_date &"',a.date2) >=0 and DateDiff(dd, a.date1,'"& check_date &"') >= 0 and sid='"& sid &"' order by a.idx desc"
		set rs1 = db.execute(sql)
		if rs1.eof or rs1.bof then
		else
		do until rs1.eof						
						%><br /><span style="cursor:pointer" onclick="layer_open('layer2',<%=rs1(0)%>);return false;"><%=rs1(1)%></span><%
						rs1.movenext
						loop
						rs1.close
						end if
						%>
<%end if%>
          <%
  					Else%>
<td class='tl' style="height:90px;vertical-align: top;">
<%=PrintDay%>
<%if instr(rest_day,re_check) then
		response.Write "<br /><font color=cc0000>공휴일</font>"
		end if%>

          <%if len(idx) > 0 then%>
<%
		sql="select a.idx,a.title,(select bg_color from cal_gu_mast where sid=a.sid and idx=a.gu),(select font_color from cal_gu_mast where sid=a.sid and idx=a.gu) from cal_content a where DateDiff(dd, '"& check_date &"',a.date2) >=0 and DateDiff(dd, a.date1,'"& check_date &"') >= 0 and sid='"& sid &"' order by a.idx desc"
		set rs1 = db.execute(sql)
		if rs1.eof or rs1.bof then
		else
		do until rs1.eof						
						%><br /><span style="cursor:pointer" onclick="layer_open('layer2',<%=rs1(0)%>);return false;"><%=rs1(1)%></span><%
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
                    </table></td>
                </tr>
              </table>
<%else%>


            <table class="btbl" style="width:830px">
                    <colgroup>
                    <col style="width:15%" />
                    <col style="width:85%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>요일</th>
                            <th class="bkn">내용</th>
                        </tr>
                    </thead>
                    <tbody>
<%
sun_check = 0
for i = 1 to LastDay



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
		
		

		
		check_date1 = i+FirstWeekDay
		
%>	  
      <tr>
            <td><%if check_date1 mod 7 = 1 then 
			response.write"<font color='#336699'>"
			sun_check = check_date1 + 1
			end if%><%if sun_check = check_date1 then 
			response.write"<font color='#cc0000'>" 
			sun_check = 0
			end if%><%=i%></font><%if instr(rest_day,re_check) then
		response.Write "&nbsp;<font color=cc0000>(공휴일)</font>"
		end if%></td>
			<td class="tl">
<%
sql="select a.idx,a.title,(select bg_color from cal_gu_mast where sid=a.sid and idx=a.gu),(select font_color from cal_gu_mast where sid=a.sid and idx=a.gu) from cal_content a where DateDiff(dd, '"& check_date &"',a.date2) >=0 and DateDiff(dd, a.date1,'"& check_date &"') >= 0 and sid='"& sid &"' order by a.idx desc"
set rs1 = db.execute(sql)

if rs1.eof or rs1.bof then
else
do until rs1.eof						
%><%if len(rs1(2)) > 0 then%><span style="background-color:<%=rs1(2)%>; border-color:<%=rs1(2)%>; font-size:4pt; padding-left:3px; font-weight:bold;  letter-spacing:-1pt;">&nbsp;</span>&nbsp;<%end if%><span style="cursor:pointer" onclick="layer_open('layer2',<%=rs1(0)%>);return false;"><span class="grey1"><%=rs1(1)%></span></span></span><%
rs1.movenext
loop
rs1.close
end if
%></td>
      </tr>
<%
PrintDay = PrintDay + 1

next
%>	  
    </table>

<%End if%>

        </div>
    </div>
</div>

<style>
.layer {display:none; position:fixed; _position:absolute; top:0; left:0; width:100%; height:100%; z-index:555;}
.layer .bg {position:absolute; top:0; left:0; width:100%; height:100%; background:#000; opacity:.5; filter:alpha(opacity=50);}
.layer .pop-layer {display:block;}

.pop-layer {display:none; position: absolute; top: 50%; left: 50%; width: 770px; height:auto;  background-color:#fff; z-index: 10;}	
.pop-layer .pop-container {padding: 20px 25px 40px; overflow:hidden;}
.pop-layer p.ctxt {color: #666; line-height:25px; text-align:center;}
.pop-layer p.ctxt img{max-width:139px;}
.pop-layer .login-input{background-color:#fff; border:1px solid #ddd; width:100%; padding:10px; box-sizing:border-box; margin:4px 0px}
.pop-layer .login-input[type="password"]{font-family:'dotum'}
.pop-layer .btn-r {text-align:right;}
</style>
<!-- 레이어 팝업 -->
<div class="layer">
	<div class="bg"></div>
	<div id="layer2" class="pop-layer">
		<div class="pop-container">
			<div class="pop-conts">
				<div class="btn-r">
					<a href="#" class="cbtn"><img src='/img/btn_close.png'></a>
				</div>
				<div  id="openwin_99"></div>
			</div>
		</div>
	</div>
</div>
<!-- 레이어 팝업 end -->
<script type="text/javascript">
	function layer_open(el,idx){
		var temp = $('#' + el);
		var bg = temp.prev().hasClass('bg');	//dimmed 레이어를 감지하기 위한 boolean 변수
		if(bg){
			$('.layer').fadeIn();	//'bg' 클래스가 존재하면 레이어가 나타나고 배경은 dimmed 된다. 
		}else{
			temp.fadeIn();
		}

		// 화면의 중앙에 레이어를 띄운다.
		if (temp.outerHeight() < $(document).height() ) temp.css('margin-top', '-'+temp.outerHeight()/2+'px');
		else temp.css('top', '0px');
		if (temp.outerWidth() < $(document).width() ) temp.css('margin-left', '-'+temp.outerWidth()/2+'px');
		else temp.css('left', '0px');

		temp.find('a.cbtn').click(function(e){
			if(bg){
				$('.layer').fadeOut(); //'bg' 클래스가 존재하면 레이어를 사라지게 한다. 
			}else{
				temp.fadeOut();
			}
			e.preventDefault();
		});

		$('.layer .bg').click(function(e){	//배경을 클릭하면 레이어를 사라지게 하는 이벤트 핸들러
			$('.layer').fadeOut();
			e.preventDefault();
		});

		$.ajax({
			url: "../xml/cal_view.asp",
			type:"POST",
			data:{"idx":idx},
			dataType:"text",
			cache:false,
			processData:true,
			success:function(_data){	

				$('#openwin_99').html(_data);

			},
			error:function(xhr,textStatus){
			alert("[에러]원인:"+xhr.status+"                                     ");
			}	
		});			

	}			
</script>

<!-- #include file="../include/bottom.asp" -->