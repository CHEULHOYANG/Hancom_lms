<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<% if isUsr Then

dim isRows1,rs3
dim rs
dim idx,title,date1,date2,munje_gesu
Dim readnum,costnum,munje_repeat,munje_date1,munje_date2,munje_end_time,rs1
dim munje_time1,munje_time2
dim munje_bang1,munje_bang2,i,j,k,munje_result,gu

idx = request("idx")

sql="select idx,title,date1,date2 from question_list where idx = '"& idx &"'"
set rs=db.execute(sql)

if rs.eof or rs.bof Then

	response.write"<script>"
	response.write"alert('존재하지 않는 게시물입니다.');"
	response.write"history.back();"
	response.write"</script>"
	response.End

Else

	idx = rs(0)
	title = rs(1)
	date1 = rs(2)
	date2 = rs(3)
	
rs.close
end If

sql = "select count(idx) from question_result where p_idx = '"& idx &"' and id = '"& str_User_ID &"'"
set rs = db.execute(sql)

If rs(0) > 0 then
		
		response.write"<script>"
		response.write"alert('이미 설문에 참여하셨습니다.');"
	response.write"history.back();"
		response.write"</script>"
		response.End
	
rs.close
End if	


%>
<!-- #include file="../include/head1.asp" -->
<!-- #include file="../include/top.asp" -->

<div class="scontent">
    	<div class="logtit">
                <h4><%=title%></h4>
            </div>
<form name="poll" method="post" action="poll_ok.asp">
<input type="hidden" name="idx" value="<%=idx%>">
            <div class="logBox">
                <div class="outbox">
<%
sql = "select idx,title,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r_gu from question_mast where ca = "& idx &" order by ordnum asc"
set rs=db.execute(sql)

if rs.eof or rs.bof then

	response.write"<script>"
	response.write"alert('등록된 설문항목이 없습니다.');"
	response.write"self.close();"
	response.write"</script>"
	response.end

else
	
i = 1
Do Until rs.eof
%>
                    <dl class="outre">
                            <dt><% response.write "<strong>"& i &" . </strong> "& rs(1) &"" %></dt>
<%If rs(12) = 0 then%>
	<%if Len(rs(2)) > 0 then%>
                            <dd style="font-size:15px;margin:5px 5px 5px 15px"><input name="reply<%=i%>" type="radio" value="<%=rs(2)%>" >&nbsp;<%=rs(2)%></dd>
	<%End if%>
	<%if Len(rs(3)) > 0 then%>
                            <dd style="font-size:15px;margin:5px 5px 5px 15px"><input name="reply<%=i%>" type="radio" value="<%=rs(3)%>" >&nbsp;<%=rs(3)%></dd>
	<%End if%>
	<%if Len(rs(4)) > 0 then%>
                            <dd style="font-size:15px;margin:5px 5px 5px 15px"><input name="reply<%=i%>" type="radio" value="<%=rs(4)%>" >&nbsp;<%=rs(4)%></dd>
	<%End if%>
	<%if Len(rs(5)) > 0 then%>
                            <dd style="font-size:15px;margin:5px 5px 5px 15px"><input name="reply<%=i%>" type="radio" value="<%=rs(5)%>" >&nbsp;<%=rs(5)%></dd>
	<%End if%>
	<%if Len(rs(6)) > 0 then%>
                            <dd style="font-size:15px;margin:5px 5px 5px 15px"><input name="reply<%=i%>" type="radio" value="<%=rs(6)%>" >&nbsp;<%=rs(6)%></dd>
	<%End if%>
	<%if Len(rs(7)) > 0 then%>
                            <dd style="font-size:15px;margin:5px 5px 5px 15px"><input name="reply<%=i%>" type="radio" value="<%=rs(7)%>" >&nbsp;<%=rs(7)%></dd>
	<%End if%>
	<%if Len(rs(8)) > 0 then%>
                            <dd style="font-size:15px;margin:5px 5px 5px 15px"><input name="reply<%=i%>" type="radio" value="<%=rs(8)%>" >&nbsp;<%=rs(8)%></dd>
	<%End if%>
	<%if Len(rs(9)) > 0 then%>
                            <dd style="font-size:15px;margin:5px 5px 5px 15px"><input name="reply<%=i%>" type="radio" value="<%=rs(9)%>" >&nbsp;<%=rs(9)%></dd>
	<%End if%>
	<%if Len(rs(10)) > 0 then%>
                            <dd style="font-size:15px;margin:5px 5px 5px 15px"><input name="reply<%=i%>" type="radio" value="<%=rs(10)%>" >&nbsp;<%=rs(10)%></dd>
	<%End if%>
	<%if Len(rs(11)) > 0 then%>
                            <dd style="font-size:15px;margin:5px 5px 5px 15px"><input name="reply<%=i%>" type="radio" value="<%=rs(11)%>" >&nbsp;<%=rs(11)%></dd>
	<%End if%>
<%else%>
                            <dd style="font-size:15px;margin:5px 5px 5px 15px"><input type="text" name="reply<%=i%>" id="reply<%=i%>" class="inptxt1" style="width:95%" /></dd>
<%End if%>
                     </dl>
<%
rs.movenext
i=i+1
loop
rs.close
end if
%>
                </div>
            </div>
</form>
            <div class="cbtn"> <a href="javascript:poll_send();" class="mbtn grey">제출하기</a> <a href="ing.asp?page=<%=request("page")%>" class="mbtn">취소하기</a> </div>	
</div>

<script>
function poll_send()
{
<%
sql = "select r_gu,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10 from question_mast where ca = "& idx &" order by ordnum asc"
set rs=db.execute(sql)

if rs.eof or rs.bof then
else
i = 1
munje_gesu = 0

do until rs.eof

	if rs(0) = 0 then

		if len(rs(1)) > 0 then munje_gesu = munje_gesu + 1
		if len(rs(2)) > 0 then munje_gesu = munje_gesu + 1
		if len(rs(3)) > 0 then munje_gesu = munje_gesu + 1
		if len(rs(4)) > 0 then munje_gesu = munje_gesu + 1
		if len(rs(5)) > 0 then munje_gesu = munje_gesu + 1
		if len(rs(6)) > 0 then munje_gesu = munje_gesu + 1
		if len(rs(7)) > 0 then munje_gesu = munje_gesu + 1
		if len(rs(8)) > 0 then munje_gesu = munje_gesu + 1
		if len(rs(9)) > 0 then munje_gesu = munje_gesu + 1
		if len(rs(10)) > 0 then munje_gesu = munje_gesu + 1
%>
		var check=0;
		for(i=0;i < <%=munje_gesu%>;i++){
			if (document.poll.reply<%=i%>[i].checked == true){
			check+=1;
			}
		}
		if (check==0){
		alert("<%=i%>번 설문을 체크해주시기 바랍니다.");
		return ;
		}
<%	else	%>
			if (document.poll.reply<%=i%>.value==""){
				alert("<%=i%>번 설문 답변을 입력해주시기 바랍니다.");
				return ;
			}
<%
	end if 

rs.movenext
i = i + 1
munje_gesu = 0
loop
rs.close
end if
%>
	document.poll.submit();		
}
</script>

<!-- #include file="../include/bottom.asp" --><%else %><!-- #include file = "../include/false_pg.asp" --><% end if%>