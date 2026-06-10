<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Blueming Main Menu</title>

<!-- Alertify -->
<script src="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/alertify.min.js"></script>
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/alertify.min.css"/>
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/themes/default.min.css"/>
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/themes/semantic.min.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberDashboard.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/menubar.css">

<!-- Bootstrap -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

<style>

    /* 왼쪽 사이드바
.nav-area {
    position: fixed;
    left: 0;
    top: 0;
    width: 220px;
    height: 100vh;
    background-color: #1976d2;
    display: flex;
    flex-direction: column;
    padding-top: 20px;
}
/* 메뉴 한 줄 
.menu {
    width: 100%;
    height: 50px;
}

/* 메뉴 링크 
.menu a {
    display: block;
    width: 100%;
    height: 100%;
    line-height: 50px;
    padding-left: 25px;
    color: white;
    font-weight: 600;
    text-decoration: none;
}

.menu a:hover {
    background-color: #1565c0;
    color: white;
}

.menu a:hover {
    color: white;
    font-size: 18px;
    text-decoration: none;
} */
    
</style>
</head>
<body>
    <c:url var="homeUrl" value="/"/>
    <c:if test="${not empty loginUser}">
        <c:choose>
            <c:when test="${loginUser.role eq 'S'}">
                <c:url var="homeUrl" value="/member/admin"/>
            </c:when>
            <c:when test="${loginUser.role eq 'R'}">
                <c:url var="homeUrl" value="/member/hr"/>
            </c:when>
            <c:when test="${loginUser.role eq 'N'}">
                <c:url var="homeUrl" value="/member/employee"/>
            </c:when>
        </c:choose>
    </c:if>

    <!-- 메뉴바 -->
    <div class="wrapper">
        <div class="nav-area">
            <div class="menu">
                <a href="${homeUrl}"><i class="fi fi-sr-computer"></i>
                &nbsp;&nbsp;대시보드
            </a><div>
                <c:choose>
                    <c:when test="${not empty loginUser}">
                        <nav class="sidebar-nav">
                            <ul>
                                <li>
                                    <a href="<c:url value='/notice/list'/>"><i class="fi fi-sr-megaphone"></i>
                                        공지
                                </a></li>
                                <li>
                                    <a href="<c:url value='/course/list'/>"><i class="fi fi-sr-graduation-cap"></i>
                                        코스
                                </a></li>

                                <c:if test="${loginUser.role eq 'R'}">
                                    <li>
                                        <a href="<c:url value='/assignment/list'/>"><i class="fi fi-sr-document"></i>
                                            인사과의 과제
                                    </a></li> 
                                    <li>
                                        <a href="<c:url value='/memberlist'/>"><i class="fi fi-sr-user"></i>
                                            사원조회
                                    </a></li> 
                                    <li>
                                        <a href="<c:url value='/enrollment/enrollMemList'/>"><i class="fi fi-sr-graduation-cap"></i>
                                            사원 강의관리
                                    </a></li> 
                                </c:if>

                                <c:if test="${loginUser.role eq 'S'}">
                                    <li>
                                        <a href="<c:url value='/adminAssignment/list'/>"><i class="fi fi-sr-document"></i>
                                            과제 전체 관리
                                    </a></li> 
                                </c:if>

                                <c:if test="${loginUser.role eq 'N'}">
                                    <li>
                                        <a href="<c:url value='/assignment/list'/>"><i class="fi fi-sr-document"></i>
                                            사원 과제
                                    </a></li> 
                                </c:if>
                            </ul>
                        </nav>
                    </c:when>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>