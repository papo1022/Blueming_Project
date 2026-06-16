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
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard/memberDashboard.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/mainMenubar.css">

<!-- Bootstrap -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
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
		    <a class="dashboard-logo" href="${homeUrl}">
		        <i class="fi fi-sr-computer"></i>
		        대시보드
		    </a>
		    
		    <div class="menu">
		        <c:if test="${not empty loginUser}">
		            <nav class="sidebar-nav">
		                <ul>
                            <li>
                                <a href="<c:url value='/notice/list'/>">
                                    <i class="fi fi-sr-megaphone"></i>
                                    공지사항
                                </a>
                            </li>

							<%-- HR팀 메뉴 --%>
                            <c:if test="${loginUser.role eq 'R'}">
                                <li>
	                                <a href="<c:url value='/course/list'/>">
	                                    <i class="fi fi-sr-graduation-cap"></i>
	                                    강의
	                                </a>
	                            </li>
                                <li>
                                    <a href="<c:url value='/assignment/list'/>">
                                        <i class="fi fi-sr-document"></i>
                                        과제
                                    </a>
                                </li>
                                <li>
                                    <a href="<c:url value='/memberlist'/>">
                                        <i class="fi fi-sr-user"></i>
                                        사원 관리
                                    </a>
                                </li>
                                <li>
                                    <a href="<c:url value='/enrollment/enrollMemList'/>">
                                        <i class="fi fi-sr-graduation-cap"></i>
                                        강의 현황 조회
                                    </a>
                                </li>
                            </c:if>

							<%-- 시스템 관리자 메뉴 --%>
                            <c:if test="${loginUser.role eq 'S'}">
                            	<li>
	                                <a href="<c:url value='/course/list'/>">
	                                    <i class="fi fi-sr-graduation-cap"></i>
	                                    강의 관리
	                                </a>
	                            </li>
                                <li>
                                    <a href="<c:url value='/assignment/admin/list'/>">
                                        <i class="fi fi-sr-document"></i>
                                        과제 관리
                                    </a>
                                </li>
                            </c:if>

							<%-- 사원 메뉴 --%>
                            <c:if test="${loginUser.role eq 'N'}">
	                            <li>
	                                <a href="<c:url value='/course/list'/>">
	                                    <i class="fi fi-sr-graduation-cap"></i>
	                                    강의
	                                </a>
	                            </li>
                                <li>
                                    <a href="<c:url value='/assignment/list'/>">
                                        <i class="fi fi-sr-document"></i>
                                        과제
                                    </a>
                                </li>
                                
                            </c:if>
                            
                             <li>
                                <a href="<c:url value='/member/myPage'/>">
                                    <i class="fi fi-sr-user"></i>
                                    마이페이지
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
            
        </div>
        
    </div>
    
</body>
</html>