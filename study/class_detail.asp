<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<%
Dim dntGbn : dntGbn = request("dntGbn")
Dim dntNm
Dim idx,intpg,lidx
Dim v_time,rs,v_date,time1,time2
dim v1,h,m,s
Dim icon,icon_count,jj
Dim check_time,check_time1,quiz_count,i,end_check
Dim ca1_name,ca2_name
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
intpg = request("intpg")
lidx = request("lidx")

dim strnm,strteach,tinfo,intprice,intgigan,totalnum,sajin,bcod,step_check_gu,dan_ca1,dan_ca2,sub_title,book_idx

sql = "select strnm,strteach,intprice,intgigan,totalnum,sjin=case sajin when 'noimg.gif' then 'noimage.gif' else sajin end,categbn,icon,tinfo,step_check,ca1,ca2,sub_title,book_idx from LecturTab where idx=" & lidx
set dr = db.execute(sql)

If dr.eof Or dr.bof Then

	Response.write"<script>"
	Response.write"alert('DB에러');"
	Response.write"history.back();"
	Response.write"</script>"
	Response.End
	
Else

	strnm = dr(0)
	strteach = dr(1)
	intprice = dr(2)
	intgigan = dr(3)
	totalnum = dr(4)
	sajin = dr(5)
	bcod = dr(6)
	icon = dr(7)
	tinfo = dr(8)
	step_check_gu = dr(9)
	dan_ca1 = dr(10)
	dan_ca2 = dr(11)
	sub_title = dr(12)
	book_idx = dr(13)

dr.close
End if

sql = "select count(idx) from sectionTab where l_idx=" & lidx
set dr = db.execute(sql)

totalnum = dr(0)
dr.close


''***********************************************************************************************************************
''수강 중인지 체크
Dim precheck : precheck = 0
Dim dancheck : dancheck = 0

if isUsr then

	''프리미엄 강좌를 듣는지 체크

	Dim order_mast_idx

	sql = "select top 1 idx from order_mast where id='" & str_User_ID & "' and buygbn = 0 and DateDiff(day,GetDate(),sday) <=0 and DateDiff(day,GetDate(),eday) >= 0 and state=0 and holdgbn=0 order by idx desc"
	set dr = db.execute(sql)

	If dr.eof Or dr.bof Then
		order_mast_idx = 0
	else
		order_mast_idx = dr(0)
	dr.close
	End if

	Dim primcnt
	sql = "select count(idx) from order_mast where id='" & str_User_ID & "' and buygbn = 0 and DateDiff(day,GetDate(),sday) <=0 and DateDiff(day,GetDate(),eday) >= 0 and state=0 and holdgbn=0"
	set dr = db.execute(sql)
	primcnt = dr(0)
	dr.close

	if int(primcnt) > 0 then
		precheck = 1
	else

		''수강하는 과정 속에 포함된 단과 추출
		dim dancnt
		sql = "select count(idx) from order_mast where id='" & str_User_ID & "' and state=0 and  buygbn=1 and tabidx in (select mastidx from LectAry where lectidx=" & lidx & ")"
		set dr = db.execute(sql)
		dancnt = dr(0)
		dr.close

		if int(dancnt) > 0 then
			dancheck = 1
		else

			dim ddn
			sql = "select count(idx) from order_mast where id='" & str_User_ID & "' and state=0 and buygbn=2 and tabidx=" & lidx
			set dr = db.execute(sql)
			ddn = dr(0)
			dr.close

			if int(ddn) > 0 then
				dancheck = 1
			end if

		end if

	end if

end if
''***********************************************************************************************************************

Dim step_check(100000)

step_check(0) = 1
%>
<!-- #include file="../include/head1.asp" -->

<script language="javascript">
function go2ViewerPlay(flg,intUnm,keynm){
	if(flg){
		alert("로그인 하신 후 이용하세요!");
		return;
	}
<%If precheck = 1 Or dancheck = 1 Then%>
	var urlnm="/viwer/viewer_ready1.asp?order_mast_idx=<%=order_mast_idx%>&gbn=" + keynm + "&plidx=" + intUnm;
	var sFeatures = "width=980,height=560,top=0,left=0,scrollbars=no,resizable=no,titlebar=no";
	var k = window.open(urlnm, "viewpg", sFeatures);
	k.focus();
<%else%>
		alert("수강권한이 없거나 휴학중인 강좌입니다!");
		return;
<%end if%>
}
function go2ViewerPlay_n(flg,intUnm,keynm){
	if(flg){
		alert("로그인 하신 후 이용하세요!");
		return;
	}
<%If precheck = 1 Or dancheck = 1 Then%>
	var urlnm="/viwer/viewer_ready1_n.asp?order_mast_idx=<%=order_mast_idx%>&gbn=" + keynm + "&plidx=" + intUnm;
	var sFeatures = "width=980,height=560,top=0,left=0,scrollbars=no,resizable=no,titlebar=no";
	var k = window.open(urlnm, "viewpg", sFeatures);
	k.focus();
<%else%>
		alert("수강권한이 없거나 휴학중인 강좌입니다!");
		return;
<%end if%>
}
function viewSample1(flg,intUnm,sidx){
	if(flg){
		alert("로그인 하신 후 이용하세요!");
	}else{
		var urlnm="/viwer/dan_sample.asp?vtype=dan&plidx=" + intUnm +"&sidx="+sidx;
		var sFeatures = "width=980,height=560,top=0,left=0,scrollbars=no,resizable=no,titlebar=no";
		var k = window.open(urlnm, "viewpg", sFeatures);
		k.focus();
	}
}
function quiz_pop(idx)
{ 
window.open('../quiz/quiz.asp?idx='+ idx,'quiz_window','height=100,width=100,scrollbars=yes');
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

				<table class="ftbl" style="width:830px">
                    <colgroup>
                    <col style="width:15%" />
                    <col style="width:35%" />
                    <col style="width:15%" />
					<col style="width:35%" />
                    </colgroup>
                    <thead>

							<tr>
								<th>강사</th>
								<td><%=strteach%></td>
								<th>강좌구성</th>
								<td><%=totalnum%>강</td>
							</tr>
							<tr>
								<th>수강료</th>
								<td><span class="fr"><%=formatnumber(intprice,0)%>원</span></td>
								<th>수강기간</th>
								<td><%=intgigan%>일</td>
							</tr>

<%
Dim bcount,book_pop
				
				book_pop = book_idx
				book_idx = split(book_idx,",")
				bcount = ubound(book_idx)

	If bcount > 0 then
%>
                        <tr>
                            <th>관련교재</th>
                            <td colspan="3"><%

		For i = 1 To bcount

				sql = "select price1,title,idx from book_mast where state = 0 and idx = "& book_idx(i)
				Set rs=db.execute(sql)

				If rs.eof Or rs.bof Then
				bcount = bcount - 1
				else
%><strong><a href="/book/content.asp?idx=<%=rs(2)%>" target="_blank"><%=rs(1)%></a></strong><br /><%
				rs.close
				End if
		Next

response.write"* 해당 과정에 관련된 교재목록입니다. 참고해서 구매하시면 좋습니다."
%></td>
                        </tr>
<%
	End if
%>

                    </thead>
                    <tbody>
                    </tbody>
                </table>

			</div>	

			<div class="rbtn">
				<a href="class_view.asp?idx=<%=idx%>&categbn=<%=categbn%>" class="mbtn">이전으로</a>
<%If precheck = 1 Then

sql = "select top 1 idx from quiz_munje where ca1 = "& idx &" and ca2 = 0 order by idx desc"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
	Response.write "<a href=""javascript:quiz_pop("& rs(0) &");"" class=""mbtn red"">시험보기</a>"
rs.close
End If

End if%>
			</div>

<%
If precheck = 1 Or dancheck = 1 Then
Else
%>
            <h3 class="stit">강좌설명</h3>
            <ul class="detail">
					<li><%=tinfo%></li>
			</ul>
<%End if%>

            <h3 class="stit">강좌구성</h3>
            <table class="btbl" style="width:830px">
					<colgroup>
<%If precheck = 1 Or dancheck = 1 then%>
						<col style="width:10%" />
						<col style="width:40%" />
						<col style="width:10%" />
						<col style="width:40%" />
<%else%>
						<col style="width:10%" />
						<col style="width:62%" />
						<col style="width:13%" />
						<col style="width:15%" />
<%End if%>
					</colgroup>
					<thead>
						<tr>
<%If precheck = 1 Or dancheck = 1 then%>
							<th>회차</th>								
							<th>강좌명</th>
							<th>강좌시간</th>
							<th>강좌보기</th>
<%else%>
							<th>회차</th>								
							<th>강좌명</th>
							<th>강좌샘플</th>
							<th>강좌시간</th>
<%End if%>
						</tr>				
					</thead>
					<tbody>
<%
sql = "select idx,strnm,ordnum,strtime,lecsum,lecsrc,freegbn,mckey,movlink,movlink1,freelink,isnull(dbo.function_quiz_munje_count(idx),0),dbo.function_view_mast_check1('"& str_User_ID &"',idx),dbo.function_view_mast_check2('"& str_User_ID &"',idx),dbo.function_view_mast_check3('"& str_User_ID &"',idx),dbo.function_view_mast_check4('"& str_User_ID &"',idx) from sectionTab where l_idx=" & lidx & " order by ordnum"
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

If end_check > 0 Then step_check(ii+1) = 1

If precheck = 1 Or dancheck = 1 then%>
				<tr>
					<td><%=ii+1%>회</td>

					<td class="tl"><%=dr(1)%></td>

					<td><%=dr(3)%><br /><%If end_check > 0  Then%>(수강완료)<%else%><%if v_time > 0 then response.write "("& h &":"& m &":"& s &")" else response.write"(미수강)" end if%><%End if%></td>

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
<%else%>
				<tr>
					<td><%=ii+1%>회</td>
					<td class="tl"><%=dr(1)%></td>
					<td><%If dr(6) = 1 Then%><a href="javascript:viewSample1(<%=strProg%>,'<%=idx%>','<%=dr(0)%>');" class="sbtn">맛보기</a><%End if%></td>
					<td><%=dr(3)%></td>					
				</tr>		
<%
End if

	dr.movenext
	ii = ii + 1
	Loop
	dr.close

End if
%>
					</tbody>
				</table>

            <h3 class="stit">수강후기</h3>
            <table class="btbl" style="width:830px">
					<colgroup>
						<col style="width:10%" />
						<col style="width:55%" />
						<col style="width:15%" />
						<col style="width:10%" />
						<col style="width:10%" />
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>								
							<th>후기</th>
							<th>평점</th>
							<th>작성자</th>
							<th>등록일</th>		
						</tr>				
					</thead>
					<tbody>
<%
sql = "select idx,id,name,content,regdate,star from lec_reply where vidx = "& lidx
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
i=1
Do Until rs.eof
%>
				<tr>
					<td><%=i%></td>
					<td class="tl"><%If Len(rs(3)) > 140 then%><%=cutstr(rs(3),140)%>&nbsp;&nbsp;<a href="#" onclick="layer_open('layer2',<%=rs(0)%>);return false;"><font color='#cc0000'>[더보기]</font></a><%else%><%=replace(rs(3),chr(13) & chr(10),"<br>")%><%End if%></td>
					<td><img src="../img/img/<%=rs(5)%>.png" ></td>
					<td><%=Left(rs(2),1)%>**</td>
					<td><%=Replace(Left(rs(4),10),"-",".")%></td>
				</tr>
<%
rs.movenext
i=i+1
Loop
rs.close
End if
%>
					</tbody>
				</table>

		<div class="rbtn"><%
sql = "select count(idx) from lec_reply where vidx = "& request("idx") &" and id = '"& str_User_ID &"'"
Set rs=db.execute(sql)

If rs(0) = 0 then

	response.write"<a href=""javascript:go2Logpg1("& strProg &",'reply_write.asp?categbn="&  request("categbn") &"&vcat="& bcod &"&idx="& request("idx") &"&lidx="& request("lidx") &"&vidx="&  request("lidx") &"&intpg="& request("intpg") &"&repage=class_detail');"" class=""mbtn red"">수강후기작성</a>"


rs.close
End if
%></div>

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
			url: "../xml/reply_view.asp",
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
<%
Function cutStr(str, cutLen)
	Dim strLen, strByte, strCut, strRes, char, i
	strLen = 0
	strByte = 0
	strLen = Len(str)
	for i = 1 to strLen
		char = ""
		strCut = Mid(str, i, 1)
		char = Asc(strCut)
		char = Left(char, 1)
		if char = "-" then
			strByte = strByte + 2
		else
			strByte = strByte + 1
		end if
		if cutLen < strByte then
			strRes = strRes & ".."
			exit for
		else
			strRes = strRes & strCut
		end if
	next
	cutStr = strRes
End Function
%>