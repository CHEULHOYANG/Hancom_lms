<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim sql,dr,isRecod,isRows,isCols,rs1
Dim intpg,blockPage,pagecount,recordcount,lyno
Dim gbnS,strsday,streday,strPart,strSearch
Dim varPage
Dim v_time,v_date,time1,time2,v_title
dim v1,h,m,s,rs,i
%>
<!--#include file="../main/top.asp"-->

<script>
function view_rank(id) {
	
	view_list.style.display = "";

	$.ajax({
		url: "/xml/view_rank_list.asp",
		type:"POST",
		data:{"id":""+id+""},
		dataType:"text",
		cache:false,
		processData:true,
		success:function(_data){								
			$('#playArea').html(_data);						
		},
		error:function(xhr,textStatus){
		alert("[에러]원인:"+xhr.status+"                                     ");
		}	
	});	

}
function view_rank_close() {
	_data = "";
	$('#playArea').html(_data);	
	view_list.style.display = "none";
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>다중접속체크관리</h2>

<form name="form1" method="get" action="<%=Request("URL")%>">
<input type="hidden" name="gbnS" value="1">
		<div class="schWrap1">
			<h3>검색</h3>
			<div class="sch_area1">
				<select id="strPart" name="strPart" class="seltxt w100">
				<option value="uid" <%if request("strPart") = "uid" then response.write"selected" end if%>>아이디</option>
                <option value="uname" <%if request("strPart") = "uname" then response.write"selected" end if%>>이름</option>
				</select>
				<input type="text" name="strSearch" id="strSearch" class="inptxt" value="<%=request("strSearch")%>" /></div>
			<a href="javascript:document.form1.submit();" class="btn_search1">검색</a>		
		</div>
</form>

		<table class="tbl" style="width:100%">
			<colgroup>
			<col style="width:8%" />
			<col />
			<col style="width:30%" />
			<col style="width:30%" />
			<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>	
					<th>아이디</th>
					<th>이름</th>
					<th>다른아이피접속횟수</th>	
					<th>상세보기</th>								
				</tr>				
			</thead>
			<tbody>
<%
If Len(request("strSearch")) > 0 Then
sql = "select sellCount=Count(ip),uid,uname from user_ip_check where gu = 0 and "& request("strPart") &" like '"& request("strSearch") &"' Group By uid,uname order by sellCount desc"
else
sql = "select sellCount=Count(ip),uid,uname from user_ip_check where gu = 0 Group By uid,uname order by sellCount desc"
End if
set rs=db.execute(Sql)

if rs.eof or rs.bof then
Else
i = 1
do until rs.eof

If rs(0) > 1 then
%>
						<tr>
							<td><%=i%></td>
							<td><%=rs(1)%></td>
							<td><%=rs(2)%></td>
							<td><%=rs(0)%>회</td>
						    <td><a href="javascript:view_rank('<%=rs(1)%>');" class="btns trans">상세보기</a></td>
						</tr>
<%
i=i+1
End if

rs.movenext
loop
rs.close
end if
%>
			</tbody>
		</table>


		<div class="caution"><p>클릭시 접속한 아이피 현황을 확인하실수 있습니다.</p></div>
		<div class="caution"><p>접속아이피가 다른 횟수로 정렬이 됩니다.</p></div>

	</div>
</div>


<style>
    .popup {
      position: fixed;
      top: 0;
      right: 0;
      bottom: 0;
      left: 0;
    }

    .popup_layer {
      position: relative;
      width: 750px;
      max-height: 500px;
      padding-bottom: 50px;
      background: #fff;
      z-index: 10;
	  overflow-y:scroll;
    }

    .text_area {
      padding: 5px 5px 5px 5px;
      text-align: center;
	  
    }

    .popup_dimmed {
      position: absolute;
      top: 0;
      right: 0;
      bottom: 0;
      left: 0;
      background: #000;
      opacity: 0.3;
    }



    /* 팝업 사이즈 고정 */

    /* IE7 이상 대응 */
    .popup_layer {
      position: absolute;
      top: 50%;
      left: 50%;
      width: 750px;
      height: 500px;
      padding-bottom: 50px;
      margin: -100px 0 0 -150px;
      background: #fff;
      z-index: 10;
    }

    /* IE8 이상 대응 */
    .popup_layer {
      position: absolute;
      top: 0;
      right: 0;
      bottom: 0;
      left: 0;
      width: 750px;
      height: 500px;
      padding-bottom: 50px;
      margin: auto;
      background: #fff;
      z-index: 10;
    }

  </style>

  <div class="popup" style="display:none" id="view_list">
    <div class="popup_layer">
      <div class="text_area" id="playArea"></div>
    </div>
    <div class="popup_dimmed"></div>
  </div>


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->