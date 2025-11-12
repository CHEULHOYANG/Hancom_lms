<!-- #include file = "../include/set_loginfo.asp" -->
<!-- #include virtual="/lib/webToken.asp" -->
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

	Dim plidx,order_mast_idx,rs
	Dim lecturidx,strnm,mckey,view_count,view_time,strtime

	plidx = Request("plidx")
	order_mast_idx = request("order_mast_idx")

	sql = "select strnm,mckey,view_count,view_time,strtime,l_idx from SectionTab where idx=" & plidx
	set dr = db.execute(sql)

	strnm = dr(0)
	mckey = dr(1)
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


Dim kollus1,kollus2

sql="select top 1 kullus1,kullus2 from site_info"
Set dr = db.execute(sql)

If dr.eof Or dr.bof Then

	response.write"<script>"
	response.write"alert('콜러스 정보 에러!!');"
	response.write"self.close();"
	response.write"</script>"
	response.End

Else

	kollus1 = dr(0)
	kollus2 = dr(1)

dr.close
End If

If Len(kollus1) = 0 Or Len(kollus2) = 0 Then

	response.write"<script>"
	response.write"alert('콜러스 정보 에러!!');"
	response.write"self.close();"
	response.write"</script>"
	response.End

End if

Function ConvertToUnixTimeStamp(input_datetime)

	Dim d 
	d = CDate(input_datetime)
	ConvertToUnixTimeStamp = CStr(DateDiff("s", "01/01/1970 00:00:00", d)) 

End Function

Dim NewDate

NewDate = DateAdd("n", 10, now())

Dim expire_time,customKey,service_account_key,client_user_id
Dim media_content_key1,media_content_keys(0),jwt,tmp,sOut,result

expire_time = ConvertToUnixTimeStamp(NewDate) 'UNIX TIME STAMP
customKey = kollus2
service_account_key = kollus1
client_user_id = str_User_ID '홈페이지 사용자 아이디

Set media_content_key1 = jsObject()
media_content_key1("mckey") = mckey '미디어 컨텐츠 키, 콜러스 콘솔의 채널 페이지 -> 컨텐츠 상세 정보에서 확인
Set media_content_keys(0) = media_content_key1
jwt = createWebtoken(media_content_keys, client_user_id, expire_time, customKey, service_account_key)
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=strnm%></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<link rel="stylesheet" href="../include/style.css" type="text/css">
<script src="../include/jquery-1.11.2.min.js"></script>
<style>
.vv_cate_lft{
-ms-overflow-style: none;
}
.vv_cate_lft::-webkit-scrollbar{ 
display:none; 
}
</style>
<script language="javascript">
window.resizeTo(970,670);
</script>

</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="overflow-x: hidden;overflow-y: hidden">
<center>
<div class="vv_cate_lft">
<iframe src="https://v.kr.kollus.com/s?jwt=<%=jwt%>&custom_key=<%=customKey%>" width='950' height='600' frameborder="no" scrolling="no" marginwidth="0" marginheight="0" allow="autoplay" allowfullscreen=""></iframe>
</div>
</center>
</body>
</html><% 

sql = "select count(idx) from view_mast where v_idx = "& plidx &" and gang_idx = "& lecturidx &" and id = '"& str_User_ID &"' and order_mast_idx = '"& order_mast_idx &"'"
Set rs=db.execute(sql)

If rs(0) = 0 Then

	sql = "insert into view_mast (id,v_idx,v_time,v_date,v_sesstion,v_gu,ip,gang_idx,order_mast_idx)values"
	sql = sql & "('" & str_User_ID & "'"
	sql = sql & ","& plidx
	sql = sql & ",0,'"& date() &"'"
	sql = sql & ",'"& session.sessionID &"'"
	sql = sql & ",0,'"& Request.ServerVariables("REMOTE_ADDR") &"'"
	sql = sql & ","& lecturidx
	sql = sql & ",'"& order_mast_idx &"'"
	sql = sql & ")"
	db.execute sql,,adexecutenorecords

rs.close
End if

else %>
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