var Els;
var DP_now				= new Date();
var DP_year			= DP_now.getFullYear();
var DP_month	= DP_now.getMonth();
var thisMonth	= "<a href='javascript:DP_print_cal(" + DP_year	 + "," + DP_month + ")' class=DPwhite><font color=white>이번달 (" + DP_year + "-" + (DP_month+1) + ")</font></a>";

function DP_start(){

	var tmp = "<style>\
	.DP {font:8pt tahoma}\
	.DPlink {font:8pt tahoma;text-decoration: none;color:#000000}\
	.DPlink:hover {font:8pt tahoma;text-decoration: none;color:#006697}\
	.DPwhite {font:8pt tahoma;text-decoration: none;color:#ffffff;width:30;text-align:center}\
	.DPwhite:hover {font:8pt tahoma;text-decoration: none;color:#ffffff}\
	</style>\
	<table id=frm border=1 bordercolor=#000000 style='border-collapse:collapse' cellpadding=0 cellspacing=0 bgcolor=#ffffff><tr><td>\
	<table width=100% cellpadding=0 cellspacing=0>\
	<form>\
	<tr height=25 bgcolor=#08246B>\
		<td><a href='javascript:DP_direc(-1)' onfocus=blur() class=DPwhite><font color=white>◀</font></a></td>\
		<td nowrap>\
			<select name=yearS id=yearS onChange=DP_chg_date()></select>\
			<select name=monthS id=monthS onChange=DP_chg_date()>\
			<option value=0> 1월\
			<option value=1> 2월\
			<option value=2> 3월\
			<option value=3> 4월\
			<option value=4> 5월\
			<option value=5> 6월\
			<option value=6> 7월\
			<option value=7> 8월\
			<option value=8> 9월\
			<option value=9> 10월\
			<option value=10> 11월\
			<option value=11> 12월\
			</select>\
		</td>\
		<td><a href='javascript:DP_direc(1)' onfocus=blur() class=DPwhite><font color=white>▶</font></a></td>\
	</tr>\
	</form>\
	<tr>\
		<td colspan=3>\
		<table id=oTable width=100%>\
			<tr class=DP>\
				<th style='color:red'>S</th>\
				<th>M</th>\
				<th>T</th>\
				<th>W</th>\
				<th>T</th>\
				<th>F</th>\
				<th>S</th>\
			</tr>\
			<tbody align=center></tbody>\
		</table>\
		</td>\
	</tr>\
	<tr>\
		<td colspan=3 bgcolor=#08246B>\
		<table width=100%>\
			<tr>\
				<td nowrap id=todayZ>\
				</td>\
				<td align=right>\
				<a href='javascript:DP_hidden()' class=DPwhite><font color=white>close</font></a>\
				</td>\
			</tr>\
		</table>\
		</td>\
	</tr>\
	</table>\
	</td></tr></table>";
	document.write("<div id=calendar style='position:absolute;left:-999px;display:inline'>"+tmp+"</div>");
	DP_print_cal(DP_year,DP_month);
}

function DP_get_lastDate(year,month){
	var leap;
	var last = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
	if (year%4==0)		leap = true;
	if (year%100==0)	leap = false;
	if (year%400==0)	leap = true;
	if (leap) last[1] = 29;
	return last[month];
}

function DP_get_firstDay(year,month){
	var ici	= new Date(year,month);
	return ici.getDay();
}

function DP_print_cal(year,month){

	DP_del();
	DP_year = year;
	DP_month = month;
	todayZ.innerHTML = thisMonth;

	document.forms[0].yearS.length = 7;
	for (i=0;i<7;i++){
		document.forms[0].yearS.options[i].value = year - 3 + i;
		document.forms[0].yearS.options[i].text = year - 3 + i + "년";
	}
	document.forms[0].yearS.selectedIndex = 3;
	document.forms[0].monthS.selectedIndex = month;

	var firstDay = DP_get_firstDay(year,month);
	var lastDate = DP_get_lastDate(year,month);
	var cnt = 0;
	if (firstDay){
		oTr = oTable.insertRow();
		for (i=0;i<firstDay;i++) oTr.insertCell();
		cnt = i;
	}
	for (i=0;i<lastDate;i++){
		if (cnt%7==0) oTr = oTable.insertRow();
		oTd = oTr.insertCell();
		oTd.style.backgroundColor = "#f7f7f7";	
		oTd.innerHTML = (DP_now.getFullYear()==year && DP_now.getMonth()==month && DP_now.getDate()==i+1) ? "<table width=100% height=100% border=1 bordercolor=#000000 style='border-collapse:collapse'><tr><td align=center bgcolor=#ffffff><a href=\"javascript:DP_set(" + year + "," + (month+1) + "," + (i+1) +")\" class=DPlink><b>" + (i+1) + "</b></a></td></tr></table>" : "<a href=\"javascript:DP_set(" + year + "," + (month+1) + "," + (i+1) +")\" class=DPlink>" + (i+1) + "</a>";
		cnt++;
	}
}

function DP_del(){ 
    for (i=oTable.rows.length;i>1;i--) oTable.deleteRow(i-1); 
}

function DP_direc(x){
	DP_month = DP_month + x;
	if (DP_month>11){
		DP_month = DP_month - 12;
		DP_year++;
	} else if (DP_month<0){
		DP_month = DP_month + 12;
		DP_year--;
	}
	DP_print_cal(DP_year,DP_month);
}

function DP_set(year,month,date){
	if (month<10) month = "0" + month;
	if (date<10) date = "0" + date;
	Els.value = year + "-" + month + "-" + date;
	DP_hidden();
}

function get_objectTop(obj){
	if (obj.offsetParent == document.body) return obj.offsetTop;
	else return obj.offsetTop + get_objectTop(obj.offsetParent);
}

function get_objectLeft(obj){
	if (obj.offsetParent == document.body) return obj.offsetLeft;
	else return obj.offsetLeft + get_objectLeft(obj.offsetParent);
}

function DP_use(El){	
	show_elements("select", calendar);
	Els = El;
	document.all.calendar.style.pixelTop = document.body.clientTop + get_objectTop(El) + El.offsetHeight;
	document.all.calendar.style.pixelLeft = document.body.clientLeft + get_objectLeft(El);
	document.all.calendar.style.display = "inline";
	hide_elements("select", calendar);
}

function DP_hidden(){
	show_elements("select", calendar);
	document.all.calendar.style.display = "none";
}

function DP_chg_date(){
	DP_year = parseInt(document.forms[0].yearS.value);
	DP_month = parseInt(document.forms[0].monthS.value);
	DP_print_cal(DP_year,DP_month);
}

function hide_elements(tagName, menu){
	windowed_element_visibility(tagName, -1, menu)
}

function show_elements(tagName, menu){
	windowed_element_visibility(tagName, +1, menu)
}

function windowed_element_visibility(tagName, change, menu){
	var els = document.getElementsByTagName(tagName);
	var rect = new element_rect(menu)
	for (i=0; i < els.length; i++){
		var el = els.item(i);
		if (elements_overlap(el, rect)){
			if (change==-1){
				if (el.name!='yearS' && el.name!='monthS') el.style.visibility = "hidden";
			} else el.style.visibility = "visible";
		}
	}
}

function element_rect(el){
	var left = 0
	var top = 0
	this.width = el.offsetWidth
	this.height = el.offsetHeight
	while (el){
		left += el.offsetLeft
		top += el.offsetTop
		el = el.offsetParent
	}
	this.left = left;
	this.top = top;
}

function elements_overlap(el, rect){
	var r = new element_rect(el);
	return ((r.left < rect.left + rect.width) && (r.left + r.width > rect.left) && (r.top < rect.top + rect.height) && (r.top + r.height > rect.top))
}