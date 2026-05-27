<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Bluming</title>

<!-- alertify 라이브러리 연동 구문 -->
<!-- JavaScript -->
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
</head>
<body>
    <c:choose>
        <c:when test="${ not empty sessionScope.loginUser }">
            <div class="nav-area" align="center">
                <div class="menu"><a href="<c:url value='/'/>">Home</a></div>
                <div class="menu"><a href="<c:url value='/course/list'/>">Course</a></div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="nav-area" align="center">
                <div class="menu"><a href="<c:url value='/login'/>">로그인</a></div>
                <!-- 임시로 로그인 기능이 없어서 비로그인 상태로도 확인용 -->
                <div class="menu"><a href="<c:url value='/'/>">Home</a></div>
                <div class="menu"><a href="<c:url value='/course/list'/>">Course</a></div>
                <div class="menu"><a href="<c:url value='/memberlist'/>">memberlist</a></div>
                
            </div>
        </c:otherwise>
    </c:choose>
</body>
</html>