<!-- #include file = "../authpg_1.asp" -->
<!-- #include file = "../../include/fso.asp" -->
<!-- #include file = "../../include/dbcon.asp" -->
<%
Dim s_name,a_email,shop_url,shop_title,shop_keyword,mem_mileage,b_money,b_money_total,mileage_use,mileage_from,mileage_to
Dim c_name,c_ceo,c_juso,c_number,c_tel,c_fax,c_comnumber,c_chage
Dim strString,strFileName
Dim ksnetid,dacomid,card_system,banktownid
Dim help_time1,help_time2,help_email,help_tel
Dim tak_url
Dim pay_select,sms_id
Dim name_check,name_id
Dim sql,rs,kakao,naver1,naver2,huday,player1,player2,watermark,google_pwd,kullus1,kullus2,player3

google_pwd = request.form("google_pwd")
player1 = request.form("player1")
player2 = request.form("player2")
player3 = request.form("player3")
watermark = request.form("watermark")
kakao = request.form("kakao")
naver1 = request.form("naver1")
naver2 = request.form("naver2")
huday = request.form("huday")
If Len(huday) = 0 Then huday = 0

kullus1 = request.form("kullus1")
kullus2 = request.form("kullus2")

If Len(player3) > 0 Then
	player1 = ""
	player2 = ""
	watermark = ""
End if

kakao = Tag2Txt(kakao)
naver1 = Tag2Txt(naver1)
naver2 = Tag2Txt(naver2)

sql = "select count(*) from site_info"
Set rs=db.execute(sql)

If rs(0) = 0 Then

	sql = "insert  into site_info (kakao,naver1,naver2,huday,player1,player2,watermark,google_pwd,kullus1,kullus2,player3) values ('" & kakao & "','" & naver1 & "','"& naver2 &"',"& huday &",'"& player1 &"','"& player2 &"','"& watermark &"','"& google_pwd &"','"& kullus1 &"','"& kullus2 &"','"& player3 &"')"
	db.execute(sql)

Else

	sql = "update site_info set kullus1 = '"& kullus1 &"',kullus2 = '"& kullus2 &"',player3 = '"& player3 &"',google_pwd = '"& google_pwd &"',watermark = '"& watermark &"',player1='" & player1 & "',player2='" & player2 & "',kakao='" & kakao & "',naver1='" & naver1 & "',naver2='" & naver2 & "',huday="& huday &""
	db.execute(sql)

rs.close
End if


Dim arrStr()
ReDim arrStr(31)

arrStr(0)		= Request.Form("s_name")					''사이트이름
arrStr(1)		= Request.Form("a_email")					''관리자이메일
arrStr(2)		= Request.Form("shop_url")					''사이트주소
arrStr(3)		= Request.Form("shop_title")				''사이트Title
arrStr(4)		= Request.Form("shop_keyword")		''검색엔진키워드
arrStr(5)		= Request.Form("help_time1")				''평일고객센터상담시간
arrStr(6)		= Request.Form("help_time2")				''주말고객센터상담시간
arrStr(7)		= Request.Form("help_email")				''상담자이메일
arrStr(8)		= Request.Form("help_tel")					''상담및문의전화
arrStr(9)		= Request.Form("mem_mileage")			''회원가입마일리지
If Len(arrStr(9)) = 0 Then arrStr(9) = 0

arrStr(10)	= Request.Form("c_name")					''회사명
arrStr(11)	= Request.Form("c_ceo")						''대표자이름
arrStr(12)	= Request.Form("c_juso")					''회사주소
arrStr(13)	= Request.Form("c_number")				''사업자번호
arrStr(14)	= Request.Form("c_tel")						''회사전화번호
arrStr(15)	= Request.Form("c_fax")						''회사팩스번호
arrStr(16)	= Request.Form("c_comnumber")		''통신판매업신고번호
arrStr(17)	= Request.Form("c_chage")					''개인정보책임자
arrStr(18)	= Request.Form("b_money")					''확장변수
arrStr(19)	= Request.Form("b_money_total")			''확장변수
arrStr(20)	= Request.Form("mileage_use")			''확장변수
arrStr(21)	= Request.Form("mileage_from")			''확장변수
arrStr(22)	= Request.Form("mileage_to")				''확장변수
arrStr(23)	= Request.Form("ksnetid")					''확장변수
arrStr(24)	= Request.Form("dacomid")					''확장변수
arrStr(25)	= Request.Form("card_system")			''확장변수
arrStr(26)	= Request.Form("tak_url")						''확장변수
arrStr(27)	= Request.Form("banktownid")				''확장변수
If Len(arrStr(27)) = 0 Then arrStr(27) = 0

arrStr(28)	= Request.Form("pay_select")				''확장변수
If Len(arrStr(28)) = 0 Then arrStr(28) = 0

arrStr(29)	= Request.Form("sms_id")					''확장변수
arrStr(30)	= Request.Form("name_check")			''확장변수
If Len(arrStr(30)) = 0 Then arrStr(30) = 0

arrStr(31)	= Request.Form("name_id")					''확장변수

arrStr(4) = Replace(arrStr(4),chr(13)&chr(10)," ")
if arrStr(9) = "" then
	arrStr(9) = "0"
end if

Dim aryNum

strString = ""

for aryNum = 0 to UBound(arrStr)
	strString = strString & onlyTxt(arrStr(aryNum)) & chr(13)
Next

Function onlyTxt(inStr)
	inStr = Trim(inStr)
	inStr = Replace(inStr,"<","&lt;")
	inStr = Replace(inStr,">","&gt;")
	onlyTxt = inStr
End Function

Function Tag2Txt(s)
	s = Replace(s,"'","''")
	s = Replace(s,"<","&lt;")
	s = Replace(s,">","&gt;")
	s = Replace(s,"&","&amp;")
	Tag2Txt = s
End Function

strTname = "config"
strFile = Server.MapPath("../../") & "/ahdma/cfgini/"& strtname &".cfg"

Dim objFile
Set objFile = objFso.CreateTextFile(strFile,True)
objFile.WriteLine strString


objFile.Close
Set objFile = Nothing
Set objFso = Nothing 



response.write"<script>"
response.write"alert('설정이 저장되었습니다.');"
response.write"self.location.href='list.asp';"
response.write"</script>"
response.end

%>
<!-- #include file = "../authpg_2.asp" -->