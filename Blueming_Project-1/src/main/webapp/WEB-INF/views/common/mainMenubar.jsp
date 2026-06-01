<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>blueming main menubar</title>
<script src="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/alertify.min.js"></script>

<!-- CSS -->
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/alertify.min.css"/>
<!-- Default theme -->
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/themes/default.min.css"/>
<!-- Semantic UI theme -->
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/themes/semantic.min.css"/>

<!-- 부트스트랩 -->
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

<!-- 간단한 동작들을 정의해둔 JS 파일 -->
<!-- 온라인 방식 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<!-- Popper JS -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<style>
 #user-info a {
		text-decoration : none;
		color : black;
		font-size : 12px;
	}
	.nav-area {
		background-color : black;
	}
	.menu {
		display : table-cell; /* 블록요소들을 가로로 배치 (가로길이가 짧아지더라도 옆으로 배치해줌) */
		height : 50px;
		width : 150px;
	}
	.menu>a {
		text-decoration : none;
		color : white;
		font-size : 17px;
		font-weight : 560;
		width : 100%;
		height : 100%;
		display : block;
		line-height : 50px;
		text-align : center;
	}
	.menu>a:hover {
		font-size : 18px;
		text-decoration : none;
		color : white;
	}
	
</style>
</head>
<body>


				<div class="nav-area" align="center">
		                <div class="menu"><a href="<c:url value='/'/>">Home</a></div>
		                <div class="menu"><a href="<c:url value='/course/list'/>">Course</a></div>
		                <div class="menu"><a href="<c:url value='/memberlist'/>">memberlist</a></div>
		                <div class="menu"><a href="<c:url value='/assignment/list'/>">Assignment</a></div>
		            </div>
					
					<div id="user-info">
					<b>${loginUser.name}</b> 님 환영합니다. <br><br>
		
					<div align="center">
						<a href="<c:url value='/member/myPage'/>">마이페이지</a>
						<a href="<c:url value='/member/logout'/>">로그아웃</a>
					</div>
					</div>

</body>
</html>