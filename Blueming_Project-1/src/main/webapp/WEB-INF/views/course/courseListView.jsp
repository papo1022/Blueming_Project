<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<jsp:include page="../common/menubar.jsp" />
	
	<div class="outer">
		<br>
		<h2 align="left">강의리스트</h2>
		<br>

		<br><br>

		<!-- 검색창 -->
		<div id="search-area" align="left">
			<form action="/blueming/course/search" method="get">
				<!-- 입력창/버튼 -->
				<input type="search" name="keyword" value="${ requestScope.keyword }">
				<button type="submit" class="btn btn-primary">검색</button>
			</form>
		</div>
	</div>

	<br><br>

	<!-- 로그인 유저의  -->
	<c:if test="${sessionScope.loginUser.userRole eq 'S' }">

	</c:if>
</body>
</html>