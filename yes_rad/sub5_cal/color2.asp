<%
dim fname 

fname = request("fname")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<head>
<TITLE>글자색선택</TITLE>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<STYLE>
<!--
a     { text-decoration:none; }
p,td  { font-family:굴림; font-size:9pt; }
body  { font-family:굴림; font-size:9pt; }
input { font-family:굴림체; font-size:9pt; height:18px; border:1 solid; border-color:gray }
-->
</STYLE>
</HEAD>

<BODY TEXT=black bgColor=#efffbf>

<SCRIPT LANGUAGE="JavaScript">
<!--
window.onresize = new Function ("window.resizeTo(500,500);window.moveTo(500,500);");
var Table = new Array(
'ff0000','ff3f00','ff7f00','ffbf00','ffff00','bfff00','7fff00','3fff00','00ff00','00ff3f','00ff7f','00ffbf','00ffff','00bfff','007fff','003fff','0000ff','3f00ff','7f00ff','bf00ff','ff00ff','ff00bf','ff007f','ff003f','ffffff','000000',
'ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff','ffffff',
'ffdfdf','ffe7df','ffefdf','fff7df','ffffdf','f7ffdf','efffdf','e7ffdf','dfffdf','dfffe7','dfffef','dffff7','dfffff','dff7ff','dfefff','dfe7ff','dfdfff','e7dfff','efdfff','f7dfff','ffdfff','ffdff7','ffdfef','ffdfe7','ffdfdf','efefef',
'ffbfbf','ffcfbf','ffdfbf','ffefbf','ffffbf','efffbf','dfffbf','cfffbf','bfffbf','bfffcf','bfffdf','bfffef','bfffff','bfefff','bfdfff','bfcfff','bfbfff','cfbfff','dfbfff','efbfff','ffbfff','ffbfef','ffbfdf','ffbfcf','ffbfbf','dfdfdf',
'ff8f8f','ffb79f','ffcf9f','ffe79f','ffff9f','e7ff9f','cfff9f','b7ff9f','9fff9f','9fffb7','9fffcf','9fffe7','9fffff','9fe7ff','9fcfff','9fb7ff','9f9fff','b79fff','cf9fff','e79fff','ff9fff','ff9fe7','ff9fcf','ff9fb7','ff9f9f','cfcfcf',
'ff7f7f','ff9f7f','ffbf7f','ffdf7f','ffff7f','dfff7f','bfff7f','9fff7f','7fff7f','7fff9f','7fffbf','7fffdf','7fffff','7fdfff','7fbfff','7f9fff','7f7fff','9f7fff','bf7fff','df7fff','ff7fff','ff7fdf','ff7fbf','ff7f9f','ff7f7f','bfbfbf',
'ff5f5f','ff875f','ffaf5f','ffd75f','ffff5f','d7ff5f','afff5f','87ff5f','5fff5f','5fff87','5fffaf','5fffd7','6fffff','5fd7ff','5fafff','5f87ff','5f5fff','875fff','af5fff','d75fff','ff5fff','ff5fd7','ff5faf','ff5f87','ff5f5f','afafaf',
'ff3f3f','ff6f3f','ff9f3f','ffcf3f','ffff3f','cfff3f','9fff3f','6fff3f','3fff3f','3fff6f','3fff9f','3fffcf','5fffff','3fcfff','3f9fff','3f6fff','3f3fff','6f3fff','9f3fff','cf3fff','ff3fff','ff3fcf','ff3f9f','ff3f6f','ff3f3f','9f9f9f',
'ff1f1f','ff571f','ff8f1f','ffc71f','ffff1f','c7ff1f','8fff1f','57ff1f','1fff1f','1fff57','1fff8f','1fffc7','3fffff','1fc7ff','1f8fff','1f57ff','1f1fff','571fff','8f1fff','c71fff','ff1fff','ff1fc7','ff1f8f','ff1f57','ff1f1f','8f8f8f',
'ff0000','ff3f00','ff7f00','ffbf00','ffff00','bfff00','7fff00','3fff00','00ff00','00ff3f','00ff7f','00ffbf','00ffff','00bfff','007fff','003fff','0000ff','3f00ff','7f00ff','bf00ff','ff00ff','ff00bf','ff007f','ff003f','ff0000','7f7f7f',
'df0000','df3700','df6f00','dfa700','dfdf00','a7df00','6fdf00','37df00','00df00','00df37','00df6f','00dfa7','00dfdf','00a7df','006fdf','0037df','0000df','3700df','6f00df','a700df','df00df','df00a7','df006f','df0037','df0000','6f6f6f',
'bf0000','bf2f00','bf5f00','bf8f00','bfbf00','8fbf00','5fbf00','2fbf00','00bf00','00bf2f','00bf5f','00bf8f','00bfbf','008fbf','005fbf','002fbf','0000bf','2f00bf','5f00bf','8f00bf','bf00bf','bf008f','bf005f','bf002f','bf0000','5f5f5f',
'9f0000','9f2700','9f4f00','9f7700','9f9f00','779f00','4f9f00','279f00','009f00','009f27','009f4f','009f77','009f9f','00779f','004f9f','00279f','00009f','27009f','4f009f','77009f','9f009f','9f0077','9f004f','9f0027','9f0000','4f4f4f',
'7f0000','7f1f00','7f3f00','7f5f00','7f7f00','5f7f00','3f7f00','1f7f00','007f00','007f1f','007f3f','007f5f','007f7f','005f7f','003f7f','001f7f','00007f','1f007f','3f007f','5f007f','7f007f','7f005f','7f003f','7f001f','7f0000','3f3f3f',
'5f0000','5f1700','5f2f00','5f4700','5f5f00','475f00','2f5f00','175f00','005f00','005f17','005f2f','005f47','005f5f','00475f','002f5f','00175f','00005f','17005f','2f005f','47005f','5f005f','5f0047','5f002f','5f0017','5f0000','2f2f2f',
'3f0000','3f0f00','3f1f00','3f2f00','3f3f00','2f3f00','1f3f00','0f3f00','003f00','003f0f','003f1f','003f2f','003f3f','002f3f','001f3f','000f3f','00003f','0f003f','1f003f','2f003f','3f003f','3f002f','3f001f','3f000f','3f0000','1f1f1f',
'1f0000','1f0700','1f0f00','1f1700','1f1f00','171f00','0f1f00','071f00','001f00','001f07','001f0f','001f17','001f1f','00171f','000f1f','00071f','00001f','07001f','0f001f','17001f','1f001f','1f0017','1f000f','1f0007','1f0000','0f0f0f',
'000000','000000','000000','000000','000000','000000','000000','000000','000000','000000','000000','000000','000000','000000','000000','000000','000000','000000','000000','000000','000000','000000','000000','000000','000000','000000'
);

document.write( "<form name=tform>" )
document.write( "<div align=center>" )
document.write( "<table border=0 cellpadding=0 cellspacing=0 WIDTH=100>")
document.write( "<tr><td colspan=26>" )
document.write( "<input type=text name=rgb size=26> " )
document.write( "<input type=text name=col size=31>" )
document.write( "</td></tr>" )

for( var i=0; i<468; i++ ) {
if( i % 26 == 0 ) document.write( "<tr>" )
/*
	document.write( '<td bgcolor=#'+ Table[i] + ' ' +
	'width=10 height=10 ' +
	'style=cursor:pointer ' +
	'onClick=Select("#'+ Table[i] +'") ' +
	'onMouseOver=ViewColor("#'+ Table[i] +'")>' )
	document.write( '&nbsp;&nbsp;&nbsp;</td>' )
*/
	document.write( '<td bgcolor=#'+ Table[i] +'>' )
	document.write( '<a href=javascript:Select("#'+ Table[i] +'") ' )
	document.write( 'onMouseOver=ViewColor("#'+ Table[i] +'")>' )
	document.write( '&nbsp;&nbsp;&nbsp;</td>' )

	if( i % 26 == 25 ) document.write( "</tr>" )
}

document.write( "<tr><td colspan=26>" )
document.write( "<input type=hidden name=sel_rgb size=26> " )
document.write( "<input type=hidden name=sel_col size=31>" )
document.write( "</td></tr>" )
document.write( "</table>" )
document.write( "</div>" )
document.write( "</form>" )

function ViewColor( rgb )
{
    document.tform.rgb.value = rgb
    document.tform.col.style.backgroundColor = rgb
}


function Select( rgb )
{
	document.tform.sel_rgb.value = rgb
	document.tform.sel_col.style.backgroundColor = rgb
	opener.document.<%=fname%>.font_color.value=rgb
    self.close();
}

/*
document.onmousedown=Click;
if (document.layers) window.captureEvents(Event.MOUSEDOWN);
window.onmousedown=Click;
function Click()
{
    if( navigator.appName == 'Netscape' && (e.which == 3 || e.which == 2) ) return false;
  	else if( navigator.appName == 'Microsoft Internet Explorer' && (event.button == 2 || event.button == 3) )
    {
    		self.close();
    		return false;
  	}
  	return true;
}
*/
// -->
</SCRIPT>

<!-- Make By Lee Myeong-Ryeol ( SANJINY@hitel.net / http://www.sanjiny.com )
Sice By 2001. 28. 6
-->

</BODY>
</HTML>
