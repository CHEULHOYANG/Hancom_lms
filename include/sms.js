function direct_send(){
	var f = window.document.emoticon_form;
	if (f.message.value == ""  )	{
	alert("메시지 내용을 입력해주세요!!");
	f.message.focus();
	return;
	}
	f.submit();
}
function CheckLen1() {

	document.sms_config.content_length1.value = document.sms_config.msg1.value.length ;	
}
<!--
var R_DAY_MSG				= "예약하실 수 없는 날짜입니다.";
var R_DAY_NULL_MSG			= "예약 날짜를 입력하지 않았습니다.";
var R_DAY_TYPE_MSG			= "날짜 형식이 맞지 않습니다.";
var R_TIME_NULL_MSG			= "예약 시간을 입력하지 않았습니다.";
var R_TIME_TYPE_MSG			= "시간 형식이 맞지 않습니다.";
var R_TIME_MSG				= "예약하실 수 없는 시간입니다.";
var CONTENT_MSG				= "메시지 내용이 없습니다.";
var SVC_NUM_MSG				= "수신 전화번호가 없습니다. 입력해 주세요.";
var PHON_NUM_MSG			= "발신 전화번호가 없습니다. 입력해 주세요.";
var PHON_CD_MSG				= "발신 국번이 없습니다.";
var REGIST_80_BYTE			= "80바이트까지만 등록이 가능합니다.";
var CONTNET_80_BYTE_MSG		= "메시지 입력은 80바이트까지만 가능합니다.";
var CONT_SVC_NUM_MSG		= "전화 번호가 없습니다.";
var LENGTH_MSG				= "전화번호가 잘못되었습니다. 다시 입력해 주세요.";
var REMOVE_MSG				= "메시지를 삭제하시겠습니까?";
var Msg_Null				= "메시지 내용이 없습니다.";
var NO_SELECT_BEFORE_DAY	= "과거일자로는 예약하실 수 없습니다.";
var NO_DAY					= "없는 날짜 입니다.";
var BYTE_30					= "30바이트 까지 입력이 가능합니다";
var NO_NUMBER_RE_INPUT		= "없는 번호입니다. 다시 입력해 주세요";
var NULL_MSG				= "";
var TOG_WORD				= '%0D';
var MSG_LEN_80				= 80;										//메시지 길이
var MSG_LEN_2000			= 2000;										//장문에서 메시지 길이
var m_iFlag					= 1;
var c_iFlag					= 1;

//처음 창을 클릭할시 창을 지운다.
function clearContent() {
	if (m_iFlag == 1) {
		document.telephone_frm.CONTENT.value="";
//		checkShrtMsgLen(document.frmsms.CONTENT,"SHORT");
		m_iFlag=0;
	}
}
//처음 창을 클릭할시 창을 지운다.(영렬이가필요해서)
function clearContent1() {
	if (c_iFlag == 1) {
		document.telephone_frm.CONTENT1.value="";
//		checkShrtMsgLen(document.frmsms.CONTENT,"SHORT");
		c_iFlag=0;
	}
}
//스트링값을 받아서 바이트 수를 체크한다.
function getLeng(sMessage) {
	var iCount = 0 ;													//메시지의 바이트를 저장하는 변수
	for (var i = 0; i < sMessage.length; i++) {							// 0-127 1byte, 128~ 2byte
		if ( sMessage.charCodeAt(i) > 127) {
			iCount += 2;
		}
		else {
			iCount++;
		}
	}
	return iCount;
}
//메시지창에 메시지를 넣어 주는 함수
function setMsgToContent(obj) {

	var sMsg = obj.value;
	clearContent();
	document.telephone_frm.CONTENT.value = sMsg;
//	checkShrtMsgLen(document.telephone_frm.CONTENT,"SHORT");
//	document.telephone_frm.CONTENT.focus();
	self.scroll(0,0);
	checkShrtMsgLen(obj,'SHORT');
}
//메시지창에 메시지를 넣어 주는 함수2
function setMsgToContent(obj,Sms_id) {

	var sMsg = obj.value;
	clearContent();
	document.telephone_frm.CONTENT.value = sMsg;
//	checkShrtMsgLen(document.telephone_frm.CONTENT,"SHORT");
//	document.telephone_frm.CONTENT.focus();
	setCookie('SMS_VALUE', Sms_id, 5);
	self.scroll(0,0);
	checkShrtMsgLen(obj,'SHORT');
}

// cookie 관련 함수
function setCookie(name, value, minutes) {
   var expire = new Date();
   expire.setTime(expire.getTime() + (60*minutes*1000));
   document.cookie = name + "=" + escape(value)
   + ((expire == null) ? "" : ("; expires=" + expire.toGMTString()))
}

function getCookie(Name) {
   var search = Name + "="
   if (document.cookie.length > 0) { 
      offset = document.cookie.indexOf(search) 
      if (offset != -1) { 
         offset += search.length 
         end = document.cookie.indexOf(";", offset) 
         if (end == -1) 
            end = document.cookie.length
         return unescape(document.cookie.substring(offset, end))
      } 
   }
}

//변수의 길이를 체크하여 80byte가 넘으면 길이를 잘라준다.
function checkMsgLen(obj,sByteLen) {
	var iCounts = new Array();
	iCounts = getByteLen(obj);											//변수의 길이를 구하는 함수
	if (iCounts[0] > sByteLen)
		return false;
	else
		return true;
}

//단문메시지에서 메시지의 길이를 체크하고 짜르는 함수
function checkShrtMsgLen(obj,sAlertType) {
	var bResult		= checkMsgLen(obj,MSG_LEN_80);
	var iCountByte	= 0;
	var sContentMsg	= '';

	if (!bResult){
		if (sAlertType == 'SHORT') {
			alert(CONTNET_80_BYTE_MSG);
			sContentMsg = cutText(obj,MSG_LEN_80);
			obj.value = sContentMsg;
		}
		else if (sAlertType == 'SCH') {
			alert(CONTNET_80_BYTE_MSG);
			sContentMsg = cutText(obj,MSG_LEN_80);
			obj.value = sContentMsg;
		}
		else {
			alert(REGIST_80_BYTE);
			sContentMsg = cutText(obj,MSG_LEN_80);
			document.frmsms.CONTENT.value = sContentMsg;
		}
	}
	iCountByte = getByteLen(obj);
	if (sAlertType == 'SCH') {
		document.frmsms.COUNTBYTE1.value = iCountByte[0];
		document.frmsms.COUNTBYTE2.value = iCountByte[0];
	}
	else
		document.telephone_frm.COUNTBYTE.value = iCountByte[0];
}

//단문메시지에서 메시지의 길이를 체크하고 짜르는 함수(영렬이가필요해서)
function checkShrtMsgLen1(obj,sAlertType) {
	var bResult		= checkMsgLen(obj,MSG_LEN_80);
	var iCountByte	= 0;
	var sContentMsg	= '';

	if (!bResult){
		if (sAlertType == 'SHORT') {
			alert(CONTNET_80_BYTE_MSG);
			sContentMsg = cutText(obj,MSG_LEN_80);
			obj.value = sContentMsg;
		}
		else if (sAlertType == 'SCH') {
			alert(CONTNET_80_BYTE_MSG);
			sContentMsg = cutText(obj,MSG_LEN_80);
			obj.value = sContentMsg;
		}
		else {
			alert(REGIST_80_BYTE);
			sContentMsg = cutText(obj,MSG_LEN_80);
			document.frmsms1.CONTENT.value = sContentMsg;
		}
	}
	iCountByte = getByteLen(obj);
	if (sAlertType == 'SCH') {
		document.frmsms1.COUNTBYTE1.value = iCountByte[0];
		document.frmsms1.COUNTBYTE2.value = iCountByte[0];
	}
	else
		document.telephone_frm.COUNTBYTE1.value = iCountByte[0];
}


function checkShrtMsgLen2(obj,sAlertType) {
	var bResult		= checkMsgLen(obj,MSG_LEN_80);
	var iCountByte	= 0;
	var sContentMsg	= '';

	if (!bResult){
		if (sAlertType == 'SHORT') {
			alert(CONTNET_80_BYTE_MSG);
			sContentMsg = cutText(obj,MSG_LEN_80);
			obj.value = sContentMsg;
		}
		else if (sAlertType == 'SCH') {
			alert(CONTNET_80_BYTE_MSG);
			sContentMsg = cutText(obj,MSG_LEN_80);
			obj.value = sContentMsg;
		}
		else {
			alert(REGIST_80_BYTE);
			sContentMsg = cutText(obj,MSG_LEN_80);
			document.frmsms2.CONTENT.value = sContentMsg;
		}
	}
	iCountByte = getByteLen(obj);
	if (sAlertType == 'SCH') {
		document.frmsms2.COUNTBYTE1.value = iCountByte[0];
		document.frmsms2.COUNTBYTE2.value = iCountByte[0];
	}
	else
		document.telephone_frm.COUNTBYTE2.value = iCountByte[0];
}

function checkShrtMsgLen3(obj,sAlertType) {
	var bResult		= checkMsgLen(obj,MSG_LEN_80);
	var iCountByte	= 0;
	var sContentMsg	= '';

	if (!bResult){
		if (sAlertType == 'SHORT') {
			alert(CONTNET_80_BYTE_MSG);
			sContentMsg = cutText(obj,MSG_LEN_80);
			obj.value = sContentMsg;
		}
		else if (sAlertType == 'SCH') {
			alert(CONTNET_80_BYTE_MSG);
			sContentMsg = cutText(obj,MSG_LEN_80);
			obj.value = sContentMsg;
		}
		else {
			alert(REGIST_80_BYTE);
			sContentMsg = cutText(obj,MSG_LEN_80);
			document.frmsms3.CONTENT.value = sContentMsg;
		}
	}
	iCountByte = getByteLen(obj);
	if (sAlertType == 'SCH') {
		document.frmsms3.COUNTBYTE1.value = iCountByte[0];
		document.frmsms3.COUNTBYTE2.value = iCountByte[0];
	}
	else
		document.telephone_frm.COUNTBYTE3.value = iCountByte[0];
}

function checkShrtMsgLen4(obj,sAlertType) {
	var bResult		= checkMsgLen(obj,MSG_LEN_80);
	var iCountByte	= 0;
	var sContentMsg	= '';

	if (!bResult){
		if (sAlertType == 'SHORT') {
			alert(CONTNET_80_BYTE_MSG);
			sContentMsg = cutText(obj,MSG_LEN_80);
			obj.value = sContentMsg;
		}
		else if (sAlertType == 'SCH') {
			alert(CONTNET_80_BYTE_MSG);
			sContentMsg = cutText(obj,MSG_LEN_80);
			obj.value = sContentMsg;
		}
		else {
			alert(REGIST_80_BYTE);
			sContentMsg = cutText(obj,MSG_LEN_80);
			document.frmsms4.CONTENT.value = sContentMsg;
		}
	}
	iCountByte = getByteLen(obj);
	if (sAlertType == 'SCH') {
		document.frmsms4.COUNTBYTE1.value = iCountByte[0];
		document.frmsms4.COUNTBYTE2.value = iCountByte[0];
	}
	else
		document.telephone_frm.COUNTBYTE4.value = iCountByte[0];
}

function checkShrtMsgLen5(obj,sAlertType) {
	var bResult		= checkMsgLen(obj,MSG_LEN_80);
	var iCountByte	= 0;
	var sContentMsg	= '';

	if (!bResult){
		if (sAlertType == 'SHORT') {
			alert(CONTNET_80_BYTE_MSG);
			sContentMsg = cutText(obj,MSG_LEN_80);
			obj.value = sContentMsg;
		}
		else if (sAlertType == 'SCH') {
			alert(CONTNET_80_BYTE_MSG);
			sContentMsg = cutText(obj,MSG_LEN_80);
			obj.value = sContentMsg;
		}
		else {
			alert(REGIST_80_BYTE);
			sContentMsg = cutText(obj,MSG_LEN_80);
			document.frmsms5.CONTENT.value = sContentMsg;
		}
	}
	iCountByte = getByteLen(obj);
	if (sAlertType == 'SCH') {
		document.frmsms5.COUNTBYTE1.value = iCountByte[0];
		document.frmsms5.COUNTBYTE2.value = iCountByte[0];
	}
	else
		document.telephone_frm.COUNTBYTE5.value = iCountByte[0];
}

//한글일 경우에는 2byte를 그외의 문자는 1byte로 계산하여  iCounts에 저장하여 return 해준다.
/*
// 구형 문자열 길이 구하기

function getByteLen(obj,sMsgLng) {

	var sMsg       = obj.value;
	var sTmpMsg    = '';												//메시지를 임시로 저장하는 변수
	var sTmpMsgLen = 0;													//임시로 저장된 메시지의 길이를 저장하는 변수
	var sOneChar   = '';												//한문자를 저장하는 변수
	var iCounts    = new Array();										//총 바이트와 페이지당 바이트 수를 저장하는 배열

	iCounts[0]=0;														//총 바이트를 저장 하는 변수

	if (sMsgLng != null) {
		sTmpMsg	= new String(sMsgLng);
	}
	else
		sTmpMsg	= new String(sMsg);
	sTmpMsgLen	= sTmpMsg.length;

	for (k = 0 ;k < sTmpMsgLen ;k++) {
		sOneChar = sTmpMsg.charAt(k);
		if (escape(sOneChar) == TOG_WORD) {
			iCounts[0]++;
		}
		else if (escape(sOneChar).length > 4) {
			iCounts[0] += 2;
		}
		else if (sOneChar!='\r'){
			iCounts[0]++;
		}
		else  {
			iCounts[0]++;
		}
	}

	return iCounts;
}
*/

//한글일 경우에는 2byte를 그외의 문자는 1byte로 계산하여  iCounts에 저장하여 return 해준다.
// 새로운 문자열 길이 구하기
function getByteLen(obj,sMsgLng) {

	var sMsg       = obj.value;
	var sTmpMsg    = '';												//메시지를 임시로 저장하는 변수
	var sTmpMsgLen = 0;													//임시로 저장된 메시지의 길이를 저장하는 변수
	var sOneChar   = '';												//한문자를 저장하는 변수
	var iCounts    = new Array();										//총 바이트와 페이지당 바이트 수를 저장하는 배열
	var i=0,l=0;
	var temp,lastl;

	iCounts[0]=0;														//총 바이트를 저장 하는 변수

	if (sMsgLng != null) {
		sTmpMsg	= new String(sMsgLng);
	}
	else
		sTmpMsg	= new String(sMsg);
	sTmpMsgLen	= sTmpMsg.length;

	while(i < sTmpMsgLen)
	{
		temp = sTmpMsg.charAt(i);
		
		if (escape(temp).length > 4)
			iCounts[0]+=2;
		else if (temp!='\r')
			iCounts[0]++;
		// OverFlow

		lastl = l;
		i++;
	}

	return iCounts;
}




//80바이트 이상 되면 변수의 길이를 자르는 함수
function cutText(obj,sByteLen) {

	var sTmpMsg			= '';
	var iTmpMsgLen		= 0;
	var sOneChar		= '';
	var iCount			= 0;
	var sOneCharNext	= '';

	sTmpMsg = new String(obj.value);
	iTmpMsgLen = sTmpMsg.length;

	for (var k = 0 ;k < iTmpMsgLen ; k++) {
		sOneChar = sTmpMsg.charAt(k);
		sOneCharNext = sTmpMsg.charAt(k+1);


		if (escape(sOneChar).length > 4){
			iCount+=2;

		}
		else if (sOneChar!='\r'){
			iCount++;
		}

/*
		if (escape(sOneChar) == TOG_WORD) {
			iCount++;
			if (iCount > sByteLen-1) {
				sTmpMsg = sTmpMsg.substring(0,k);
				break;
			}
		}
		else if (escape(sOneChar).length > 4) {
			iCount += 2;
		}
		else {
			iCount++;
		}

*/
		if (iCount > sByteLen) {
			sTmpMsg = sTmpMsg.substring(0,k);
			break;
		}
	}
	return sTmpMsg;
}

//자동 '-'생성
function addDash(obj) {
	var sNoDashNumber = "" ;											//'-'를 제거한 번호를 저장하는 변수
	sNoDashNumber	= removeDash(obj);
	var iLen		= getLeng(sNoDashNumber);

	if (event.keyCode != 8) {
		switch (iLen) {
			case 0:
			case 1:
			case 2:
				break;
			case 3:
			case 4:
			case 5:
			case 6:
			case 7:
				obj.value  = sNoDashNumber.substring(0,3) + "-" + sNoDashNumber.substr(3,4) ;
				break;
			case 8:
				obj.value  = sNoDashNumber.substring(0,4) + "-" + sNoDashNumber.substr(4,4) ;
				break;
			default :
				alert(NO_NUMBER_RE_INPUT);								//"없는 번호입니다. 다시 입력해 주세요"
				obj.value  = sNoDashNumber.substring(0,4) + "-" + sNoDashNumber.substr(4,4) ;
		}
	}
}


//dash를 제거한다.
function removeDash(obj) {

	var sNoDashNumber = "";												// '-'을 제거한 번호를 저장할 변수
	var i = 0;															
	
	for (i = 0; i < obj.value.length; i++) {
		if ((obj.value).charAt(i) != "-") {
			sNoDashNumber += (obj.value).charAt(i);
		}
	}

	return sNoDashNumber;
}

// 키의 입력값이 숫자값일 경우만 입력 할 수 있게해준다.
function checkOnlyNumber() {

	if ( event.keyCode == 37 || event.keyCode == 39 || event.keyCode == 46) {
		event.returnValue = true;
	}
	else {
		if (!event.shiftKey) {
			if (event.keyCode > 47) {
				if ( event.keyCode < 58){
					event.returnValue = true;
				}
				else if (event.keyCode > 95 ){
					if (event.keyCode < 106) {
						event.returnValue = true;
					}
					else
						event.returnValue = false;
				}
				else
					event.returnValue = false;
			}
			else if ( event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 32) {
				event.returnValue = true;
			}
			else
				event.returnValue = false;
		}else
			event.returnValue = false;
	}
}

// 동보전송시 select box에 여러명 전화번호 넣기
function AddCheck() {
	if(document.telephone_frm.phone_num.value.length==0) {
		alert("추가할 폰번호를 입력하세요.");
		document.telephone_frm.phone_num.focus();
		return;
	}
	if (!checkNumber(del_hipen(document.telephone_frm.phone_num.value))) {
		alert("숫자로 입력하여 주십시오.");
		document.telephone_frm.phone_num.focus();
		return;
	}
	if (document.telephone_frm.phone_num.value.length<8) {
		alert("수신번호형식이 잘못되었습니다.");
		document.telephone_frm.phone_num.focus();
		return;
	}
// tophone.sel_receive_num -> telephone_frm.phone_num
// tophone.vc_receive_code -> telephone_frm.phone_type
	var selobj = document.telephone_frm.sel_receive_num;
	var cnt = selobj.options.length;
/*
	if( cnt >= 10 ) {
		alert("동보전송은 10명까지 입니다.");
		return;
	} else {
*/
		selobj1	= document.telephone_frm.phone_type;
		selobj1_value = selobj1.options[selobj1.selectedIndex].text;
		selobj2 = document.telephone_frm.phone_num;
		selvalue = selobj1_value + '-' + selobj2.value;
		myselobj = document.telephone_frm.sel_receive_num;

		myselobj.options[myselobj.options.length] = new Option(selvalue,selvalue);	
		cnt_v = cnt + 1;
		document.telephone_frm.phone_count.value = cnt_v +" 명";
		document.telephone_frm.phone_num.focus();
		//myselobj.options[myselobj.options.length].value = selobj;	
	
		selobj2.value = '';
//	}
//	alert("24일, 25일은 전송량 폭주로 인해\n동보전송을 제한합니다."); 
//	return;
}

// 동보전송하기 위해 select box에 넣은 전화번호 지우기
function DelCheck()	{
	if(document.telephone_frm.sel_receive_num.options.length==0) {
		alert("더이상 삭제할 번호가 없습니다.");
		return;
	}
	if(document.telephone_frm.sel_receive_num.selectedIndex==-1) {
		//alert( "삭제할 번호를 선택하세오" );  		
		//첫번째부터 삭제한다.
		document.telephone_frm.sel_receive_num.options[0] = null;
	} else {
		Selindex= document.telephone_frm.sel_receive_num.selectedIndex;
		//선택번호를 리스트에서 삭제한다.
		document.telephone_frm.sel_receive_num.options[Selindex] = null;
	}
	document.telephone_frm.phone_count.value = document.telephone_frm.sel_receive_num.options.length+" 명";
}

// 숫자 check 
function checkNumber( str)
{
    for( var i=0; i < str.length; i++) {
        var ch = str.substring( i, i+1 );
        if( (ch < "0" || ch > "9") && ch != "." ) 
            return false;              
    }    
    return true;
}
function del_hipen(str) {
//	alert("변환전 = " + str)
	var len = str.length;
	var val;
	val = str.replace("-", "");
	for(var i=0 ; i < len ; i++) {
		val = val.replace("-", "");
	}
//	alert("변환후 = " + val);
	return val;
}

// 예약 전송 날자 입력하기
function Set_preengage_time(){
	f = document.telephone_frm;
	if(f.preengage.checked == true){
	today = new Date()
	f.preengage_year.value=today.getYear();
	f.preengage_month.value=today.getMonth()+1;
	f.preengage_day.value=today.getDate();
	f.preengage_hour.value=today.getHours();
	f.preengage_min.value=today.getMinutes();
	}else{
	f.preengage_year.value="";
	f.preengage_month.value="";
	f.preengage_day.value="";
	f.preengage_hour.value="";
	f.preengage_min.value="";
	}
}

// 현재시간을 디스플레이 한다.
function showtime(){
    var now = new Date()
	var year = now.getYear();
	var month = now.getMonth()+1;
	var day = now.getDate();
    var hours = now.getHours()
    var minutes = now.getMinutes()
    var seconds = now.getSeconds()
//    var timeValue = "" + ((hours > 12) ? hours - 12 : hours)
	var timeValue = ""+year+"-"+month+"-"+day+" "+hours;
    timeValue  += ((minutes < 10) ? ":0" : ":") + minutes
    timeValue  += ((seconds < 10) ? ":0" : ":") + seconds
//    timeValue  += (hours >= 12) ? " PM" : " AM"
    document.telephone_click.time.value = timeValue
//    if(timeValue == set) {alert(message);}
    timerID = setTimeout("showtime()",1000)
//    timerRunning = true
}

// 핸드폰 전송 버튼을 눌렀을때....

function telephone_submit(){
  if(login_c() == true) {
	var this_frm = document.telephone_frm;

	var selobj = this_frm.sel_receive_num;
	var cnt = selobj.options.length;

	var total_num = "";
	if(this_frm.CONTENT.value==""||this_frm.CONTENT.value=="보내실 메시지를 입력해주세요."){
		alert("보내실 문자를 넣어주세요");
		this_frm.CONTENT.focus();
		return;
	}
	if(this_frm.phone_num.value=="" && cnt==0){
		alert("보내실 번호를 넣어주세요");
		this_frm.phone_num.focus();
		return;
	}
	if(this_frm.return_phone.value==""){
		alert("수신번호를 넣어주세요");
		this_frm.return_phone.focus();
		return;
	}
	for(i=0; i<cnt;i++){
			total_num=total_num+selobj.options[i].text+"|";
	}
	this_frm.num_list.value=total_num;
	this_frm.SMS_VALUE.value=getCookie('SMS_VALUE');
	this_frm.mode.value="submit";
	this_frm.submit();
  }
}

// 이모티콘 추가
function addChar(aspchar) 
{
	opener.document.telephone_frm.CONTENT.value +=  aspchar;
//	opener.document.forms[0].vc_message.focus();
	cal_byte2(opener.telephone_frm.CONTENT.value);
}

function cal_byte2(aquery) 
{

	var tmpStr;
	var temp=0;
	var onechar;
	var tcount;
	tcount = 0;

	tmpStr = new String(aquery);
	temp = tmpStr.length;

	for (k=0;k<temp;k++)
	{
		onechar = tmpStr.charAt(k);
		if (escape(onechar) =='%0D') { } else if (escape(onechar).length > 4) { tcount += 2; } else { tcount++; }
	}

	opener.document.telephone_frm.COUNTBYTE.value = tcount;

}
//-->