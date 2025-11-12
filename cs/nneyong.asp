<!-- #include file="../include/set_loginfo.asp" -->
<!-- #include file="../include/dbcon.asp" -->
<%
Dim idx,intpg
dim jemok,neyong,wday,readnum

idx = Request("idx")
intpg = Request("intpg")

sql = "select jemok,neyong,wday,readnum from notice where idx=" & idx
set dr = db.execute(sql)


jemok = dr(0)
neyong = dr(1)
wday = dr(2)
readnum = dr(3)
dr.close

db.execute("update notice set readnum=readnum+1 where idx=" & idx)
%>
<!-- #include file="../include/head1.asp" -->
<!-- #include file="../include/top.asp" -->

<div class="smain">
	<!-- #include file="left.asp" -->
    <div class="content">
    	<div class="cont_tit">
        	<h3>공지사항</h3>
        </div>
        <div class="scont">

            <table class="ftbl" style="width:830px">
                    <colgroup>
                    <col style="width:20%" />
                    <col style="width:30%" />
                    <col style="width:20%" />
					<col style="width:30%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>제목</th>
                            <td colspan="3"><%=jemok%></td>
                        </tr>
                        <tr>
                            <th>작성일</th>
                            <td><%=wday%></td>
							<th>조회수</th>
                            <td><%=readnum%></td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="cmt" colspan="4"><%=neyong%></td>
                        </tr>
                    </tbody>
                </table>
            <div class="cbtn"> <a href="nlist.asp?intpg=<%=intpg%>&searchpart=<%=request("searchpart")%>&searchstr=<%=request("searchstr")%>" class="mbtn">목록으로</a> </div>

        </div>
    </div>
</div>



<!-- #include file="../include/bottom.asp" -->