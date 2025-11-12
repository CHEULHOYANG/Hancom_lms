<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim dr,rownum,isRecod,isRows,isCols
dim rs,sql,rs1,sql1
dim name,idx
dim name1,idx1
dim name2,idx2
%>
<!-- #include file = "../main/top.asp" -->
<script type="text/javascript" src="/nicedit/nicEdit.js"></script>
<script type="text/javascript">
bkLib.onDomLoaded(function() {
	new nicEditor({fullPanel : true}).panelInstance('content');
});
</script>

<script>
function input_quiz(){
	var f = window.document.fm;

	if(f.ca1.value == "0"){
	alert("카테고리를 선택해주세요.");
	return;
	}
	
	if(f.cca1.value != "0"){
	
		if(f.cca1.value=="0"){
		alert("강좌를 선택해주세요.");
		return;
		}
		if(f.cca2.value=="0"){
		alert("강의를 선택해주세요.");
		return;
		}

	}

	if(f.title.value==""){
	alert("문제지제목을 입력해주세요.");
	f.title.focus();
	return;
	}

	clmn = f.content;
	clmn.value = nicEditors.findEditor('content').getContent();

	f.submit();
}
function check_upload(objtext1) {
  var ext = objtext1.value;
  ext = ext.substring(ext.length-3,ext.length);
  ext = ext.toLowerCase();
  if ((ext != 'jpg') &&(ext != 'gif')){
    alert('해당파일은 업로드가 불가능합니다.\n\n업로드 가능파일 jpg,gif');
	ext = "";
    return ;	 }

}  
function check_upload1(objtext1) {
  var ext = objtext1.value;
  ext = ext.substring(ext.length-3,ext.length);
  ext = ext.toLowerCase();
  if ((ext != 'mp3')){
    alert('해당파일은 업로드가 불가능합니다.\n\n업로드 가능파일 mp3파일');
	ext = "";
    return;	 }
} 

function cate_select(){

	var f = window.document.fm;
	var a1 = f.ca1.value;

	if(a1 == "0"){
		alert("분류명을 선택해주세요.");
		_data = "";
		$('#playArea').html(_data);	
		return;
	}

		$.ajax({
			url: "../../xml/quiz_cate.asp",
			type:"POST",
			data:{"key":""+a1+""},
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
function cate_select1(){

	var f = window.document.fm;
	var a1 = f.cca1.value;

	if(a1 == "0"){
		alert("분류명을 선택해주세요.");
		_data = "";
		$('#playArea1').html(_data);	
		return;
	}

		$.ajax({
			url: "/xml/quiz_section.asp",
			type:"POST",
			data:{"key":""+a1+""},
			dataType:"text",
			cache:false,
			processData:true,
			success:function(_data){								
				$('#playArea1').html(_data);						
			},
			error:function(xhr,textStatus){
			alert("[에러]원인:"+xhr.status+"                                     ");
			}	
		});	
		
}
function onlynum(objtext1){
				var inText = objtext1.value;
				var ret;
				for (var i = 0; i < inText.length; i++) {
				    ret = inText.charCodeAt(i);
					if (!((ret > 47) && (ret < 58)))  {
						alert("숫자만을 입력해주세요.");
						objtext1.value = "";
						objtext1.focus();
						return false;
					}
				}
				return true;
			}
</script>

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>시험지관리</h2>

<form action="input_ok.asp" method="post" name="fm" enctype="multipart/form-data">
		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>시험숨김</th>
						<td><input name="state" type="radio" value="0" checked > 아니오(노출)
<input type="radio" name="state" value="1" > 예(미노출)</td>
					</tr>
					<tr>
						<th>유료설정</th>
						<td><input name="price" type="radio" value="0" checked > 무료
<input type="radio" name="price" value="1" > 프리패스회원만 풀이가능 (강좌구매회원과 별도)
<input type="radio" name="price" value="2" > 쿠폰번호사용 <input name="sec" type="text" class="inptxt1 w200" id="sec" size="20"></td>
					</tr>

					<tr>
						<th>시험그룹설정</th>
						<td><%
sql = "select idx,title from group_mast where gu = 0 "
set rs=db.execute(sql)

if rs.eof or rs.bof then
else
do until rs.eof
%>
                                  <input type="checkbox" name="mem_group" id="mem_group" value="<%=rs(0)%>" /> <%=rs(1)%>&nbsp;
                        <%
rs.movenext
loop
rs.close
end if
%></td>
					</tr>
					<tr>
						<th>카테고리</th>
						<td><select name="ca1" class="seltxt w200" onChange="cate_select();">
  <option value="0">선택</option>
<%
sql="select idx,title from quiz_category where deep=0 order by ordnum asc,idx desc"
set rs=db.execute(sql)
if rs.eof or rs.bof then
else
do until rs.eof
%>
      <option value="<%=rs(0)%>"><%=rs(1)%></option>
<%
rs.movenext
Loop
rs.close
end if
%>
    </select>&nbsp;<span id="playArea"></span></td>
					</tr>


					<tr>
						<th>강좌선택</th>
						<td><select name='cca1' onChange='cate_select1()' class="seltxt w200">
                          <option value="0">미선택</option>
                          <%
											sql="select idx,strnm from LecturTab order by idx"
											set rs=db.execute(sql)
											if rs.eof or rs.bof then
											else
											do until rs.eof
											idx=rs(0)
											name=rs(1)											
											%>
                          <option value="<%=idx%>"><%=name%></option>
                          <%
											rs.movenext
											Loop
											rs.close
											end if
											%>
                        </select>&nbsp;<span id="playArea1"></span> <span class="stip">* 강좌선택시 해당강좌를 결제시만 풀이가능 (기능사용시 시험숨김을 하여 문제지를 미노출하는게 좋습니다)</span></td>
					</tr>
					<tr>
						<th>문제지제목</th>
						<td><input name="title" type="text" class="inptxt1 w400" id="title" size="80"></td>
					</tr>
					<tr>
						<th>반복풀기기능</th>
						<td><input name="munje_repeat" type="radio" value="0" checked> 예
                        <input type="radio" name="munje_repeat" value="1"> 아니오(1회만풀수있음)</td>
					</tr>
					<tr>
						<th>시간설정</th>
						<td><input name="munje_date1" type="radio" value="0" checked> 미사용
<input type="radio" name="munje_date1" value="1">  사용함
<input class="sdate" id="sdate" value="<%=Date()%>" name="sdate" readonly style="width:80px;border: 1px solid #dedfde;height:22px;" /> 일
<select name="munje_time1" class="seltxt" id="munje_time1">
  <option value="0" selected>미지정</option>
  <option value="01:00">01:00</option>
  <option value="02:00">02:00</option>
  <option value="03:00">03:00</option>
  <option value="04:00">04:00</option>
  <option value="05:00">05:00</option>
  <option value="06:00">06:00</option>
  <option value="07:00">07:00</option>
  <option value="08:00">08:00</option>
  <option value="09:00">09:00</option>
  <option value="10:00">10:00</option>
  <option value="11:00">11:00</option>
  <option value="12:00">12:00</option>
  <option value="13:00">13:00</option>
  <option value="14:00">14:00</option>
  <option value="15:00">15:00</option>
  <option value="16:00">16:00</option>
  <option value="17:00">17:00</option>
  <option value="18:00">18:00</option>
  <option value="19:00">19:00</option>
  <option value="20:00">20:00</option>
  <option value="21:00">21:00</option>
  <option value="22:00">22:00</option>
  <option value="23:00">23:00</option>
</select>
~
<select name="munje_time2" class="seltxt" id="munje_time2">
  <option value="0" selected>미지정</option>
  <option value="01:00">01:00</option>
  <option value="02:00">02:00</option>
  <option value="03:00">03:00</option>
  <option value="04:00">04:00</option>
  <option value="05:00">05:00</option>
  <option value="06:00">06:00</option>
  <option value="07:00">07:00</option>
  <option value="08:00">08:00</option>
  <option value="09:00">09:00</option>
  <option value="10:00">10:00</option>
  <option value="11:00">11:00</option>
  <option value="12:00">12:00</option>
  <option value="13:00">13:00</option>
  <option value="14:00">14:00</option>
  <option value="15:00">15:00</option>
  <option value="16:00">16:00</option>
  <option value="17:00">17:00</option>
  <option value="18:00">18:00</option>
  <option value="19:00">19:00</option>
  <option value="20:00">20:00</option>
  <option value="21:00">21:00</option>
  <option value="22:00">22:00</option>
  <option value="23:00">23:00</option>
</select>
에만 문제를 풀수있습니다.</td>
					</tr>
					<tr>
						<th>출제방법</th>
						<td><input name="munje_bang1" type="radio" value="0" checked>
                      순차적으로 풀기
                      <input type="radio" name="munje_bang1" value="1"> 
                      랜덤풀기</td>
					</tr>
					<tr>
						<th>풀이방법</th>
						<td><input name="munje_bang2" type="radio" value="0" checked>
모든문제 한번에 풀기
<input type="radio" name="munje_bang2" value="1"> 
한문제씩 풀기</td>
					</tr>
					<tr>
						<th>표출설정</th>
						<td><input name="admin_gu" type="checkbox" id="admin_gu" value="1"> 추천문제
                      <input name="admin_gu" type="checkbox" id="admin_gu" value="2"> 인기문제 
                      <input name="admin_gu" type="checkbox" id="admin_gu" value="3"> 보강문제</td>
					</tr>
					<tr>
						<th>풀이결과공개</th>
						<td><input name="sungjuk_show" type="radio" value="0" checked> 바로공개
<input type="radio" name="sungjuk_show" value="1"> 미공개</td>
					</tr>
					<tr>
						<th>풀이시간</th>
						<td><input name="munje_end_time" type="text" class="inptxt1 w60" id="munje_end_time" onKeyUp="onlynum(fm.munje_end_time);" value="60" size="8">
분 &nbsp; <span class="stip">2시간일경우 120분으로 입력하시면 됩니다. 시험시간 5분전 시험종료알림</span></td>
					</tr>
					<tr>
						<th>문항당답변갯수</th>
						<td><input name="munje_gesu" type="radio" value="2" checked> 2개
					  <input name="munje_gesu" type="radio" value="3"> 3개
					  <input name="munje_gesu" type="radio" value="4"> 4개
                      <input type="radio" name="munje_gesu" value="5">  5개</td>
					</tr>
					<tr>
						<th>선택답변구분</th>
						<td><input name="munje_gu" type="radio" value="0" checked> 숫자(1,2,3,4,5)&nbsp;
                      <input name="munje_gu" type="radio" value="1"> 한글(가,나,다,라,마)&nbsp;
                      <input name="munje_gu" type="radio" value="2"> 영문(A,B,C,D,E)</td>
					</tr>
					<tr>
						<th>문제지설명</th>
						<td><a href="javascript:popenWindow('/nicedit/upimg.asp?box=content','390','290');"><img src="../../nicedit/bt1.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/vod.asp?box=content','390','290');"><img src="../../nicedit/bt2.gif" border="0"></a><a href="javascript:popenWindow('/nicedit/files.asp?box=content','390','290');"><img src="../../nicedit/bt3.gif" border="0"></a><textarea name="content" id="content" rows="2" cols="20" style="width:600px; height:200px;"></textarea></td>
					</tr>
					<tr>
						<th>첨부파일</th>
						<td><input type="file" name="File3" class="inptxt1 w200" size="20" >
                      <span class="stip">* 문제를 푼후 다운받아볼수 있는 자료파일입니다.</span></td>
					</tr>
				</tbody>
			</table>
</form>

		<div class="rbtn">
			<a href="javascript:input_quiz();" class="btn">저장하기</a>
			<a href="list.asp" class="btn trans">목록보기</a>		
		</div>

	</div>
</div>

</body>
</html>
<!-- #include file = "../authpg_2.asp" -->

<link rel="stylesheet" href="../../include/pikaday.css">
<script src="../../include/moment.js"></script>
<script src="../../include/pikaday.js"></script>

<script>
    var picker = new Pikaday(
    {
        field: document.getElementById('sdate'),
        firstDay: 1,
		format: "YYYY-MM-DD",
        minDate: new Date('<%=left(date(),4)-10%>-01-01'),
        maxDate: new Date('<%=left(date(),4)+10%>-12-31'),
        yearRange: [<%=left(date(),4)-10%>,<%=left(date(),4)+10%>]
    });
</script>