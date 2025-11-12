<!-- #include file = "../include/set_loginfo.asp" -->
<%
''인증키 확인

Dim viewPerm,rs,i
Dim v1,h,m,s

if Session("mpermission") = "" then

	viewPerm = False

else

	Dim thChk : thChk = DateDiff("s",Session("mpermission"),now)
	Session.Abandon

	if int(thChk) < 25 then
		viewPerm = True
	else
		viewPerm = False
	end if

end if
if viewPerm then

''*************************************************************************************************
if isUsr then%><!-- #include file = "../include/dbcon.asp" --><%
	Dim gbn,plidx
	gbn = Request("gbn")
	plidx = Request("plidx")

	Dim lecturidx,strnm
	Dim flshlink,movlink,down1,down2,view_count,view_time,strtime
	sql = "select strnm,l_idx,flshlink,movlink,lecsum,lecsrc,view_count,view_time,strtime from SectionTab where idx=" & plidx
	set dr = db.execute(sql)

	strnm = dr(0)
	lecturidx = dr(1)
	flshlink = dr(2)
	movlink = dr(3)
	down1 = dr(4)
	down2 = dr(5)	
	view_count = dr(6)
	view_time = dr(7)
	strtime = dr(8)
	dr.close
	
	dim se_check : se_check = session.sessionID	

	Dim check_time,check_time1
	
	check_time  = split(strtime,":")
	check_time1 = (int(check_time(0)) * 60) + int(check_time(1))

	set dr = Nothing

	If Int(view_count) > 0 then

		sql = "select count(idx) from view_mast where id='"& str_User_ID &"' and v_idx = "& plidx &" and v_time >= "& check_time1 &""
		Set dr = db.execute(sql)	

		If Int(dr(0)) > Int(view_count) Then
			
			response.write"<script>"
			response.write"alert('제한횟수 초과로 재생이 불가능합니다.');"
			response.write"self.close();"
			response.write"</script>"
			response.End
			
		dr.close
		End If
	
	End if

	If Int(view_time) > 0 Then

		sql = "select isnull(sum(v_time),0) from view_mast where id='"& str_User_ID &"' and v_idx = "& plidx &""
		Set dr = db.execute(sql)

		If Int(dr(0)) > 0 then

			If Int(dr(0)/60) > Int(view_time) Then
				
				response.write"<script>"
				response.write"alert('제한시간 초과로 재생이 불가능합니다.');"
				response.write"self.close();"
				response.write"</script>"
				response.End

			End if
			
		dr.close
		End If

	End if

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=strnm%></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />

<script language="javascript" src="../jsrc/xmlhttp.js"></script>
<script src="../include/jquery.js"></script>

<script>
function side_display(flag){
	vdivList1.style.display = "none";
	vdivList2.style.display = "none";

	switch (flag)
	{
		case 1: vdivList1.style.display = ""; break;
		case 2: vdivList2.style.display = ""; break;
	}
} 

function time_save(){

	var params = "key=<%=plidx%>|<%=str_User_ID%>|<%=se_check%>|0|<%=lecturidx%>";	
	sndReq("../xml/view_check.asp",params,function(){
		if(objXmlhttp.readyState == 4){
			if(objXmlhttp.status == 200){
				var xmltxt = objXmlhttp.responseText;
				//alert(xmltxt);
			}else{
				//alert("error");
			}
		}
	},"POST");
	self.setTimeout("time_save()",10000);
}
time_save();




function bookmark_save(){

		var check_time = MediaPlayer.currentPosition;

		$.ajax({
			url: "../xml/bookmark_check.asp",
			type:"POST",
			data:{"key":"<%=plidx%>|<%=str_User_ID%>|"+check_time+""},
			dataType:"text",
			cache:false,
			processData:true,
			success:function(_data){								
				$('#playArea').html(_data);	
			},
			error:function(xhr,textStatus){
			alert("[에러]원인:"+xhr.status+"                                     ");
			}	
		});		

}

function bookmark_del(idx){

		$.ajax({
			url: "../xml/bookmark_del.asp",
			type:"POST",
			data:{"key":"<%=str_User_ID%>^^"+idx+"^^<%=plidx%>"},
			dataType:"text",
			cache:false,
			processData:true,
			success:function(_data){								
				$('#playArea').html(_data);	
			},
			error:function(xhr,textStatus){
			alert("[에러]원인:"+xhr.status+"                                     ");
			}	
		});		

}
function bookmark_go(idx){
	MediaPlayer.currentPosition = idx;
}
</script>

<script language="javascript">
<!--
var oldPos = 0; 		//클릭시 마우스좌표
var oldPixel = 0;		//클릭시 슬라이더 좌표
var bDrag = false;	//움직임
var bPlay = false; 	//플레이중
var bRate = 1;			//재생속도;
var murl;

var progressBar_StartPixel =0;        //플레이바 시작위치
var progressBar_Size = 554;        //플레이바 크기
function progressBar_onmousedown() {
    if (!bPlay)
        return ;

    if (MediaPlayer.CurrentPosition == -1 )        //Player.FileName이 설정되어 있지 않으면 걍 리턴해 버린다.
        return false;

    oldPos = event.clientX;        
    bDrag  = true;
    TrackBar = event.srcElement.parentElement;    
    oldPixel = progressBar.style.pixelLeft;       
    document.onmousemove = PlayMoveSlider;
    if(document.all)
    {
        document.onmouseup = PlayStopSlider;
    }
}

function PlayMoveSlider() {
    if (bDrag) {
        var XPos = oldPixel + (event.clientX - oldPos);    //최초 마우스다운일때 좌표에서 mousemove한 좌표값       
        
        
        if((progressBar_StartPixel <= XPos  )
            && (XPos <= progressBar_StartPixel + (progressBar_Size  ) ) )
        {

            //프로그래스바 이동            
            document.all.progressBar.style.pixelLeft = XPos;

        }//if((XPos >= startVolPos) &&....
        return false;
    }

}


function PlayStopSlider() {

    bDrag = false;

    MediaPlayer.currentPosition  = Pixel2Pos(progressBar.style.pixelLeft - progressBar_StartPixel)
    if (MediaPlayer.PlayState == 1)    //일시 중지 일때, 즉 스라이더 움직임에 의해 중단되었을 때만, 다시 실행
        MediaPlayer.Play();

    document.onmousemove = null;
    if(document.all);
        document.onmouseup = null;
}

function Pixel2Pos(nPixel)
{
        return parseInt((nPixel) * MediaPlayer.Duration / progressBar_Size);
}
var imgpath = "viewimg/";
var volumeMin = -3000;
var volumeMax = 0;
var volumeValue = 0;
var oldVolume = 0;
var VolumeBar_StartPixel = 0;
var VolumeBar_Size = 43;    //볼륨바 크기

function VolumeBar_onmousedown() {
    if (!bPlay)
        return ;

    oldPos = event.clientX;                            //최초 마우스다운일때 좌표
    oldPixel = VolumeBar.style.pixelLeft;                //최초 마우스다운 일때 슬라이더좌표
    oldVolume = MediaPlayer.Volume
    bDrag = true;
    document.onmousemove = VolumeMoveSlider;            //onmousemove캡쳐    
    if (document.all)
        document.onmouseup=VolumeStopSlider;        //onmousemove 해제
}

function VolumeMoveSlider() {
    if (bDrag) {
        var XPos = oldPixel + event.clientX - oldPos;    //최초 마우스다운일때 좌표에서 mousemove한 좌표값			
				
        if((VolumeBar_StartPixel <= XPos  )
            && (XPos <= VolumeBar_StartPixel + VolumeBar_Size ) )
        {

            VolumeBar.style.pixelLeft = XPos;    //마우스 이동한 만큼 슬라이더 이동
            vol_position_bg.style.width = VolumeBar.style.pixelLeft - VolumeBar_StartPixel;
            var mouseMove = XPos - oldPixel;    //마우스이동값
            var currentVolumeValue = oldVolume - parseInt(mouseMove * volumeMin / VolumeBar_Size );

            if( currentVolumeValue <= -4929)
                MediaPlayer.Volume = volumeMin;
            else if (currentVolumeValue >= volumeMax)
                MediaPlayer.Volume = volumeMax;
            else
                MediaPlayer.Volume = currentVolumeValue;


        }
        return false;
    }//if (bDrag)
}

function VolumeStopSlider() {
    bDrag = false;
}

function VolumeInit() {

    //볼륨초기화
    VolumeBar.style.pixelLeft = VolumeBar_StartPixel + VolumeBar_Size /2  ;
    vol_position_bg.style.width = VolumeBar.style.pixelLeft - VolumeBar_StartPixel;
    MediaPlayer.Volume =  volumeMin / 2;
}
function setMute() {

    if (!bPlay)
        return ;

    if(MediaPlayer.mute==false)
    {
        player_mute.src = imgpath+"mute_on.gif";
        MediaPlayer.mute = true;
    }
    else
    {
        player_mute.src = imgpath+"mute_off.gif";
        MediaPlayer.mute = false;
    }
}


function playerControl(action)
{
    try {
        if (action == "play")
        {
            MediaPlayer.Play();
            MediaPlayer.Rate = playspeed;
            //play_botton.style.visibility = "hidden";
            //pause_botton.style.visibility = "visible";
            //stop_botton.style.visibility = "visible";

        }
        else if (action == "pause")
        {
            if (MediaPlayer.PlayState ==2)
                MediaPlayer.Pause();
            //play_botton.style.visibility = "visible";
            //pause_botton.style.visibility = "hidden";
            //stop_botton.style.visibility = "visible";

        }
        else if (action == "open")
        {
            try{
                MediaPlayer.open(murl);  //동영상 경로 설정

                //play_botton.style.visibility = "hidden";
                //pause_botton.style.visibility = "visible";
                //stop_botton.style.visibility = "visible";
            }catch(e){}

            //볼륨셋팅
            VolumeInit();
        }

        else if (action == "stop")
        {
            //play_botton.style.visibility = "hidden";
            //pause_botton.style.visibility = "hidden";
            //stop_botton.style.visibility = "hidden";
            MediaPlayer.Stop();
            //볼륨셋팅
            VolumeInit();
        }
    }catch(e){
        //alert("재생되지 않는 동영상 파일이거나\nMicrosoft Widows Media Player6.4 이상이 설치되어 있지않습니다.");
    }
}
//플레이 트랙바 자동이동-----------------------------------------------------------------------------------


function TimeFormat(totalsecond)
{

    var second = parseInt(totalsecond) % 60;
    var minute = parseInt(totalsecond / 60);
    return ((minute < 10)?"0":"")+minute+":" + ((second < 10)?"0":"")+second;
}

function progressBuffering(bPlay)
{
    if(bPlay)
    {
        var BufferingProgress = MediaPlayer.BufferingProgress;
        var disBuffer="";
        //PlayState.style.visibility = "visible";
    }
    else
    {
       //PlayState.style.visibility = "hidden";
    }

}
function onFullScreen()
{
    MediaPlayer.DisplaySize = 3;
}

function onView(width,height)
{
    document.all["MediaPlayer"].style.width = width;
    document.all["MediaPlayer"].style.height = height;

}

var selectrate = 2;
var playspeed = 1;

function player_setRate(n,rn,imgnm)
{
	if(!bPlay) return;
	if(n == selectrate) return;
	var beforimg = document.images['rateimg' + selectrate];
	var afterimg = document.images['rateimg' + n];


	beforimg.src= beforimg.src.replace(/r.gif/,".gif");
	afterimg.src= imgpath + "bt_" + imgnm + "r.gif";
	selectrate = n;
	MediaPlayer.Rate = rn;
	playspeed = rn;
}
//-->
</script>
<SCRIPT language="javascript" event="PlayStateChange(OldState,NewState)" for="MediaPlayer">
    switch (NewState){
        case 0:
            //play_botton.style.visibility = "visible";
            //pause_botton.style.visibility = "hidden";
            try{clearTimeout(MediaTimer);    }catch(e){return;}
            bPlay = false;
            progressBuffering(false);
            break;
        case 1:
            //play_botton.style.visibility = "visible";
            //pause_botton.style.visibility = "hidden";
            try{clearTimeout(MediaTimer);    }catch(e){return;}
            bPlay = false;
            progressBuffering(false);
            break;
        case 2:        //플레이중
            //play_botton.style.visibility = "hidden";
            //pause_botton.style.visibility = "visible";
            //stop_botton.style.visibility = "visible";
            //MediaTimer=window.setInterval("ScrollBarState()",500);
            bPlay = true;
            progressBuffering(true);
            break;
        case 3:        //버퍼링중..
            progressBuffering(true);
            bPlay = true;
            break;
        case 6:        //버퍼링중..
            progressBuffering(true);
            bPlay = true;
            break;
        default:

    }




function nocontextmenu() 
{
   event.cancelBubble = true
   event.returnValue = false;

   return false;
}

function norightclick(e) 
{
   if (window.Event)   
   {
	  if (e.which == 2 || e.which == 3)
		 return false;
   }
   else
	  if (event.button == 2 || event.button == 3)
	  {
		 event.cancelBubble = true
		 event.returnValue = false;
		 return false;
	  }
   
}
function keypressed() {
	self.close();
}

function enterkey() {
                if(event.keyCode == 93) {
self.close();
                }
}

document.onkeydown=keypressed;
document.oncontextmenu = nocontextmenu;	 
document.onmousedown = norightclick;	 

	document.onkeydown = CheckKeyPress;
	document.onkeyup = CheckKeyPress;
	function CheckKeyPress()
	{
		//키입력
		ekey = event.keyCode;

		//리턴
		if(ekey == 38 || ekey == 40 || ekey == 112 ) { alert("사용불가능한키입니다."); return false; }
	}
	function click() {
    if ((event.button==2) || (event.button==3) || (event.keyCode == 93) || (event.keyCode == 17) ) {
      self.close();
    }
    else {
      if((event.ctrlKey) && (event.keyCode == 67)) {
        alert('내용을 무단복제하실 수 없습니다.');
      }
    }
  }
  document.onmousedown=click
  document.onkeydown=click


function noEvent() {
    if (event.keyCode == 116) {
        event.keyCode= 2;
        return false;
    }
    else if(event.ctrlKey && (event.keyCode==78 || event.keyCode == 82))
    {
        return false;
    }
}
document.onkeydown = noEvent;  

function click() {
if((event.button==2) || (event.button==3)) {
  alert("오른쪽 버튼은 사용하실 수 없습니다");
  return false;
}
}
function keypressed() {
var key=event.keyCode;
if(key==8) { self.close(); return false; }
if(key==16) { self.close(); return false; }
if(key==18) { self.close(); return false; }
if(key==9) { self.close(); return false; }
if(key==91) { self.close(); return false; }
if(key==17) { self.close(); return false; }
if(key==18) { self.close(); return false; }
if(key==93) { self.close(); return false; }
if(key==41) { self.close(); return false; }
if(key==116) { self.close(); return false; }
}


document.onmousedown=click;
document.onkeydown=keypressed;

document.onkeydown = function () {
     var backspace = 8;
     var t = document.activeElement;

     if (event.keyCode == backspace) {
     	
     	self.close();
         if (t.tagName == "SELECT")
             return false;

         if ((t.tagName == "INPUT" || t.tagName == "TEXTAREA") && $(t).attr("readonly") == "readonly"){
             return false;
     }
 }

}
document.onkeydown = function () {
     var backspace = 116;
     var t = document.activeElement;

     if (event.keyCode == backspace) {

     	 self.close();
         if (t.tagName == "SELECT")
             return false;

         if ((t.tagName == "INPUT" || t.tagName == "TEXTAREA") && $(t).attr("readonly") == "readonly"){
             return false;
     }
 }

}
</SCRIPT>

</head>

<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false">
<table width="930" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td height="32" align="center" valign="bottom" background="../img_elearning/vod/v_top.gif"><table width="97%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="30"><span style="font-size:9pt;font-family:돋움;color:FFC445;" ID="LecutrJemok"><%=strnm%></span></td>
        <td align="right"><img src="../img_elearning/vod/bt_close.gif" width="19" height="18" onClick="javascript:self.close();" style="cursor:pointer;"></td>
      </tr>
    </table></td>
  </tr>
  <tr> 
    <td align="center" background="../img_elearning/vod/v_bg.gif"><table width="910" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="680" valign="top"><table width="670" cellpadding="0" cellspacing="0">
              <tr height="8"> 
                <td height="8" colspan="2"><img src="../img_elearning/vod/vod_top.gif" width="670" height="9"></td>
              </tr>
<tr> 
                <td height="380" colspan="2" align="center" background="../img_elearning/vod/vod_bg.gif"><OBJECT ID='MediaPlayer' Name='MediaPlayer' classid='clsid:22D6F312-B0F6-11D0-94AB-0080C74C7E95' codebase='http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701' standby='Loading Microsoft Windows Media Player components...' type='application/x-oleobject ' bgcolor='DarkBlue' width='640' Height='415' VIEWASTEXT>
<param name="AudioStream" value="-1">
<param name="AutoSize" value="0">
<param name="AutoStart" value="-1">
<param name="AnimationAtStart" value="-1">
<param name="AllowScan" value="0">
<param name="AllowChangeDisplaySize" value="-1">
<param name="AutoRewind" value="0">
<param name="Balance" value="0">
<param name="BaseURL" value="">
<param name="BufferingTime" value="5">
<param name="CaptioningID" value="">
<param name="ClickToPlay" value="-1">
<param name="CursorType" value="0">

<param name="CurrentPosition" value="0">

<param name="CurrentMarker" value="0">
<param name="DefaultFrame" value="">
<param name="DisplayBackColor" value="0">
<param name="DisplayForeColor" value="16777215">
<param name="DisplayMode" value="0">
<param name="DisplaySize" value="0">
<param name="Enabled" value="-1">
<param name="EnableContextMenu" value="0">
<param name="EnablePositionControls" value="-1">
<param name="EnableFullScreenControls" value="1">
<param name="EnableTracker" value="-1">
<param name="InvokeURLs" value="0">
<param name="Language" value="-1">
<param name="Mute" value="0">
<param name="PlayCount" value="1">
<param name="PreviewMode" value="0">
<param name="Rate" value="1">
<param name="SAMILang" value="">
<param name="SAMIStyle" value="">
<param name="SAMIFileName" value="">
<param name="SelectionStart" value="-1">
<param name="SelectionEnd" value="-1">
<param name="SendOpenStateChangeEvents" value="-1">
<param name="SendWarningEvents" value="-1">
<param name="SendErrorEvents" value="-1">
<param name="SendKeyboardEvents" value="0">
<param name="SendMouseClickEvents" value="0">
<param name="SendMouseMoveEvents" value="0">
<param name="SendPlayStateChangeEvents" value="-1">
<param name="ShowCaptioning" value="0">
<param name="ShowControls" value="1">
<param name="ShowAudioControls" value="-1">
<param name="ShowDisplay" value="0">
<param name="ShowGotoBar" value="0">
<param name="ShowPositionControls" value="-1">
<param name="ShowStatusBar" value="1">
<param name="ShowTracker" value="1">
<param name="TransparentAtStart" value="0">
<param name="VideoBorderWidth" value="0">
<param name="VideoBorderColor" value="0">
<param name="VideoBorder3D" value="0">
<param name="Volume" value="-290">
<param name="WindowlessVideo" value="0">
	</OBJECT></td>
              </tr>
              <tr> 
                <td height="41" colspan="2" align="center" background="../img_elearning/vod/vod_btm.gif"><table width="98%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="61%"><img src="../viwer/viewimg/bt_06.gif" ID="rateimg0" style="cursor:pointer" onClick="player_setRate('0','0.6','06');">
                &nbsp;<img src="../viwer/viewimg/bt_08.gif" ID="rateimg1" style="cursor:pointer" onClick="player_setRate('1','0.8','08');">
                &nbsp;<img src="../viwer/viewimg/bt_10r.gif" ID="rateimg2" style="cursor:pointer" onClick="player_setRate('2','1.0','10');">
                &nbsp;<img src="../viwer/viewimg/bt_12.gif" ID="rateimg3" style="cursor:pointer" onClick="player_setRate('3','1.2','12');">
                &nbsp;<img src="../viwer/viewimg/bt_14.gif" ID="rateimg4" style="cursor:pointer" onClick="player_setRate('4','1.4','14');">
                &nbsp;<img src="../viwer/viewimg/bt_16.gif" ID="rateimg5" style="cursor:pointer" onClick="player_setRate('5','1.6','16');">
                &nbsp;<img src="../viwer/viewimg/bt_18.gif" ID="rateimg6" style="cursor:pointer" onClick="player_setRate('6','1.8','18');">
                &nbsp;<img src="../viwer/viewimg/bt_20.gif" ID="rateimg7" style="cursor:pointer" onClick="player_setRate('7','2.0','20');"></td>
                    <td width="39%" align="right"><img src="../viwer/viewimg/book1.gif" style="cursor:pointer;" onClick="bookmark_save();">&nbsp;<img src="../viwer/viewimg/bt_full.gif" style="cursor:pointer;" onClick="onFullScreen();"></td>
                  </tr>
                </table></td>
              </tr>
              <tr> 
                <td height="7" colspan="2"></td>
              </tr>
              <tr> 
                <td colspan="2">&nbsp;</td>
              </tr>
          </table></td>
          <td valign="top"><div style="display:;" id="vdivList1"><table width="230" border="0" cellpadding="0" cellspacing="0" background="../img_elearning/vod/le_bg.gif">
              <tr>
                <td height="35"><table width="230" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="115" height="35" align="center" background="../img_elearning/vod/le_t_me1.gif"><strong><span class="fs-white" onclick="side_display(1);" style="cursor:pointer;">북마크</span></strong></td>
                      <td align="center" background="../img_elearning/vod/le_t_me2.gif"><span class="fs-white" onclick="side_display(2);" style="cursor:pointer;">첨부파일</span></td>
                    </tr>
                </table></td>
              </tr>
              <tr>
                <td height="32"><table width="230" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="8">&nbsp;</td>
                      <td width="8"><img src="../img/i_dot1.gif" width="2" height="2"></td>
                      <td class="fs-white">북마크는 10개까지 저장이 가능합니다.</td>
                    </tr>
                  </table></td>
              </tr>
              <tr>
                <td align="center" valign="top"><table width="228" height="306" border="0" cellpadding="0" cellspacing="0">                   
					<tr> 
                      <td height="30" align="center" valign="top"><span id="playArea">                      
                      <table width="210" border="0" cellspacing="0" cellpadding="0">      
<%
sql = "select vtime,idx from bookmark_mast where v_idx = "& plidx &" and id = '"& str_User_ID &"'"
set rs=db.execute(Sql)

if rs.eof or rs.bof then
else
i=1
do until rs.eof

v1 = rs(0) 
h = (int)(v1 / 3600)
if len(h) = 1 then	h = "0"& h &""
v1 = v1 mod 3600
m = (int)(v1 / 60)

if len(m) = 1 then	m = "0"& m &""
s = v1 mod 60  

if len(s) = 1 then	s = "0"& s &""
%>                                          
                          <tr>
                            <td width="35" height="30"><table width="25" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                  <td width="6"><img src="../img_elearning/vod/bt1_top.gif" width="6" height="20"></td>
                                  <td align="center" background="../img_elearning/vod/bt1_bg.gif"><p class="fs-white" style="margin-top:2px"><strong><%=i%></strong></td>
                                  <td width="6"><img src="../img_elearning/vod/bt1_btm.gif" width="6" height="20"></td>
                                </tr>
                            </table></td>
                            <td class="fs-white" onclick="bookmark_go(<%=rs(0)%>);" style="cursor:pointer;"><%=h%>:<%=m%>:<%=s%></td>
                            <td width="45" align="right"><table width="40" border="0" cellpadding="0" cellspacing="1" bgcolor="262729">
                              <tr>
                                <td align="center" bgcolor="313232"><p style="margin-top:2px;cursor:pointer;" class="fs-white" onclick="bookmark_del(<%=rs(1)%>);">삭제</p></td>
                              </tr>
                            </table></td>
                          </tr>
<%
rs.movenext
i=i+1
loop
rs.close
end if
%>                                                   
                      </table>
                      </span>
                      
                      </td>
                    </tr>
                    
                                                                              
                </table></td>
              </tr>
              <tr>
                <td height="10"><img src="../img_elearning/vod/le_btm.gif" width="230" height="10"></td>
              </tr>
            </table></div>
            


<div style="display:none;" id="vdivList2"><table width="230" border="0" cellpadding="0" cellspacing="0" background="../img_elearning/vod/le_bg.gif">
              <tr>
                <td height="35"><table width="230" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="115" height="35" align="center" background="../img_elearning/vod/le_t_me2.gif"><strong><span class="fs-white" onclick="side_display(1);" style="cursor:pointer;">북마크</span></strong></td>
                      <td align="center" background="../img_elearning/vod/le_t_me1.gif"><span class="fs-white" onclick="side_display(2);" style="cursor:pointer;">첨부파일</span></td>
                    </tr>
                </table></td>
              </tr>
              <tr>
                <td height="5"></td>
              </tr>
              <tr>
                <td align="center" valign="top"><table width="228" height="306" border="0" cellpadding="0" cellspacing="0">                   
					<tr> 
                      <td height="30" align="center" valign="top">
                      
                      <table width="210" border="0" cellspacing="0" cellpadding="0">      
<%if len(down1) > 0 then%>                                       
                          <tr>
                            <td height="30">
                            
                            <table width="150" border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr> 
                                  <td width="6"><img src="../img_elearning/vod/bt2_top.gif" width="6" height="20"></td>
                                  <td align="center" background="../img_elearning/vod/bt2_bg.gif"><a href="<%=down1%>" target="_blank"><p class="fs-white" style="margin-top:2px">파일다운로드#1</p></a></td>
                                  <td width="6"><img src="../img_elearning/vod/bt2_btm.gif" width="6" height="20"></td>
                                </tr>
                            </table></td>
                          </tr>
<%end if%>
<%if len(down2) > 0 then%>                          
                          <tr>
                            <td height="30"><table width="150" border="0" align="center" cellpadding="0" cellspacing="0">
                              <tr>
                                <td width="6"><img src="../img_elearning/vod/bt2_top.gif" width="6" height="20"></td>
                                <td align="center" background="../img_elearning/vod/bt2_bg.gif"><a href="<%=down2%>" target="_blank"><p class="fs-white" style="margin-top:2px">파일다운로드#2</p></a></td>
                                <td width="6"><img src="../img_elearning/vod/bt2_btm.gif" width="6" height="20"></td>
                              </tr>
                            </table></td>
                          </tr>
<%end if%>                          
                      </table>
                      
                      
                      </td>
                    </tr>
                    
                                                                              
                </table></td>
              </tr>
              <tr>
                <td height="10"><img src="../img_elearning/vod/le_btm.gif" width="230" height="10"></td>
              </tr>
            </table></div>
            
            
            </td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td><img src="../img_elearning/vod/v_btm.gif" width="930" height="8"></td>
  </tr>
</table>





</body>
</html>

<%
	sql = "select top 1 v_time from view_mast where id='"& str_User_ID &"' and v_idx = "& plidx &" order by v_time desc"
	Set dr = db.execute(sql)

	If dr.eof Or dr.bof Then
	Else
	%>
<script>

		var bool = confirm("보시던 동영상입니다. 이어보기를 하시겠습니까?");
		if (bool){
			MediaPlayer.currentPosition = <%=dr(0)%>;
		}
		else
		{
			MediaPlayer.currentPosition = 0;
		}

</script>
	<%
	dr.close
	End if
%>

<script language="javascript">
<!--

		$.ajax({
			url: "mxml_wmv.asp",
			type:"POST",
			data:{"key":"<%=plidx%>"},
			dataType:"text",
			cache:false,
			processData:true,
			success:function(_data){								
				murl = _data;
				playerControl('open');
			},
			error:function(xhr,textStatus){
			alert("[에러]원인:"+xhr.status+"                                     ");
			}	
		});		

function closeWin(){
	playerControl('stop');
	document.getElementById("LectNameID").innerText = "";
	window.close();
}

//-->
</script><% else %>
<!-- #include file = "../include/false_pg.asp" --><% end if

''*******************************************************************************************
else %><!-- #include file = "../include/false_pg.asp" --><%
end if %>