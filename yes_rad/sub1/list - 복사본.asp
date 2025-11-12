<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<!-- #include file = "../../include/fso.asp" -->
<%
Dim s_name,a_email,shop_url,shop_title,shop_keyword,mem_mileage,b_money,b_money_total,mileage_use,mileage_from,mileage_to
Dim c_name,c_ceo,c_juso,c_number,c_tel,c_fax,c_comnumber,c_chage
Dim ksnetid,dacomid,card_system,banktownid
dim help_time1,help_time2,help_email,help_tel
dim tak_url
dim pay_select,sms_id
Dim name_check,name_id

strTname="config"
strFile = Server.MapPath("..\..\") & "\ahdma\cfgini\"& strtname &".cfg"
arrConfig = Split(ReadTextFile(strFile),chr(13))

''config ini 파일 안의 변수
s_name =			arrConfig(0)				''사이트이름
a_email =			arrConfig(1)				''관리자이메일
shop_url =		arrConfig(2)				''사이트주소
shop_title =		arrConfig(3)				''사이트Title
shop_keyword =	arrConfig(4)			''검색엔진키워드
help_time1 =		arrConfig(5)				''평일고객센터상담시간
help_time2 =		arrConfig(6)				''주말고객센터상담시간
help_email =		arrConfig(7)			''상담자이메일
help_tel =			arrConfig(8)				''상담및문의전화
mem_mileage =	arrConfig(9)			''회원가입마일리지
c_name =			arrConfig(10)			''회사명
c_ceo =			arrConfig(11)			''대표자이름
c_juso =			arrConfig(12)			''회사주소
c_number =		arrConfig(13)			''사업자번호
c_tel =			arrConfig(14)				''회사전화번호
c_fax =			arrConfig(15)				''회사팩스번호
c_comnumber =	arrConfig(16)		''통신판매업신고번호
c_chage =		arrConfig(17)			''개인정보책임자
b_money =		arrConfig(18)			''확장변수
b_money_total =	arrConfig(19)		''확장변수
mileage_use =		arrConfig(20)		''확장변수
mileage_from =	arrConfig(21)		''확장변수
mileage_to =		arrConfig(22)		''확장변수
ksnetid =			arrConfig(23)			''확장변수
dacomid =		arrConfig(24)			''확장변수
card_system =		arrConfig(25)		''확장변수
tak_url =			arrConfig(26)			''확장변수
banktownid =		arrConfig(27)		''확장변수
pay_select =		arrConfig(28)		''확장변수
sms_id =			arrConfig(29)			''확장변수
name_check =		arrConfig(30)		''확장변수
name_id =		arrConfig(31)			''확장변수

if shop_url = "" then
	shop_url = "http://" & request.ServerVariables("HTTP_HOST")
end If

Dim sns_kakao,sns_naver1,sns_naver2,sql,rs,huday,player1,player2,watermark,google_pwd

sql = "select kakao,naver1,naver2,huday,player1,player2,watermark,google_pwd from site_info"
Set rs=db.execute(sql)

If rs.eof Or rs.bof Then
Else
	
	sns_kakao = rs(0)
	sns_naver1 = rs(1)
	sns_naver2 = rs(2)
	huday = rs(3)
	player1 = rs(4)
	player2 = rs(5)
	watermark = rs(6)
	google_pwd = rs(7)

rs.close
End if
%>
<!--#include file="../main/top.asp"-->

<div class="container">
	<!--#include file="left.asp"-->
	<div class="content">
		<h2 class="cTit"><span class="bullet"></span>사이트정보관리</h2>


<form name="form1" method="post" action="config_ok.asp" style="display:inline;">

		<table class="ftbl mb50" style="width:100%">
				<colgroup>
				<col style="width:20%" />
				<col style="width:80%" />
				</colgroup>
				<tbody>
					<tr>
						<th>동영상 Player 사용설정</th>
						<td><input type="checkbox" name="player1" value="y" <%If Len(player1) > 0 Then Response.write"checked" End if%>> 동영상 Player1 사용
						<br/><input type="checkbox" name="player2" value="y" <%If Len(player2) > 0 Then Response.write"checked" End if%>> 동영상 Player2 사용 (추천)
						<br /><input type="checkbox" name="watermark" value="y" <%If Len(watermark) > 0 Then Response.write"checked" End if%>> 아이디워터마크사용 <span class="stip">* 워터마크 사용시 아이디가 동영상 재생중 보여지게 되며 전체화면에서는 미사용됩니다.</span></td>
					</tr>
					<tr>
						<th>사이트 이름</th>
						<td><input type="text" name="s_name" class="inptxt1 w400" value="<%=s_name%>"></td>
					</tr>
					<tr>
						<th>사이트 주소</th>
						<td><input type="text" name="shop_url" size="50" class="inptxt1 w400" value="<%=shop_url%>" ></td>
					</tr>
					<tr>
						<th>사이트 Title</th>
						<td><input type="text" name="shop_title" size="50" class="inptxt1 w500" value="<%=shop_title%>" ></td>
					</tr>
					<tr>
						<th>검색키워드</th>
						<td><textarea name="shop_keyword" cols="80" rows="4" class="inptxt1 w500" style="height:100px"><%=shop_keyword%></textarea></td>
					</tr>
					<tr>
						<th>관리자 이메일</th>
						<td><input type="text" name="a_email" class="inptxt1 w400" size="30" value="<%=a_email%>" ></td>
					</tr>
					<tr>
						<th>상담시간안내#1</th>
						<td><input type="text" name="help_time1" size="50" class="inptxt1 w400" value="<%=help_time1%>" ></td>
					</tr>
					<tr>
						<th>상담시간안내#2</th>
						<td><input type="text" name="help_time2" size="50" class="inptxt1 w400" value="<%=help_time2%>" ></td>
					</tr>
					<tr>
						<th>상담자이메일</th>
						<td><input type="text" name="help_email" size="50" class="inptxt1 w400" value="<%=help_email%>" ></td>
					</tr>
					<tr>
						<th>고객센터번호</th>
						<td><input type="text" name="help_tel" size="50" class="inptxt1 w400" value="<%=help_tel%>" ></td>
					</tr>
					<tr>
						<th>회사명</th>
						<td><input type="text" name="c_name" class="inptxt1 w400" value="<%=c_name%>" ></td>
					</tr>
					<tr>
						<th>대표자이름</th>
						<td><input type="text" name="c_ceo" class="inptxt1 w400" size="15" value="<%=c_ceo%>" ></td>
					</tr>
					<tr>
						<th>회사주소</th>
						<td><input type="text" name="c_juso" class="inptxt1 w400" size="80" value="<%=c_juso%>" ></td>
					</tr>
					<tr>
						<th>사업자번호</th>
						<td><input type="text" name="c_number" class="inptxt1 w400" value="<%=c_number%>" ></td>
					</tr>
					<tr>
						<th>회사전화번호</th>
						<td><input type="text" name="c_tel" class="inptxt1 w400" value="<%=c_tel%>" ></td>
					</tr>
					<tr>
						<th>회사팩스번호</th>
						<td><input type="text" name="c_fax" class="inptxt1 w400" value="<%=c_fax%>" ></td>
					</tr>
					<tr>
						<th>통신판매번호</th>
						<td><input type="text" name="c_comnumber" class="inptxt1 w400" value="<%=c_comnumber%>" ></td>
					</tr>
					<tr>
						<th>개인정보책임자</th>
						<td><input type="text" name="c_chage" size="15" class="inptxt1 w400" value="<%=c_chage%>" ></td>
					</tr>
					<tr>
						<th>아이피차단허용</th>
						<td><input name="name_id" type="radio" id="name_id" value="" <%if name_id = "" then response.write"checked" end if%>>
								   미사용
								   <input type="radio" name="name_id" id="name_id" value="1" <%if name_id = "1" then response.write"checked" end if%>>
								  사용
<span class="stip">최초 아이피3개를 저장후 그 이후에 저장되는 아이피는 차단합니다.</span></td>
					</tr>
					<tr>
						<th>프리패스회원사용여부</th>
						<td><input name="ksnetid" type="radio" id="radio" value="1" <%if ksnetid = "1" then response.write"checked" end if%>>
								   사용 
								   <input type="radio" name="ksnetid" id="radio2" value="2" <%if ksnetid = "2" then response.write"checked" end if%>>
								  미사용
<span class="stip">프리패스회원이란? 기간동안 패키지/단과를 제한없이 수강할수 있는 회원입니다.</span></td>
					</tr>
					<tr>
						<th>회원가입적립금</th>
						<td><input type="text" name="mem_mileage" size="10" class="inptxt1 w100" value="<%=mem_mileage%>"  onKeyPress="if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;" maxlength="5">
									<span class="stip">미적용시 0을 입력하시면 됩니다.</span></td>
					</tr>
					<tr>
						<th>로그인적립금</th>
						<td><input type="text" name="name_check" size="10" class="inptxt1 w100" value="<%=name_check%>"  onKeyPress="if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;" maxlength="5">
									<span class="stip">미적용시 0을 입력하시면 됩니다.</span></td>
					</tr>
					<tr>
						<th>휴강일설정</th>
						<td><input type="text" name="huday" size="10" class="inptxt1 w100" value="<%=huday%>"  onKeyPress="if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;" maxlength="5"> 일
									<span class="stip">미적용시 0을 입력하시면 됩니다.</span></td>
					</tr>
					<tr>
						<th>배송비설정</th>
						<td>교재구매 비용 총 합계가                                 
 <input name="banktownid" type="text" class="inptxt1 w100" id="banktownid"  onKeyPress="if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;" value="<%=banktownid%>" size="10">
 원
 이하면 
 배송비 
 <input name="pay_select" type="text" class="inptxt1 w100" id="pay_select"  onKeyPress="if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;" value="<%=pay_select%>" size="10">
 원이 추가됩니다.
<span class="stip">미적용시 0을 입력하시면 됩니다.</span></td>
					</tr>
					<tr>
						<th>문자서비스</th>
						<td><input type="text" name="sms_id" size="40" class="inptxt1 w400" value="<%=sms_id%>" >
									 <span class="stip"><a href="http://www.ppurio.com" target="_blank">http://www.ppurio.com</a> > 회원가입 > 문자충전후 아이디,발신번호(숫자만)를 &quot;,&quot;로 구분해서 입력하시면 됩니다. 발송아이피는 FTP아이피와 동일하게 입력하세요.</span></td>
					</tr>
					<tr>
						<th>카카오로그인</th>
						<td><input type="text" name="kakao" size="40" class="inptxt1 w400" value="<%=sns_kakao%>" >
									 <span class="stip"><a href="https://developers.kakao.com" target="_blank">https://developers.kakao.com</a> > 앱키 > JavaScript 키입력</span></td>
					</tr>
					<tr>
						<th>네이버로그인 Client ID</th>
						<td><input type="text" name="naver1" size="40" class="inptxt1 w400" value="<%=sns_naver1%>" >
									 <span class="stip"><a href="https://developers.naver.com" target="_blank">https://developers.naver.com</a> > 내애플리케이션 > 애플리케이션 > Client ID입력</span></td>
					</tr>
					<tr>
						<th>네이버로그인 Client Secret</th>
						<td><input type="text" name="naver2" size="40" class="inptxt1 w400" value="<%=sns_naver2%>" >
									 <span class="stip"><a href="https://developers.naver.com" target="_blank">https://developers.naver.com</a> > 내애플리케이션 > 애플리케이션 > Client Secret입력</span></td>
					</tr>
					<tr>
						<th>일정 휴일설정</th>
						<td><input type="text" name="google_pwd" size="40" class="inptxt1 w400" value="<%=google_pwd%>" >
									 <span class="stip">01-01,03-01,05-05,05-28,06-06,08-15,10-03,12-25 형태로 입력</span></td>
					</tr>
				</tbody>
			</table>
</form>
		<div class="rbtn">
			<a href="javascript:document.form1.submit();" class="btn">저장하기</a>
		</div>



	</div>
</div>


</body>
</html><%
Function ReadTextFile(fpath)
	Dim objFile,strReturnString
	Set objFile = objFso.OpenTextFile(fpath , 1)

	if objFile.AtEndOfStream then

		Dim aryNum

		for aryNum = 0 to 32
			strReturnString = strReturnString & chr(13)
		Next

	else

		strReturnString = objFile.readAll

	end if

ReadTextFile = strReturnString

objFile.Close

Set objFile = Nothing

End Function %>
<!-- #include file = "../authpg_2.asp" -->