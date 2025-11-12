<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim einfo1,einfo2,einfo3,einfo4,einfo5,einfo6,einfo7,einfo8,einfo9,einfo10
Dim sql,rs

sql="select info1,info2,info3,info4,info5,info6,info7,info8,info9,info10 from end_paper_config"
set rs=db.execute(sql)

if rs.eof or rs.bof Then

	einfo1 = "타이틀1"
	einfo2 = "타이틀2"
	einfo3 = "타이틀3"
	einfo4 = "타이틀4"
	einfo5 = "타이틀5"
	einfo6 = "타이틀6"
	einfo7 = "타이틀7"
	einfo8 = "타이틀8"
	einfo9 = "타이틀9"
	einfo10 = "타이틀10"

Else

	einfo1 = rs(0)
	einfo2 = rs(1)
	einfo3 = rs(2)
	einfo4 = rs(3)
	einfo5 = rs(4)
	einfo6 = rs(5)
	einfo7 = rs(6)
	einfo8 = rs(7)
	einfo9 = rs(8)
	einfo10 = rs(9)

rs.close
end if
%>
<!--#include file="../main/top.asp"-->

<script>
function paper_input(){

	var f = window.document.fm;

	if(f.title.value==""){
	alert("수료증제목을 입력해주세요.");
	f.title.focus();
	return;
	}
	if(f.id.value==""){
	alert("아이디를 입력해주세요.");
	f.id.focus();
	return;
	}


	f.submit();

}

function mSelected( SObj ){

	var objEntity = multiSelected( SObj );

	var entity = new Array();
	var entityvalue = new String();
	var a = new String();

	for ( var i = 0; i < objEntity.length - 1; ++i ){

		a = objEntity[i];
		if ( SObj[a].value ) entity[i] = SObj[a].value;
	}

	entityvalue = entity.join('^');

	return entityvalue;
}
function multiSelected( fmObj ){

	var lengths = fmObj.length;
	var saveIndex = new String();

	for ( var i = 0; i < lengths; ++i ){

		if ( fmObj.options[i].selected == true ){
			saveIndex = i + ";" + saveIndex;
		}
	}

	var retIndexsavearr = new Array();
	retIndexsavearr = saveIndex.split( ";" );

	return retIndexsavearr;
}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>수료증관리</h2>

<form action="input_ok.asp" method="post" name="fm" enctype="multipart/form-data">
<input name="id" type="hidden" id="id" >

<div class="tbl_top">
<select name="sugoodlist" multiple class="seltxt" style="width:100%;height:200px;" size="17" onChange="javascript:document.fm.id.value=mSelected( this );">
<%
sql="select idx,name,id,email from member order by name asc,idx desc"
set rs=db.execute(sql)			

if rs.eof or rs.bof then
else
do until rs.eof

%>
      <option value="<%=rs(2)%>"><%=rs(1)%>&nbsp;/&nbsp;<%=rs(2)%>&nbsp;/&nbsp;<%=rs(3)%></option>
<%
rs.movenext
loop
rs.close
end if
%>
      </select>
</div>

<div class="caution"><p>회원을 한명씩 선택하시거나 마우스로 드래그 하셔서 선택이 가능합니다. 컨트롤 + 선택을 하시면 한명씩 따로 지정이 가능합니다.</p></div>

		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>발급번호</th>
						<td><input name="info8" type="text" class="inptxt1 w200" id="info8" ></td>
					</tr>
					<tr>
						<th>수료증제목</th>
						<td><input name="title" type="text" class="inptxt1 w400" id="title" ></td>
					</tr>
					<tr>
						<th>수료증파일</th>
						<td><input type="file" name="files" class="inptxt1 w200"></td>
					</tr>
<%If Len(einfo2) >0 then%>
                  <tr>
                    <th><%=einfo2%></th>
                    <td><input name="info2" type="text" class="inptxt1 w400" id="info2" ></td>
                  </tr>
<%End if%>

<%If Len(einfo3) >0 then%>
                  <tr>
                    <th><%=einfo3%></th>
                    <td><input name="info3" type="text" class="inptxt1 w400" id="info3" >                    </td>
                  </tr>
<%End if%>

<%If Len(einfo4) >0 then%>
                  <tr>
                    <th><%=einfo4%></th>
                    <td><input name="info4" type="text" class="inptxt1 w400" id="info4" >                    </td>
                  </tr>
<%End if%>

<%If Len(einfo5) >0 then%>
                  <tr>
                    <th><%=einfo5%></th>
                    <td><input name="info5" type="text" class="inptxt1 w400" id="info5" >                    </td>
                  </tr>
<%End if%>

<%If Len(einfo6) >0 then%>
                  <tr>
                    <th><%=einfo6%></th>
                    <td><input name="info6" type="text" class="inptxt1 w400" id="info6" >                    </td>
                  </tr>
<%End if%>

<%If Len(einfo7) >0 then%>
                  <tr>
                    <th><%=einfo7%></th>
                    <td><input name="info7" type="text" class="inptxt1 w400" id="info7" ></td>
                  </tr>
<%End if%>
					
				</tbody>
			</table>



		<div class="rbtn">
			<a href="javascript:paper_input();" class="btn">저장하기</a>
			<a href="javascript:history.back();" class="btn trans">목록보기</a>		
		</div>
</form>

	</div>
</div>


</body>
</html>
<!-- #include file = "../authpg_2.asp" -->