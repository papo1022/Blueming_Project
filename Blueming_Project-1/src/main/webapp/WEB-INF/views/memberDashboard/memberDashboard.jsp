<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Member Dashboard</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
</head>
<body>
	
	<%-- 공통 메뉴바 --%>
	<jsp:include page="/WEB-INF/views/common/menubar.jsp" />
	
	<div class="container-fluid mt-4">
	    <div class="row">
	
	        <%-- 왼쪽: 인사말 + 강의 목록 --%>
	        <div class="col-md-8">
	
	            <%-- 인사말 --%>
	            <h4>안녕하세요, ${profile.name} 님!</h4>
	            <p>오늘의 교육 이수율을 확인해 보세요.</p>
	
	            <%-- 강의 목록 --%>
	            <h5 class="mt-4">강의 목록</h5>
	            <div class="row">
	                <c:forEach var="course" items="${courseList}">
	                    <div class="col-md-4 mb-3">
	                        <div class="card">
	                            <div class="card-body">
	                                <h6 class="card-title">${course.courseTitle}</h6>
	                                <%-- 진도율 --%>
	                                <p>진도율: ${course.progressRate}%</p>
	                                <%-- D-day --%>
	                                <c:choose>
	                                    <c:when test="${course.courseStatus == 'DONE'}">
	                                        <span class="text-success font-weight-bold">완료</span>
	                                    </c:when>
	                                    <c:when test="${course.courseStatus == 'CLOSED'}">
	                                        <span class="text-muted font-weight-bold">마감</span>
	                                    </c:when>
	                                    <c:otherwise>
	                                        <span class="text-warning font-weight-bold">D-${course.dDay}</span>
	                                    </c:otherwise>
	                                </c:choose>
	                            </div>
	                        </div>
	                    </div>
	                </c:forEach>
	            </div>
	
	        </div>
	
	        <%-- 오른쪽: 프로필 + 과제 목록 --%>
	        <div class="col-md-4">
	
	            <%-- 프로필 --%>
	            <div class="card mb-4">
	                <div class="card-body text-center">
	                    <h5>${profile.name}</h5>
	                    <p class="text-muted">${profile.email}</p>
	                    <p>${profile.departmentName} / ${profile.positionName}</p>
	                </div>
	            </div>
	
	            <%-- 과제 목록 --%>
	            <h5>과제</h5>
	            <c:forEach var="assign" items="${assignmentList}">
	                <div class="d-flex justify-content-between align-items-center mb-2">
	                    <span>${assign.assignmentTitle}</span>
	                    <c:choose>
	                        <c:when test="${assign.submitStatus == 'SUBMITTED'}">
	                            <button class="btn btn-success btn-sm">제출</button>
	                        </c:when>
	                        <c:otherwise>
	                            <button class="btn btn-secondary btn-sm">미제출</button>
	                        </c:otherwise>
	                    </c:choose>
	                </div>
	            </c:forEach>
	
	        </div>
	    </div>
	</div>
	
</body>
</html>