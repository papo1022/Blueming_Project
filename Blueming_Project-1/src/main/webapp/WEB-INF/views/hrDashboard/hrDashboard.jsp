<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HR Dashboard</title>
</head>
<body>
	
	<%-- 공통 메뉴바 --%>
	<jsp:include page="/WEB-INF/views/common/menubar.jsp" />
	
	<div class="container-fluid mt-4">
	    <div class="row">
	
	        <%-- 왼쪽: 인사말 + 사원 이수율 목록 --%>
	        <div class="col-md-8">
	
	            <%-- 인사말 --%>
	            <h4>안녕하세요, ${profile.name} 님!</h4>
	            <p>오늘의 사원 강의 이수율을 확인해 보세요.</p>
	
	            <%-- 사원 이수율 목록 --%>
	            <h5 class="mt-4">강의 이수율</h5>
	            <table class="table table-bordered">
	                <thead>
	                    <tr>
	                        <th>이름</th>
	                        <th>부서</th>
	                        <th>직급</th>
	                        <th>이메일</th>
	                        <th>이수율</th>
	                    </tr>
	                </thead>
	                <tbody>
	                    <c:forEach var="member" items="${hrMemberList}">
	                        <tr>
	                            <td>${member.name}</td>
	                            <td>${member.departmentName}</td>
	                            <td>${member.positionName}</td>
	                            <td>${member.email}</td>
	                            <td>${member.avgProgressRate}%</td>
	                        </tr>
	                    </c:forEach>
	                    <%-- 데이터 없을 때 --%>
	                    <c:if test="${empty hrMemberList}">
	                        <tr>
	                            <td colspan="5" class="text-center">사원 데이터가 없습니다.</td>
	                        </tr>
	                    </c:if>
	                </tbody>
	            </table>
	
	        </div>
	
	        <%-- 오른쪽: 프로필 + 연차 승인 대기 --%>
	        <div class="col-md-4">
	
	            <%-- 프로필 --%>
	            <div class="card mb-4">
	                <div class="card-body text-center">
	                    <h5>${profile.departmentName} ${profile.name}</h5>
	                    <p class="text-muted">${profile.email}</p>
	                </div>
	            </div>
	
	            <%-- 연차 승인 대기 (껍데기- 추후 구현) --%>
	            <h5>연차 승인 대기</h5>
	            <div class="list-group">
	                <div class="list-group-item">
	                    <p class="mb-1">김소희 / 반차</p>
	                    <small class="text-muted">2026.06.01 ~ 2026.06.01</small>
	                </div>
	                <div class="list-group-item">
	                    <p class="mb-1">이정우 / 연차</p>
	                    <small class="text-muted">2026.06.17 ~ 2026.06.18</small>
	                </div>
	                <div class="list-group-item">
	                    <p class="mb-1">박희연 / 병가</p>
	                    <small class="text-muted">2026.06.04 ~ 2026.06.05</small>
	                </div>
	            </div>
	
	        </div>
	    </div>
	</div>
	
</body>
</html>