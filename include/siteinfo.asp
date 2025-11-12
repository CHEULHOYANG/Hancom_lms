<%
Dim objFso,strTname,strFile,arrConfig

set objFso = server.CreateObject("scripting.filesystemobject")

Dim s_name,a_email,shop_url,shop_title,shop_keyword,mem_mileage,b_money,b_money_total,mileage_use,mileage_from,mileage_to
Dim c_name,c_ceo,c_juso,c_number,c_tel,c_fax,c_comnumber,c_chage
Dim ksnetid,dacomid,card_system,banktownid
dim help_time1,help_time2,help_email,help_tel
dim tak_url
dim pay_select,sms_id
Dim name_check,name_id

''사이트정보
strTname="config"
strFile = Server.MapPath("..\") & "\ahdma\cfgini\"& strtname &".cfg"
''response.write configFile
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

End Function

Set objFso = Nothing
%>