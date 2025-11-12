<%
Dim admin_manage,sql10,rs10

sql10 = "select manage from admin_mast where id = '"& request.cookies("adminid") &"'"
set rs10 = db.execute(sql10)

If rs10.eof Or rs10.bof Then
	response.write"<script>"
	response.write"alert('권한이 없습니다.');"
	response.write"self.location.href='../main/logout.asp';"
	response.write"</script>"
	response.end
Else
	admin_manage = rs10(0)
rs10.close
End if

Sub no_admin()

	response.write"<script>"
	response.write"alert('권한이 없습니다.');"
	response.write"self.location.href='../main/main.asp';"
	response.write"</script>"
	response.end

End Sub

if instr(request.ServerVariables("SCRIPT_NAME"),"/sub1/list.asp") Then 
	if instr(admin_manage,", a1,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub1/admin_list.asp") Then 
	if instr(admin_manage,", a2,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"sub1/ip_list.asp?gu=0") Then 
	if instr(admin_manage,", a3,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"sub1/ip_list.asp?gu=1") Then 
	if instr(admin_manage,", a4,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub1/bank_list.asp") Then 
	if instr(admin_manage,", a5,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub1/popup_list.asp") Then 
	if instr(admin_manage,", a6,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub1_icon_mast/") Then 
	if instr(admin_manage,", a7,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub1/mobile.asp") Then 
	if instr(admin_manage,", a8,") = 0 Then	no_admin()
End If

if instr(request.ServerVariables("SCRIPT_NAME"),"/sub2/list.asp") Then 
	if instr(admin_manage,", b1,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub2/favicon.asp") Then 
	if instr(admin_manage,", b2,") = 0 Then	no_admin()
End If

if instr(request.ServerVariables("SCRIPT_NAME"),"/sub3_group_mast/list.asp?gu=0") Then 
	if instr(admin_manage,", c1,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub3/list.asp") Then 
	if instr(admin_manage,", c2,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub3_member_auto/") Then 
	if instr(admin_manage,", c3,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub3/mileage.asp") Then 
	if instr(admin_manage,", c4,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub3/chulsuk1.asp") Then 
	if instr(admin_manage,", c5,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub3/memout.asp") Then 
	if instr(admin_manage,", c6,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub3/notid.asp") Then 
	if instr(admin_manage,", c7,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub3/mlist.asp") Then 
	if instr(admin_manage,", c8,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub3_group_mast/list.asp?gu=1") Then 
	if instr(admin_manage,", c9,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub3_sms/smslist.asp") Then 
	if instr(admin_manage,", c10,") = 0 Then	no_admin()
End If

if instr(request.ServerVariables("SCRIPT_NAME"),"/teach_category/list.asp") Then 
	if instr(admin_manage,", d1,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/teach/list.asp") Then 
	if instr(admin_manage,", d2,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/teach/write.asp") Then 
	if instr(admin_manage,", d3,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/teach_board/list.asp?gu=0") Then 
	if instr(admin_manage,", d4,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/teach_board/list.asp?gu=1") Then 
	if instr(admin_manage,", d5,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/teach_board/list.asp?gu=2") Then 
	if instr(admin_manage,", d6,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/teach_board/list.asp?gu=3") Then 
	if instr(admin_manage,", d7,") = 0 Then	no_admin()
End If

if instr(request.ServerVariables("SCRIPT_NAME"),"/shop_category/list.asp") Then 
	if instr(admin_manage,", e1,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/shop/list.asp") Then 
	if instr(admin_manage,", e2,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/shop/write.asp") Then 
	if instr(admin_manage,", e3,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/shop/auto.asp") Then 
	if instr(admin_manage,", e4,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/shop/order.asp") Then 
	if instr(admin_manage,", e5,") = 0 Then	no_admin()
End If

if instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/dan_list.asp") Or instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/mst_list.asp") Or instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/prium.asp") Then 
	if instr(admin_manage,", f1,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/dan_cate.asp") Or instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/mst_cate.asp") Then 
	if instr(admin_manage,", f2,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/coupon_list.asp") Or instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/coupon_input.asp") Or instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/coupon_price_list.asp") Or instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/coupon_price_input.asp") Then 
	if instr(admin_manage,", f3,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/view_rank.asp") Or instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/view_list.asp") Or instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/order_list.asp") Or instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/onlist.asp") Or instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/pay_list.asp") Then 
	if instr(admin_manage,", f4,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/list.asp") Or instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/premlist.asp") Or instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/mstlist.asp") Or instr(request.ServerVariables("SCRIPT_NAME"),"/sub4/danlist.asp") Then 
	if instr(admin_manage,", f5,") = 0 Then	no_admin()
End If

if instr(request.ServerVariables("SCRIPT_NAME"),"/quiz_category/list.asp") Then 
	if instr(admin_manage,", g1,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/quiz/list.asp") Then 
	if instr(admin_manage,", g2,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/quiz/input.asp") Then 
	if instr(admin_manage,", g3,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/quiz_result/list.asp") Then 
	if instr(admin_manage,", g4,") = 0 Then	no_admin()
End If

if instr(request.ServerVariables("SCRIPT_NAME"),"/sub5/nlist.asp") Then 
	if instr(admin_manage,", h1,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub5/qlist.asp") Then 
	if instr(admin_manage,", h2,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub5/flist.asp") Then 
	if instr(admin_manage,", h3,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub5/guide.asp") Then 
	if instr(admin_manage,", h4,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub5/banner_list.asp") Then 
	if instr(admin_manage,", h5,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub5_cal/list.asp") Then 
	if instr(admin_manage,", h6,") = 0 Then	no_admin()
End If

if instr(request.ServerVariables("SCRIPT_NAME"),"/sub6/") Then 
	if instr(admin_manage,", i1,") = 0 Then	no_admin()
End If

if instr(request.ServerVariables("SCRIPT_NAME"),"/sub7/main.asp") Then 
	if instr(admin_manage,", j1,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub7/month.asp") Then 
	if instr(admin_manage,", j2,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub7/day.asp") Then 
	if instr(admin_manage,", j3,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub7/dayofweek.asp") Then 
	if instr(admin_manage,", j4,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub7/hour.asp") Then 
	if instr(admin_manage,", j5,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub7/season.asp") Then 
	if instr(admin_manage,", j6,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub7/list.asp") Then 
	if instr(admin_manage,", j7,") = 0 Then	no_admin()
End If
if instr(request.ServerVariables("SCRIPT_NAME"),"/sub7/reset.asp") Then 
	if instr(admin_manage,", j8,") = 0 Then	no_admin()
End If


Dim menuAry(9)
menuAry(0) = "main"				''관리자메인
menuAry(1) = "sub1"			''환경설정
menuAry(2) = "sub2"			''디자인관리
menuAry(3) = "sub3"			''회원관리
menuAry(4) = "sub4"			''서비스관리
menuAry(5) = "sub5"			''운영관리
menuAry(6) = "sub6"			''커뮤니티
menuAry(7) = "sub7"			''접속통계
menuAry(8) = "sub8"			''선생님관리

Dim urlAry,folderNm
urlAry = Split(request.servervariables("PATH_INFO"),"/")
folderNm = urlAry(2)

Dim isNpg(8)

for ii = 0 to UBound(menuAry)
	if menuAry(ii) = folderNm then
		isNpg(ii) = True
	end if
Next 
%>
<!--#include file="../main/head.asp"-->

<body>

<div class="header">

<form name="tsearch" method="post" action="/yes_rad/sub3/list.asp">
<input type="hidden" name="searchpart" value="id">
	<div class="top">
		<div class="top_mem">
			<span>회원검색</span>
			<input type="text" name="searchstr" title="검색어 입력" value="아이디" onclick="document.tsearch.searchstr.value='';" />
			<a href="/yes_rad/main/logout.asp" class="btn_logout">로그아웃</a>
		</div>
	</div>
</form>

	<div class="meWrap">
		<h1><img src="/yes_rad/rad_img/img/logo.png" alt="예스소프트 관리자" onclick="self.location.href='/yes_rad/';" style="cursor:pointer" /></h1>
		<div class="menu">
			<a href="/yes_rad/main/main.asp" <% if InStr(request.ServerVariables("SCRIPT_NAME"),"/main") then response.write "class='on'" end if%>>HOME</a>
			<a href="/yes_rad/sub1/list.asp" <% if InStr(request.ServerVariables("SCRIPT_NAME"),"/sub1") then response.write "class='on'" end if%>>기본설정</a>			
			<a href="/yes_rad/sub5/nlist.asp" <% if InStr(request.ServerVariables("SCRIPT_NAME"),"/sub5") then response.write "class='on'" end if%>>운영관리</a>
			<a href="/yes_rad/sub3/list.asp" <% if InStr(request.ServerVariables("SCRIPT_NAME"),"/sub3") then response.write "class='on'" end if%>>회원관리</a>
			<a href="/yes_rad/sub4/dan_list.asp" <% if InStr(request.ServerVariables("SCRIPT_NAME"),"/sub4") then response.write "class='on'" end if%>>강좌관리</a>
			<a href="/yes_rad/sub6/blist.asp" <% if InStr(request.ServerVariables("SCRIPT_NAME"),"/sub6") then response.write "class='on'" end if%>>게시판관리</a>			
			<a href="/yes_rad/sub7/list.asp" <% if InStr(request.ServerVariables("SCRIPT_NAME"),"/sub7") then response.write "class='on'" end if%>>통계/DB관리</a>

			
		</div>
	</div>
</div>