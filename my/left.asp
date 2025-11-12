	<div class="nlnbWrap">
		<h2><%=t_menu8%></h2>
		<div class="nlnb">
			<dl>
				<dt><a href="01_main.asp">구매강좌목록</a></dt>
				<dd><a href="01_main.asp">구매강좌목록</a>
					<a href="02_paylist.asp">결제내역</a>
					<a href="07_coupon.asp">무료수강쿠폰등록</a>
					<a href="10_end_paper.asp">수료증출력</a></dd>
			</dl>
			<dl>
				<dt><a href="03_bguny.asp">장바구니</a></dt>
			</dl>

<%If Len(t_menu4) > 0 then%>
			<dl>
				<dt><a href="08_list.asp">주문/배송조회</a></dt>
			</dl>
<%End if%>
<%If Len(t_menu5) > 0 then%>
			<dl>
				<dt><a href="09_quiz_result.asp">문제풀이결과</a></dt>
			</dl>
<%End if%>

			<dl>
				<dt><a href="04_qlist.asp">게시글 관리</a></dt>
				<dd><a href="04_qlist.asp">내질문과 답변</a>
				<a href="13_list.asp"><%=t_menu6%> 게시글</a>
				<a href="14_list.asp"><%=t_menu3%> 게시글</a></dd>
			</dl>

			<dl>
				<dt><a href="05_myinfo.asp">회원정보</a></dt>
				<dd><a href="05_myinfo.asp">회원정보수정</a>
				<a href="11_mileage.asp">적립금내역</a>
				<a href="12_cal.asp">출석현황</a>
					<a href="06_myinfo_out.asp">회원탈퇴</a></dd>
			</dl>
		</div>

		<!-- #include file="../include/left2.asp" -->

		<!--  배너시작   -->
			<div style="text-align:center;">
			<% 
			sql = "select banner,banner_url,filegbn,target from banner where areagbn='046' order by  ordnum asc , idx desc"
			set dr = db.execute(sql)
			if not dr.bof or not dr.eof then
			do until dr.eof 
			response.write ""& BannerOutput(dr(0),dr(1),dr(2),200,dr(3)) &"<br /><br />"
			dr.movenext
			Loop
			end if
			dr.close %>					
			</div>
		<!--  배너끝  -->

	</div>