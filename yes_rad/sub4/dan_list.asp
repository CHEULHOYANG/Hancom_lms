<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" --><%
Dim sql,dr,isRecod,isRows,isCols,totalnum,rs
Dim intpg,blockPage,pagecount,recordcount,lyno
Dim gbnS,ca1,ca2,strSearch
Dim tabnm : tabnm = "LecturTab"
Dim varPage
dim icon,icon_count,jj
dim bcount,bidx,i

Dim nowPage : nowPage = Request("URL")

intpg = Request("intpg")

if intpg = "" then
	intpg = 1
else
	intpg = int(intpg)
end if

const pagesize = 40

Dim strClmn : strClmn = " idx,strnm,strteach,totalnum,icon,book_idx,ordn,inginum,state,readnum "

gbnS = Request("gbnS")
ca1 = Request("ca1")
ca2 = Request("ca2")
strSearch = Request("strSearch")

if Len(ca1) = 0 And Len(ca2) = 0 then
	if gbnS = "" then
		sql = "select count(idx) from " & tabnm
		set dr = db.execute(sql)
		recordcount = int(dr(0))

		if recordcount > 0 then
			isRecod = True
			pagecount=int((recordcount-1)/pagesize)+1
			lyno = recordcount - ((intpg - 1) * pagesize)
			sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm
			sql = sql & " order by ordn asc) order by ordn asc"
		end if
	else
		sql = "select count(idx) from " & tabnm & " where strnm like '%" & replace(strSearch,"'","''") & "%'"
		set dr = db.execute(sql)
		recordcount = int(dr(0))

		if recordcount > 0 then
			isRecod = True
			pagecount=int((recordcount-1)/pagesize)+1
			lyno = recordcount - ((intpg - 1) * pagesize)
			sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where strnm like '%" & replace(strSearch,"'","''") & "%' and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm
			sql = sql & " where strnm like '%" & replace(strSearch,"'","''") & "%' order by ordn asc,idx desc) order by ordn asc,idx desc"
		end if
	end if
else
	if gbnS = "" Then
		
		If Len(ca2) = 0 then
		sql = "select count(idx) from " & tabnm & " where ca1=" & ca1
		Else
		sql = "select count(idx) from " & tabnm & " where ca1=" & ca1 &" and ca2 = "& ca2 &""
		End if
		set dr = db.execute(sql)
		recordcount = int(dr(0))

		if recordcount > 0 then
			isRecod = True
			pagecount=int((recordcount-1)/pagesize)+1
			lyno = recordcount - ((intpg - 1) * pagesize)
			If Len(ca2) = 0 then
			sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where ca1 = "& ca1 &" and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm
			sql = sql & " where ca1 = "& ca1 &" order by ordn asc) order by ordn asc"
			Else
			sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where ca1 = "& ca1 &" and ca2 = "& ca2 &" and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm
			sql = sql & " where ca1 = "& ca1 &" and ca2 = "& ca2 &" order by ordn asc) order by ordn asc"
			End if
		end if
	else
		If Len(ca2) = 0 then
		sql = "select count(idx) from " & tabnm & " where ca1 = "& ca1 &" and strnm like '%" & replace(strSearch,"'","''") & "%'"
		Else
		sql = "select count(idx) from " & tabnm & " where ca1 = "& ca1 &" and ca2 = "& ca2 &" and strnm like '%" & replace(strSearch,"'","''") & "%'"
		End if
		set dr = db.execute(sql)
		recordcount = int(dr(0))

		if recordcount > 0 then
			isRecod = True
			pagecount=int((recordcount-1)/pagesize)+1
			lyno = recordcount - ((intpg - 1) * pagesize)
			If Len(ca2) = 0 then
			sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where ca1 = "& ca1 &" and strnm like '%" & replace(strSearch,"'","''") & "%' and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm
			sql = sql & " where ca1 = "& ca1 &" and strnm like '%" & replace(strSearch,"'","''") & "%' order by ordn asc,idx desc) order by ordn asc,idx desc"
			Else
			sql = "select  top " & pagesize & strClmn & "from " & tabnm & " where ca1 = "& ca1 &" and ca2 = "& ca2 &" and strnm like '%" & replace(strSearch,"'","''") & "%' and idx not in (select top " & ((intpg -1 ) * pagesize) & " idx from " & tabnm
			sql = sql & " where ca1 = "& ca1 &" and ca2 = "& ca2 &" and strnm like '%" & replace(strSearch,"'","''") & "%' order by ordn asc,idx desc) order by ordn asc,idx desc"
			End if
		end if
	end if
end if
varPage = "gbnS=" & gbnS & "&strSearch=" & strSearch & "&ca1=" & ca1 &"&ca2="& ca2 &""
%>
<!--#include file="../main/top.asp"-->

<script language="javascript">
function go2ListPage(pg){
	document.location.href="<%=nowPage%>?intpg=" + pg + "&<%=varPage%>";
}

function delDan(idxn){
	var delok = confirm("단과를 삭제하시겠습니까?\n\n이 단과에 해당된 모든 강의도 삭제 됩니다.                                                ");
	if(delok){
		location.href="dan_delete.asp?intpg=<%=intpg%>&gbnS=<%=Request("gbnS")%>&strPart=<%=Request("strPart")%>&strSearch=<%=Request("strSearch")%>&idx=" + idxn;
	}
}
function copy_dan(idxn){
	var delok = confirm("단과를 복제하시겠습니까?\n\n이 단과에 해당된 모든 강의도 복제 됩니다.                                                ");
	if(delok){
		location.href="dan_copy.asp?intpg=<%=intpg%>&gbnS=<%=Request("gbnS")%>&strPart=<%=Request("strPart")%>&strSearch=<%=Request("strSearch")%>&idx=" + idxn;
	}
}

function go2Search(){

	var clmn = document.form1.strSearch;

	if(clmn.value==""){
		alert("조회할 단어를 입력해주세요!");
		clmn.focus();
		return;
	}

	if(clmn.value.replace(/ /g,"")==""){
		alert("조회할 단어를 입력해주세요!");
		clmn.select();
		return;
	}

	if(clmn.value.length < 2){
		alert("조회할 단어는 2자 이상 입력해야 합니다.");
		clmn.select();
		return;
	}

	document.form1.submit();

}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>단과강좌관리</h2>

<form name="form1" method="get" action="<%=nowPage%>">
<input type="hidden" name="gbnS" value="s">
		<div class="tbl_top">
			<select class="seltxt w200" name="ca1" onChange="location.href='<%=nowPage%>?ca1=' + this.value;">
										<option value="">전체</option><% set dr = db.execute("select idx,title from dan_category where deep=0 order by ordnum asc,idx desc")
										if not dr.bof or not dr.eof then
										do until dr.eof %>
										<option<% if ca1 = CStr(dr(0)) then response.write " selected"%> value="<%=dr(0)%>"><%=dr(1)%></option><% dr.moveNext
										loop
										end if
										dr.close %>
									</select>
									<%If Len(ca1) > 0 then%>
									<select class="seltxt w200" name="ca2" onChange="location.href='<%=nowPage%>?ca1=<%=ca1%>&ca2='+this.value;">
										<option value="">전체</option><% set dr = db.execute("select idx,title from dan_category where deep=1 and uidx="& ca1 &" order by ordnum asc,idx desc")
										if not dr.bof or not dr.eof then
										do until dr.eof %>
										<option<% if ca2 = CStr(dr(0)) then response.write " selected"%> value="<%=dr(0)%>"><%=dr(1)%></option><% dr.moveNext
										loop
										end if
										dr.close %>
									</select><%End if%>&nbsp;<input type="text" name="strSearch" class="inptxt1 w200" value="<%=request("strSearch")%>" > <a href="javascript:go2Search();" class="fbtn">검색</a>	 <a href="dan_reg.asp" class="fbtn1">단과 등록하기</a>	 <a href="dan_list_vod_link.asp" class="fbtn2">동영상주소 일괄변경</a>
			<span class="tbl_total">전체 <%=recordcount%>건 (<%=intpg%>page/<%=pagecount%>pages)</span>
		</div>
</form>

<% if isRecod then
				set dr = db.execute(sql)
				isRows = split(dr.GetString(2),chr(13)) %>
		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:5%" />
			<col style="width:5%" />
			<col style="width:5%" />
			<col />
			<col style="width:8%" />
			<col style="width:8%" />
			<col style="width:8%" />
			<col style="width:15%" />
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>	
					<th>순번</th>
					<th>고유번호</th>
					<th>강좌명</th>	
					<th>강사</th>	
					<th>강의수</th>	
					<th>조회</th>	
					<th>삭제</th>			
				</tr>				
			</thead>
			<tbody>
<% for ii = 0 to UBound(isRows) - 1
						isCols = split(isRows(ii),chr(9)) 
						
						sql = "select count(idx) from sectionTab where l_idx=" & isCols(0)
						set rs = db.execute(sql)

						totalnum = rs(0)
						rs.close
						
						bidx = split(isCols(5),",")
bcount = ubound(bidx)
						%>
						<tr>
							<td><%=lyno%></td>
							<td><%=isCols(6)%></td>
							<td><%=isCols(0)%></td>
							<td class="tl"><%If isCols(8) =1 Then Response.write"<font color='#336699'>[숨김]</font>&nbsp;" End if%>
							<%If isCols(7) =1 Then Response.write"<font color='#cc0000'>[메인]</font>&nbsp;" End if%>
							<span style="cursor:pointer;" onMouseOver="this.style.color='#FF6600';" onMouseOut="this.style.color='#000000';" onClick="location.href='dan_neyong.asp?idx=<%=isCols(0)%>&intpg=<%=intpg%>&<%=varPage%>';"><strong><%=isCols(1)%></strong><%if bcount > 0 then response.write"&nbsp;&nbsp;<font color=#336699>-&nbsp;교재판매중("& bcount &"개)</font>" end if%></span><%
                        	
				icon = split(isCols(4),",")
				icon_count = ubound(icon)
				for jj=0 to icon_count
					if len(trim(icon(jj))) > 5 then
					response.write "&nbsp;<img src='../../ahdma/logo/"& trim(icon(jj)) &"'>"
					end if
				next						
				%></td>
				<td><%=isCols(2)%></td>
							<td><%=totalnum%>강</td>
							<td><%=isCols(9)%></td>
							<td><a href="sec_list.asp?idx=<%=isCols(0)%>&intpg=<%=intpg%>&<%=varPage%>" class="btns">강좌관리</a> <a href="javascript:delDan('<%=isCols(0)%>');" class="btns trans">삭제</a>&nbsp;<a href="javascript:copy_dan('<%=isCols(0)%>');" class="btns trans">복사</a></td>
						</tr><% lyno = lyno - 1
						Next %>
			</tbody>
		</table>

		<div class="cbtn">
<%
blockPage = int((intpg-1)/10) * 10 + 1
%>
			<div class="paging">
			<% if blockPage > 1 Then %>
				<a href="javascript:go2ListPage('1');"><img src="/yes_rad/rad_img/img/a_prev2.gif" alt="처음페이지"></a>
				<a href="javascript:go2ListPage('<%=int(blockPage-1)%>');"><img src="/yes_rad/rad_img/img/a_prev1.gif" alt="이전페이지" /></a>
			<%End if%>
			<% ii = 1
									Do Until ii > 10 or blockPage > pagecount
									if blockPage = int(intpg) then %>
				<strong><%=blockPage%></strong><% else %>
				<a href="javascript:go2ListPage('<%=blockPage%>');" class="num"><%=blockPage%></a>
				<% end if
									blockPage = blockPage + 1
									ii = ii + 1
									Loop %>
			<% if blockPage > pagecount then 
			else
			%>
				<a href="javascript:go2ListPage('<%=blockPage%>');"><img src="/yes_rad/rad_img/img/a_next1.gif" alt="다음페이지"></a>
				<a href="javascript:go2ListPage('<%=pagecount%>');"><img src="/yes_rad/rad_img/img/a_next2.gif" alt="마지막페이지"></a>
			<%End if%>
			</div>
		</div>

<%End if%>

<div class="caution"><p>단과강좌를 구성하기전 꼭 단과카테고리부터 등록해주시기 바랍니다.</p></div>
<div class="caution"><p>단과를 등록하셔야 패키지를 구성하실수 있습니다.</p></div>
<div class="caution mb80"><p>강의는 순번에 의해서 정렬이 됩니다.</p></div>

	</div>
</div>



</body>
</html>
<!-- #include file = "../authpg_2.asp" -->