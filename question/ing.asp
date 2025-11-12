<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<%
Dim rs
dim page,recordcount,pagecount,totalpage,blockpage,pagesize,i
Dim idx,title,date1,date2,price,index

if request("page")="" then
   page=1
   else 
   page=request("page")
end if

pagesize = 10


%>
<!-- #include file="../include/head1.asp" -->

<!-- #include file="../include/top.asp" -->

<div class="smain">    
	<!-- #include file="left.asp" -->	
    <div class="content">
    	<div class="cont_tit">
        	<h3>진행중 설문</h3>
        </div>
        <div class="scont">
            <table class="btbl" style="width:830px">
                    <colgroup>
                    <col style="width:10%" />
                    <col />
                    <col style="width:16%" />
                    <col style="width:16%" />
                    <col style="width:10%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>기간</th>
                            <th>문항</th>
                            <th class="bkn">참여</th>
                        </tr>
                    </thead>
                    <tbody>
<%
sql = "select count(idx) as reccount from question_list where DateDiff(dd, getdate(), date1) <= 0 and DateDiff(dd, getdate(), date2) >= 0"
set rs=db.execute(sql)
recordcount =rs(0)
rs.close

pagecount=int((recordcount-1)/pagesize)+1
sql = "SELECT top " & pagesize & " idx,title,date1,date2,price,(select count(idx) from question_mast where ca = A.idx) FROM question_list A where DateDiff(dd, getdate(), date1) <= 0 and DateDiff(dd, getdate(), date2) >= 0 and idx not in"
sql = sql & "(select top " & ((page -1 ) * pagesize) & " idx from question_list where DateDiff(dd, getdate(), date1) <= 0 and DateDiff(dd, getdate(), date2) >= 0 order by idx desc ) order by idx desc"
set rs=db.execute(sql)

if rs.eof or rs.bof then
Else

Index = (pagesize + recordcount) - (page * pagesize) + 1		
do until rs.eof
Index = Index - 1

idx = rs(0)
title = rs(1)
date1 = rs(2)
date2 = rs(3)
price = rs(4)
%>
				<tr>
					<td><%=Index%></td>
					<td class="tl"><%=title%></td>
					<td><%=Replace(date1,"-",".")%>~<%=Replace(date2,"-",".")%></td>
					<td><%=rs(5)%>문항</td>
					<td><a href="javascript:go2Logpg(<%=strProg%>,'/question/poll.asp?idx=<%=idx%>&page=<%=page%>');" class="mini_sbtn">참여하기</a></td>
				</tr>
<%
rs.movenext
Loop
rs.close
End if
%>
                    </tbody>
                </table>
            <!--  테이블 Paging 부분     -->
<div class="paging"><%
blockPage=Int((page-1)/10)*10+1
if blockPage = 1 Then
Else
%>
                <a href="?page=<%=blockPage-10%>"><img src="../img/img/a_prev1.gif" alt="이전페이지"></a>
                <%
End If
   i=1
   Do Until i > 10 or blockPage > pagecount
      If blockPage=int(page) Then
%>
                <strong><%=blockPage%></strong>
                <%Else%>
                <a href="?page=<%=blockPage%>" class="pnum"><%=blockPage%></a>
              <%
    End If    
    blockPage=blockPage+1
    i = i + 1
    Loop
if blockPage > pagecount Then
Else
%>
                <a href="?page=<%=blockPage%>"><img src="../img/img/a_next1.gif" alt="다음페이지"></a>
                <%
End If
%></div>	

        </div>
    </div>
</div>

<!-- #include file="../include/bottom.asp" -->