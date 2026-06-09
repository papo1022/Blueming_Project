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

<!-- Bootstrap -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

<style>
    #user-info {
        margin-top: 20px;
        text-align: center;
    }

    #user-info a {
        text-decoration: none;
        color: black;
        font-size: 12px;
        margin: 0 10px;
    }

    .nav-area {
        background-color: black;
        display: flex;
        justify-content: center;
    }

    .menu {
        width: 150px;
        height: 50px;
    }

    .menu a {
        display: block;
        width: 100%;
        height: 100%;
        line-height: 50px;
        text-align: center;
        text-decoration: none;
        color: white;
        font-size: 17px;
        font-weight: 600;
    }

    .menu a:hover {
        color: white;
        font-size: 18px;
        text-decoration: none;
    }
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
            <c:otherwise>
                <c:url var="homeUrl" value="/member/employee"/>
            </c:otherwise>
        </c:choose>
    </c:if>

<!-- 메뉴바 -->
	<div class="nav-area" align="center">
        <div class="menu"><a href="${homeUrl}">Home</a></div>
	    <div class="menu"><a href="<c:url value='/notice/list'/>">Notice</a></div>
	    <div class="menu"><a href="<c:url value='/course/list'/>">Course</a></div>
	    <div class="menu"><a href="<c:url value='/assignment/list'/>">Assignment</a></div>

	    <c:if test="${loginUser.role eq 'R'}">
	        <div class="menu"><a href="<c:url value='/memberlist'/>">사원조회</a></div>
	        <div class="menu"><a href="<c:url value='/enrollment/enrollMemList'/>">사원강의관리</a></div>
	    </c:if>
	</div>

<!-- 사용자 정보 -->
<div id="user-info">
    <c:choose>
        <c:when test="${not empty loginUser}">

    이름 : <b>${loginUser.name}</b>

    <br><br>

    부서 :
    <b>
        <c:choose>
            <c:when test="${loginUser.departmentId eq 'D01'}">인사팀</c:when>
            <c:when test="${loginUser.departmentId eq 'D02'}">개발팀</c:when>
            <c:when test="${loginUser.departmentId eq 'D03'}">디자인팀</c:when>
            <c:when test="${loginUser.departmentId eq 'D04'}">영업팀</c:when>
            <c:when test="${loginUser.departmentId eq 'D05'}">마케팅팀</c:when>
            <c:when test="${loginUser.departmentId eq 'D06'}">운영팀</c:when>
            <c:when test="${loginUser.departmentId eq 'D07'}">품질관리팀</c:when>
            <c:when test="${loginUser.departmentId eq 'D08'}">전략기획팀</c:when>
            <c:otherwise>부서없음</c:otherwise>
        </c:choose>
    </b>

    <br><br>

    직급 :
    <b>
        <c:choose>
            <c:when test="${loginUser.positionId eq 'P01'}">사원</c:when>
            <c:when test="${loginUser.positionId eq 'P02'}">주임</c:when>
            <c:when test="${loginUser.positionId eq 'P03'}">대리</c:when>
            <c:when test="${loginUser.positionId eq 'P04'}">과장</c:when>
            <c:when test="${loginUser.positionId eq 'P05'}">차장</c:when>
            <c:when test="${loginUser.positionId eq 'P06'}">부장</c:when>
            <c:otherwise>직급없음</c:otherwise>
        </c:choose>
    </b>

    <br><br>

    <a href="<c:url value='/member/myPage'/>">마이페이지</a>
    <a href="<c:url value='/member/logout'/>">로그아웃</a>
	    </c:when>
	
	
	    <c:otherwise>
	        <a href="<c:url value='/member/logout'/>">되돌아가기</a>
	    </c:otherwise>

	</c:choose>
    </div>

</body>
</html>