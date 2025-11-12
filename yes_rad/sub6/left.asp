<div class="aside">
		<h2>게시판관리</h2>
		<dl class="as_menu">

				<dt><a href="blist.asp">게시판목록</a></dt>
<%
sql = "select A.idx,A.jemok,(select count(idx) from board_board where tabnm = A.idx) from board_mast A order by ordnum asc,idx desc"
set dr = db.execute(sql)

				if not dr.bof or not dr.eof then
					dim bbsRows,bbsCols
					bbsRows = split(dr.getstring(2),chr(13))

					for ii = 0 to UBound(bbsRows) - 1
					bbsCols = split(bbsRows(ii),chr(9))%>
				<dt><a href="list.asp?tabnm=<%=bbsCols(0)%>"><%=bbsCols(1)%>(<%=bbsCols(2)%>)</a></dt>
<%
Next
				end if
				dr.close
%>  
		</dl>
		<!--#include file="../main/left_help.asp"-->
</div>