<!-- #include file = "../include/set_loginfo.asp" -->
<% Dim isViewpg : isViewpg = False

if isUsr then %><!-- #include file = "../include/dbcon.asp" --><%
	Dim gbn
	Dim plidx

	gbn = Request("gbn")
	plidx = Request("plidx")

	dim Lecturaidx
	sql = "select l_idx from SectionTab where idx=" & plidx
	set dr = db.execute(sql)
	Lecturaidx = dr(0)
	dr.close

	sql = "select count(idx) from order_mast where id='" & str_User_ID & "' and buygbn = 0 and DateDiff(day,GetDate(),sday) <=0 and DateDiff(day,GetDate(),eday) >= 0 and state=0 and holdgbn=0"
	dim cntPerm
	set dr = db.execute(sql)
	cntPerm = dr(0)
	dr.close

	if cntPerm > 0 then	''프리미엄 수강
		Session("mpermission") = now
		isViewpg = True
	else
		sql = "select tabidx from order_mast where id='" & str_User_ID & "' and buygbn = 1 and DateDiff(day,GetDate(),sday) <=0 and DateDiff(day,GetDate(),eday) >= 0 and state=0 and holdgbn=0"
		set dr = db.execute(sql)
		if Not dr.Bof or Not dr.Eof then
			isRows = split(dr.getString(2),chr(13))
			isRecod = True
		end if
		dr.close



		if isRecod then
			dim intII
			for intII = 0 to UBound(isRows) - 1
				sql = "select count(idx) from LectAry where mastidx=" & isRows(intII) & " and lectidx=" & Lecturaidx

				set dr = db.execute(sql)
				if int(dr(0)) > 0 then	''강좌수강
					Session("mpermission") = now
					isViewpg = True
					exit For
				end if
				dr.close
			Next

		End if

			dim cntDanum
			sql = "select count(idx) from order_mast where id='" & str_User_ID & "' and buygbn=2 and tabidx=" & Lecturaidx & " and DateDiff(day,GetDate(),sday) <=0 and DateDiff(day,GetDate(),eday) >= 0 and state=0 and holdgbn=0"
			set dr = db.execute(sql)
			cntDanum = dr(0)
			dr.close
			if int(cntDanum) > 0 then	''단과수강
				Session("mpermission") = now
				isViewpg = True
			end if

	end if

set dr = nothing

end if

if isViewpg then 

	''보안을 위해서 로그인 체크한다
	dim login_new_ip
	
	login_new_ip = Request.ServerVariables("HTTP_X_FORWARDED_FOR")'클라이언트의 리얼IP받음
	
	If login_new_ip = "" Then '리얼Ip아닐때 동적IP받음(클라이언트)
	   login_new_ip = Request.ServerVariables("REMOTE_ADDR")
	end if	
	
	sql = "insert into user_ip_check (uid,uname,gu,ip)values"
	sql = sql & "('" & str_User_ID & "'"
	sql = sql & ",'" & str_User_Nm & "'"
	sql = sql & ",1,'" & login_new_ip & "'"
	sql = sql & ")"
	db.execute sql,,adexecutenorecords

	If gbn= "mp4" Or gbn="wmv" Then
		response.redirect "/yplayer1/index.asp?order_mast_idx="& request("order_mast_idx") &"&plidx="& plidx &"&gu="& gbn &""
	End If
	If gbn= "free" Then
		response.redirect "viewer_free.asp?plidx="& plidx &""
	End If
	If gbn= "swf" Then
		response.redirect "viewer_swf.asp?plidx="& plidx &""
	End If
	If gbn= "kollus" Then
		response.redirect "viewer_kollus.asp?order_mast_idx="& request("order_mast_idx") &"&plidx="& plidx &""
	End If

else %>
<script language="javascript">
	alert("회원님은 현재 휴학중이거나 수강권한이없습니다!");
	window.close();
</script><% end if %>
