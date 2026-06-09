<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
 
  <style>
    #user-info {
    position: fixed;
    top: 20px;
    right: 30px;

    text-align: right;
    background: white;
    padding: 10px 15px;
    border-radius: 8px;

    z-index: 1000;
}

#user-info a {
    text-decoration: none;
    color: black;
    font-size: 12px;
    margin-left: 10px;
}
</style>
</head>
<body>

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
	
	
	    

	</c:choose>
    </div>

</body>
</html>