<!-- #include file = "../include/set_loginfo.asp" -->
<%
''인증키 확인

Dim viewPerm

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
	Dim plidx
	plidx = Request("plidx")

	Dim lecturidx,strnm
	Dim flshlink,movlink,view_count,view_time,strtime

	sql = "select strnm,freelink,view_count,view_time,strtime,l_idx from SectionTab where idx=" & plidx
	set dr = db.execute(sql)

	strnm = dr(0)
	flshlink = dr(1)
	view_count = dr(2)
	view_time = dr(3)
	strtime = dr(4)
	lecturidx = dr(5)
	dr.close
	
	dim se_check : se_check = session.sessionID	

	Dim check_time,check_time1
	
	check_time  = split(strtime,":")
	check_time1 = (int(check_time(0)) * 60) + int(check_time(1))


	If Int(view_count) > 0 then

		sql = "select count(idx) from view_mast where id='"& str_User_ID &"' and v_idx = "& plidx &" and v_time >= "& check_time1 &""
		Set dr = db.execute(sql)	

		If Int(dr(0)) >= Int(view_count) Then
			
			response.write"<script>"
			response.write"alert('제한횟수 초과로 재생이 불가능합니다.');"
			response.write"self.close();"
			response.write"</script>"
			response.End
			
		dr.close
		End If
	
	End If

	If Int(view_time) > 0 Then

		sql = "select isnull(sum(v_time),0) from view_mast where id='"& str_User_ID &"' and v_idx = "& plidx &""
		Set dr = db.execute(sql)
		
		If Int(dr(0)) > 0 then

			If Int(dr(0)) >= Int(view_time*60) Then
				
				response.write"<script>"
				response.write"alert('제한시간 초과로 재생이 불가능합니다.');"
				response.write"self.close();"
				response.write"</script>"
				response.End

			End if
			
		dr.close
		End If

	End if	

	set dr = nothing
	db.close
	set db = nothing
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=strnm%></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<link rel="stylesheet" href="../include/style.css" type="text/css">
<script src="../include/jquery-1.11.2.min.js"></script>
<script language="javascript" src="../include/xmlhttp.js"></script>
<script language="javascript">
window.resizeTo(950,600);

function time_save(){

	var params = "key=<%=plidx%>|<%=str_User_ID%>|<%=se_check%>|1|<%=lecturidx%>";	
	sndReq("../xml/view_check.asp",params,function(){
		if(objXmlhttp.readyState == 4){
			if(objXmlhttp.status == 200){
				var xmltxt = objXmlhttp.responseText;
				//alert(xmltxt);
				if (xmltxt=="종료")
				{
											//alert('수강완료되었습니다.');
											//window.opener.document.location.href=window.opener.document.URL;
				}
			}else{
				//alert("error");
			}
		}
	},"POST");
	self.setTimeout("time_save()",10000);
}
time_save();
</script>

</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false">
<%=flshlink%>
</body>
</html><% else %>
<!-- #include file = "../include/false_pg.asp" --><% end if

''*******************************************************************************************
else %><!-- #include file = "../include/false_pg.asp" --><%
end if %>
<script>
(function(){
    
    /***************************************************************************
     *                              CSS
     ***************************************************************************/
    document.body.style.WebkitUserSelect = 'none';
    document.body.style.MozUserSelect    = 'none';
    document.body.style.MsUserSelect     = 'none';
    document.body.style.userSelect       = 'none';
    
    
    
    /***************************************************************************
     *                              FUNCTIONS
     ***************************************************************************/
    function disableEvent(e){
        if(e.stopPropagation){
            e.stopPropagation();
        }else if(window.event){
            window.event.cancelBubble = true;
        }
        e.preventDefault();
        return false;
    }
    
    /***************************************************************************
     *                              EVENT LISTENERS
     ***************************************************************************/
    
    //Mouse Right Click
    document.addEventListener('contextmenu',function(e){
        e.preventDefault();
    });
    
    //Keyboard Keys
    document.addEventListener('keydown',function(e){
        
        //CTRL
        if(e.ctrlKey){
            switch(e.code){
                
                case 'KeyA':
                case 'KeyC':
                case 'KeyP':
                case 'KeyS':
                case 'KeyU':
                case 'KeyX':
                    disableEvent(e);
                    break;
            }
        }
        
        //CTRL + SHIFT
        if(e.ctrlKey && e.shiftKey){
            switch(e.code){
                
                case 'KeyI':
                case 'KeyJ':
                    disableEvent(e);
                    break;
            }
        }
        
        //KEYS
        switch(e.code){
            
            case 'F12':
			case 'F11':
                disableEvent(e);
                break;


        }
    });
    
    
})();
</script>