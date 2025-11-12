<% 
Dim subArypg  : subArypg = Request.ServerVariables("PATH_INFO")
Dim ca1,ca2
Dim catenm,categbn

If Len(request("ca1")) > 0 then	ca1 = Request("ca1")
If Len(request("ca2")) > 0 then	ca2 = Request("ca2")
%>
	<div class="nlnbWrap">
		<h2><%=t_menu2%></h2>
		<div class="nlnb">

<%
dim ispkage
         sql = "select idx,bname from mscate where state = 0 order by ordnum"
         set dr = db.execute(sql)
          if not dr.bof or not dr.eof then
          	ispkage = True

          		Dim pkrows,pkcols
          		pkrows = split(dr.getstring(2),chr(13))
          end if
         dr.close

if ispkage then
          for ii = 0 to UBound(pkrows) - 1
          pkcols = split(pkrows(ii),chr(9))      

		  if cstr(categbn) = cstr(pkcols(0)) Then catenm = pkcols(1)
%>
			<dl>
				<dt><a href="class_list.asp?categbn=<%=pkcols(0)%>"><%=pkcols(1)%></a></dt>
			</dl>
<%
Next
          end if		  

dim ispkage1
         sql = "select idx,title,(select count(idx) from dan_category where deep=1 and uidx=A.idx) from dan_category A where state = 0 and deep=0 order by ordnum asc,idx desc"
         set dr = db.execute(sql)
          if not dr.bof or not dr.eof then
          	ispkage1 = True          		
          		pkrows = split(dr.getstring(2),chr(13))
          end if
         dr.close

if ispkage1 then
          for ii = 0 to UBound(pkrows) - 1
          pkcols = split(pkrows(ii),chr(9))      
%>
			<dl>
				<dt><a href="dan_list.asp?ca1=<%=pkcols(0)%>"><%=pkcols(1)%></a></dt>
<%If pkcols(2) > 0 then%>
				<dd><%
				sql = "select idx,title from dan_category where deep=1 and uidx = "& pkcols(0) &" order by ordnum asc,idx desc"
				Set rss9 = db.execute(sql)

				If rss9.eof Or rss9.bof Then
				Else
				Do Until rss9.eof
				%><a href="dan_list.asp?ca1=<%=pkcols(0)%>&ca2=<%=rss9(0)%>"><%=rss9(1)%></a><%
				rss9.movenext
				Loop
				rss9.close
				End if
				%></dd>
<%End if%>
			</dl>
<%
Next
          end if		  
%>
			<dl>
				<dt><a href="reply_list.asp">수강후기</a></dt>
			</dl>
		</div>

        <!-- #include file="../include/left2.asp" -->

<!--  배너시작   -->
	<div style="text-align:center;">
	<% 
	sql = "select banner,banner_url,filegbn,target from banner where areagbn='041' order by  ordnum asc , idx desc"
	set dr = db.execute(sql)
	if not dr.bof or not dr.eof then
	do until dr.eof 
	response.write ""& BannerOutput(dr(0),dr(1),dr(2),200,dr(3)) &"<br /><br />"
	dr.movenext
	Loop
	end if
	dr.close %>					
	</div>
<!--  배너끝  -->

	</div>