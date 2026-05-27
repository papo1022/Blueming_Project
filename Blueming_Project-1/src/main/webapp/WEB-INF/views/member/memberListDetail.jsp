<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 상세정보</title>
<style>
	.detail-container {
		width: 600px;
		margin: 40px auto;
		border: 1px solid #ddd;
		padding: 30px;
		border-radius: 8px;
	}
	
	.detail-container h2 {
		text-align: center;
		margin-bottom: 30px;
	}
	
	.detail-row {
		display: flex;
		margin-bottom: 15px;
		border-bottom: 1px solid #eee;
		padding-bottom: 10px;
	}
	
	.detail-label {
		width: 30%;
		font-weight: bold;
		background-color: #f8f9fa;
		padding: 10px;
	}
	
	.detail-value {
		width: 70%;
		padding: 10px;
	}
	
	.btn-group {
		text-align: center;
		margin-top: 30px;
	}
	
	.btn {
		padding: 10px 20px;
		margin: 0 5px;
		border: none;
		border-radius: 4px;
		cursor: pointer;
		font-size: 14px;
	}
	
	.btn-primary {
		background-color: #007bff;
		color: white;
	}
	
	.btn-primary:hover {
		background-color: #0056b3;
	}
	
	.btn-secondary {
		background-color: #6c757d;
		color: white;
	}
	
	.btn-secondary:hover {
		background-color: #545b62;
	}
</style>
</head>
<body>
	<jsp:include page="../common/menubar.jsp"/>

	<div class="detail-container">
		<h2>사원 상세정보</h2>
		
		<c:if test="${empty requestScope.member}">
			<p align="center">사원 정보를 찾을 수 없습니다.</p>
		</c:if>
		
		<c:if test="${not empty requestScope.member}">
			<div class="detail-row">
				<div class="detail-label">사원번호</div>
				<div class="detail-value">${requestScope.member.memberId}</div>
			</div>
			
			<div class="detail-row">
				<div class="detail-label">이름</div>
				<div class="detail-value">${requestScope.member.name}</div>
			</div>
			
			<div class="detail-row">
				<div class="detail-label">로그인ID</div>
				<div class="detail-value">${requestScope.member.loginId}</div>
			</div>
			
			<div class="detail-row">
				<div class="detail-label">이메일</div>
				<div class="detail-value">${requestScope.member.email}</div>
			</div>
			
			<div class="detail-row">
				<div class="detail-label">연락처</div>
				<div class="detail-value">${requestScope.member.phone}</div>
			</div>
			
			<div class="detail-row">
				<div class="detail-label">주소</div>
				<div class="detail-value">${requestScope.member.address}</div>
			</div>
			
			<div class="detail-row">
				<div class="detail-label">부서</div>
				<div class="detail-value">${requestScope.member.deptId}</div>
			</div>
			
			<div class="detail-row">
				<div class="detail-label">직급</div>
				<div class="detail-value">${requestScope.member.positionId}</div>
			</div>
			
			<div class="detail-row">
				<div class="detail-label">입사일</div>
				<div class="detail-value">
					<fmt:formatDate value="${requestScope.member.hireDate}" pattern="yyyy-MM-dd"/>
				</div>
			</div>
			
			<div class="detail-row">
				<div class="detail-label">상태</div>
				<div class="detail-value">
					<c:choose>
						<c:when test="${requestScope.member.status == 'Y'}">재직</c:when>
						<c:when test="${requestScope.member.status == 'R'}">휴직</c:when>
						<c:when test="${requestScope.member.status == 'N'}">퇴사</c:when>
					</c:choose>
				</div>
			</div>
		</c:if>
		
		<div class="btn-group">
		<button class="btn btn-primary" onclick="goEdit()">수정</button>
		<button class="btn btn-secondary" onclick="goList()">목록</button>
	</div>
</div>

<script>
	function goEdit() {
		location.href = "/blueming/memberlist/update?memberId=${requestScope.member.memberId}";
	}
	
	function goList() {
		// 메인 리스트 컨트롤러 진입 (GET 요청으로 초기 전체목록 로드)
		location.href = "/blueming/memberlist";
	}
</script>
</body>
</html>