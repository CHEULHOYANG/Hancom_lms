<!-- #include file="../include/set_loginfo.asp" -->
<% if  isUsr then %>
<!-- #include file="../include/dbcon.asp" -->
<%
Dim nowPage : nowPage = Request("URL")
Dim dntGbn : dntGbn = request("dntGbn")
Dim dntNm
Dim idx
Dim v_time,rs,v_date,time1,time2
Dim v1,h,m,s
Dim check_time,check_time1,quiz_count,end_check
Dim player1_check,player2_check,player3_check

sql = "select player1,player2,player3 from site_info"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
	player1_check = "Y"
	player2_check = "Y"
	player3_check = "Y"
Else
	player1_check = rs(0)
	player2_check = rs(1)
	player3_check = rs(2)
rs.close
End if
 
 idx = request("idx")

 sql = "select strnm,strteach,intprice,intgigan,(select count(idx) from sectionTab where l_idx="& idx &"),sjin=case sajin when 'noimg.gif' then 'noimage.gif' else sajin end,categbn,tinfo,step_check from LecturTab where idx=" & idx
set dr = db.execute(sql)
dim strnm,strteach,tinfo,intprice,intgigan,totalnum,sajin,bcod,dbcate,step_check_gu
strnm = dr(0)
strteach = dr(1)
intprice = dr(2)
intgigan = dr(3)
totalnum = dr(4)
sajin = dr(5)
dbcate = dr(6)
tinfo = dr(7)
step_check_gu = dr(8)
dr.close

''***********************************************************************************************************************
''수강 중인지 체크
Dim permDwn : permDwn = "true"

if isUsr then

	''프리미엄 강의를 듣는지 체크
	Dim primcnt
	sql = "select count(idx) from order_mast where id='" & str_User_ID & "' and buygbn=0 and state=0"
	set dr = db.execute(sql)
	primcnt = dr(0)
	dr.close

	if int(primcnt) > 0 then
		permDwn = "false"
	else

		''수강하는 과정 속에 포함된 단과 추출
		dim dancnt
		sql = "select count(idx) from order_mast where id='" & str_User_ID & "' and state=0 and  buygbn=1 and tabidx in (select mastidx from LectAry where lectidx=" & idx & ")"
		set dr = db.execute(sql)
		dancnt = dr(0)
		dr.close

		if int(dancnt) > 0 then
			permDwn = "false"
		else

			dim ddn
			sql = "select count(idx) from order_mast where id='" & str_User_ID & "' and state=0 and buygbn=2 and tabidx=" & idx
			set dr = db.execute(sql)
			ddn = dr(0)
			dr.close

			if int(ddn) > 0 then
				permDwn = "false"
			end if

		end if

	end if

end if
''***********************************************************************************************************************

Dim step_check(10000)

step_check(0) = 1
%>
<!-- #include file="../include/head1.asp" -->

<script language="javascript">
function go2ViewerPlay(flg,intUnm,keynm){
	var perm = <%=permDwn%>;
	if(flg){
		alert("로그인 하신 후 이용하세요!");
		return;
	}
	if(perm){
		alert("수강권한이 없거나 휴학중인 강의입니다!");
		return;
	}
	var urlnm="../viwer/viewer_ready.asp?order_mast_idx=<%=request("order_mast_idx")%>&gbn=" + keynm + "&plidx=" + intUnm;
	var sFeatures = "width=980,height=560,top=0,left=0,scrollbars=no,resizable=no,titlebar=no";
	var k = window.open(urlnm, "viewpg", sFeatures);
	k.focus();
}
function go2ViewerPlay_n(flg,intUnm,keynm){
	var perm = <%=permDwn%>;
	if(flg){
		alert("로그인 하신 후 이용하세요!");
		return;
	}
	if(perm){
		alert("수강권한이 없거나 휴학중인 강의입니다!");
		return;
	}
	var urlnm="../viwer/viewer_ready_n.asp?order_mast_idx=<%=request("order_mast_idx")%>&gbn=" + keynm + "&plidx=" + intUnm;
	var sFeatures = "width=980,height=560,top=0,left=0,scrollbars=no,resizable=no,titlebar=no";
	var k = window.open(urlnm, "viewpg", sFeatures);
	k.focus();
}
function quiz_pop(idx)
{ 
window.open('../quiz/quiz.asp?gu=dan&idx='+ idx,'quiz_window','height=100,width=100,scrollbars=yes');
} 
</script>

<!-- #include file="../include/top.asp" -->

<div class="smain">    
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3><%=strnm%></h3>
        </div>
        <div class="scont">

		<table class="btbl" style="width:830px">
					<colgroup>
						<col style="width:10%" />
						<col style="width:30%" />
						<col style="width:10%" />
						<col style="width:10%" />
						<col style="width:40%" />
					</colgroup>
					<thead>
						<tr>
							<th>회차</th>								
							<th>강의명</th>
							<th>진도현황</th>
							<th>강의시간</th>
							<th>강의보기</th>
						</tr>				
					</thead>
					<tbody>
<%
sql = "select idx,strnm,ordnum,strtime,lecsum,lecsrc,freegbn,mckey,movlink,movlink1,freelink,isnull(dbo.function_quiz_munje_count(idx),0),dbo.function_view_mast_check1('"& str_User_ID &"',idx),dbo.function_view_mast_check2('"& str_User_ID &"',idx),dbo.function_view_mast_check3('"& str_User_ID &"',idx),dbo.function_view_mast_check4('"& str_User_ID &"',idx) from sectionTab where l_idx=" & idx & " order by ordnum"
set dr = db.execute(sql)

If dr.eof Or dr.bof Then
Else
ii = 0
Do Until dr.eof

check_time1 = 0
step_check(ii+1) = 0

If step_check_gu = 0 Then step_check(ii) = 1

quiz_count = dr(11)
v_time = dr(12)
v_date = dr(13)
end_check = dr(15)

check_time  = split(dr(3),":")
check_time1 = (int(check_time(0)) * 60) + int(check_time(1))

If end_check = 0 then

	If v_time > 0 then		  

		v1 = v_time 
		h = (int)(v1 / 3600)
		if len(h) = 1 then	h = "0"& h &""
		v1 = v1 mod 3600
		m = (int)(v1 / 60)

		if len(m) = 1 then	m = "0"& m &""
		s = v1 mod 60  

		if len(s) = 1 then	s = "0"& s &""

	End If

End If


If end_check > 0  Then step_check(ii+1) = 1
%>
				<tr>
					<td><%=ii+1%>회</td>
					<td class="tl"><%=dr(1)%></td>
					<td><%If end_check > 0  Then%>수강완료<%else%><%if v_time > 0 then response.write ""& replace(v_date,"-",".") &"<br>("& h &":"& m &":"& s &")" else response.write"미수강" end if%><%End if%></td>
					<td><%=dr(3)%></td>

<%If step_check(ii) = 1 then%>

					<td>
					<% if Len(dr(7)) = 0 and Len(dr(8)) = 0 then %>
					<% else %>
					<%If Len(player1_check) > 0 then%><a href="javascript:go2ViewerPlay(<%=strProg%>,'<%=dr(0)%>','wmv');" class="mmminii">강의보기#1</a><%End if%> 
					<%If Len(player2_check) > 0 then%><a href="javascript:go2ViewerPlay_n(<%=strProg%>,'<%=dr(0)%>','wmv');" class="mmminii">강의보기#2</a><%End if%>
					<%If Len(player3_check) > 0 then%><a href="javascript:go2ViewerPlay_n(<%=strProg%>,'<%=dr(0)%>','kollus');" class="mmminii">강의보기#3</a><%End if%>
					<% end if %>					

					<%if (end_check > 0 or int(v_time)  >= int(check_time1)) and quiz_count > 0 then%><a href="javascript:quiz_pop(<%=quiz_count%>);" class="mmmini">시험보기</a><%end if%>
					<% if dr(10) = "" then %><% else %><a href="javascript:go2ViewerPlay(<%=strProg%>,'<%=dr(0)%>','free');" class="mmmini">일반보기</a><% end if %>
					<% if Len(dr(4)) > 0 then %><a href="<%=dr(4)%>" target="_blank" class="mmmini">자료#1</a><% end if %>
					<% if Len(dr(5)) > 0 then %><a href="<%=dr(5)%>" target="_blank" class="mmmini">자료#2</a><% end if %></td>	

<%else%>
					<td><%=ii%>회차 강좌를 수강완료해주세요.</td>
<%End if%>
				</tr>	

<%
	dr.movenext
	ii = ii + 1
	Loop
	dr.close

End if
%>
					</tbody>
				</table>

			<div class="rbtn">
<%
sql = "select top 1 idx from quiz_munje where ca1 = "& idx &" and ca2 = 0 order by idx desc"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
	Response.write "<a href=""javascript:quiz_pop("& rs(0) &");"" class=""mbtn blue"">시험보기</a>"
rs.close
End If
%>
				<a href="01_main.asp" class="mbtn">돌아가기</a> <%
sql = "select count(idx) from lec_reply where vidx = "& idx &" and id = '"& str_User_ID &"'"
Set rs=db.execute(sql)

If rs(0) = 0 then

	response.write"<a href=""reply_write.asp?idx="& request("idx") &"&repage=01_buy_dan_view"" class=""mbtn red"">수강후기</a>"

rs.close
End if
%>
			</div>


        </div>
    </div>
</div>
<!-- #include file="../include/bottom.asp" -->
<% else %>
<!-- #include file="../include/false_pg.asp" -->
<% end if %>