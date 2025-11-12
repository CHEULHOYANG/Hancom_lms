<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%

dim sql,rs,cid

cid = "c_"& year(date) & month(date) & day(date) & hour(time) & minute(time) &second(time) &""
%>

<html>
<head>
<title>일정등록</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="imagetoolbar" content="no" />
<link rel="stylesheet" href="../rad_img/pop.css" type="text/css">
<script type="text/javascript"> window.top.document.title = document.title </script>
<script type='text/javascript'>var domain = "http://"+document.domain+"/"</script>

<script language="javascript">
function cal_write() 
{ 

	var ssday = cal_form.sdate;
	var eeday = cal_form.edate;
	var now = new Date();
	var startDay,endDay;

	strAry = ssday.value.split("-");
	startDay = now.setFullYear(strAry[0],strAry[1],strAry[2]);

	strAry = eeday.value.split("-");
	endDay = now.setFullYear(strAry[0],strAry[1],strAry[2]);

	if(endDay < startDay){
		alert("일정기간이 잘못되었습니다.");
		ssday.select();
		return;
	}


 		if (document.cal_form.title.value == "" ) {
                alert("제목을 입력해주세요.");
                document.cal_form.title.focus();
				return;
        }
		 if (document.cal_form.content.value == "" ) {
                alert("내용을 입력해주세요.");
                document.cal_form.content.focus();
				return;
        }
		document.cal_form.submit();
        
}
</script>
</head>

<body>

<div class="laypop">
	<div class="lay_tit">
		<h2>일정 작성하기</h2>
		<a href="javascript:self.close();" class="btn_close"><img src="../rad_img/img/btn_close.png" alt="창닫기" /></a>
	</div>
	<div class="lay_cont">
<form name="cal_form" method="post" action="calender_write_ok.asp">
<input type="hidden" name="sid" value="<%=request("sid")%>">
<input type="hidden" name="cid" value="<%=cid%>">
		<div class="write_box">
			
			<select name="gu" class="seltxt">
					<option value="0">구분선택없음</option>
<%
		sql="select idx,title,bg_color,font_color from cal_gu_mast where sid = '"& request("sid") &"' order by ordnum asc,idx desc"
		set rs=db.execute(sql)
		if rs.eof or rs.bof then
		else
		do until rs.eof
%>					
                      <option value="<%=rs(0)%>" style="background-color:<%=rs(2)%>;font-size:8pt; color:<%=rs(3)%>;letter-spacing:-1px;"><%=rs(1)%></option>
<%
rs.movenext
loop
rs.close
end if
%>					  
            </select> <input class="inptxt" id="sdate" value="<%=request("check_date")%>" name="sdate" readonly style="width:110px" /> ~ <input class="inptxt" id="edate" value="<%=request("check_date")%>" name="edate" readonly style="width:110px" />
			<br /><p style="height:5px"></p>
			<input name="title" type="text" class="inptxt" id="title" style="width:97%;" placeholder="일정제목">
			<br /><p style="height:5px"></p>
			<textarea name="content" id="content" cols="45" rows="5" placeholder="일정내용"></textarea>			
		</div>
</form>
		<div class="btn_wrap">
			<a href="javascript:cal_write();" class="btn_pop">저장하기</a>
		</div>
	</div>		
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->

<link rel="stylesheet" href="../../include/pikaday.css">
<script src="../../include/moment.js"></script>
<script src="../../include/pikaday.js"></script>

<script>
    var picker = new Pikaday(
    {
        field: document.getElementById('sdate'),
        firstDay: 1,
		format: "YYYY-MM-DD",
        minDate: new Date('<%=left(date(),4)-10%>-01-01'),
        maxDate: new Date('<%=left(date(),4)+10%>-12-31'),
        yearRange: [<%=left(date(),4)%>,<%=left(date(),4)+10%>]
    });
    var picker1 = new Pikaday(
    {
        field: document.getElementById('edate'),
        firstDay: 1,
		format: "YYYY-MM-DD",
        minDate: new Date('<%=left(date(),4)-10%>-01-01'),
        maxDate: new Date('<%=left(date(),4)+10%>-12-31'),
        yearRange: [<%=left(date(),4)%>,<%=left(date(),4)+10%>]
    });
</script>