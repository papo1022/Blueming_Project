<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 정보 수정</title>
<style>
	.update-container { width: 600px; margin: 40px auto; border: 1px solid #ddd; padding: 30px; border-radius: 8px; }
	.update-container h2 { text-align: center; margin-bottom: 30px; }
	.update-row { display: flex; margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px; align-items: center; }
	.update-label { width: 30%; font-weight: bold; background-color: #f8f9fa; padding: 10px; }
	.update-value { width: 70%; padding: 5px 10px; }
	.update-value input[type="text"], .update-value input[type="email"], .update-value select { width: 100%; padding: 8px; box-sizing: border-box; }
	.btn-group { text-align: center; margin-top: 30px; }
	.btn { padding: 10px 20px; margin: 0 5px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
	.btn-primary { background-color: #28a745; color: white; }
	.btn-secondary { background-color: #6c757d; color: white; }
</style>
</head>
<body>
	<jsp:include page="../common/menubar.jsp"/>

	<div class="update-container">
		<h2>사원 정보 수정</h2>
		
		<form action="/blueming/memberlist/update" method="post">
			<input type="hidden" name="memberId" value="${member.memberId}">
		
			<div class="update-row">
				<div class="update-label">사원번호</div>
				<div class="update-value">${member.memberId}</div>
			</div>
			
			<div class="update-row">
				<div class="update-label">로그인ID</div>
				<div class="update-value">
					<input type="text" name="loginId" value="${member.loginId}" readonly style="background-color: #e9ecef;">
				</div>
			</div>

			<div class="update-row">
				<div class="update-label">이름</div>
				<div class="update-value">
					<input type="text" name="name" value="${member.name}" required>
				</div>
			</div>
			
			<div class="update-row">
				<div class="update-label">이메일</div>
				<div class="update-value">
					<input type="email" name="email" value="${member.email}">
				</div>
			</div>
			
			<div class="update-row">
				<div class="update-label">연락처</div>
				<div class="update-value">
					<input type="text" name="phone" value="${member.phone}">
				</div>
			</div>
			
			<div class="update-row">
				<div class="update-label">주소</div>
				<div class="update-value">
					<input type="text" name="address" value="${member.address}">
				</div>
			</div>
			
			<div class="update-row">
		    <div class="update-label">부서</div>
		    <div class="update-value">
		        <select name="deptId">
		            <option value="D1" ${member.deptId == 'D1' ? 'selected' : ''}>개발팀</option>
		            <option value="D2" ${member.deptId == 'D2' ? 'selected' : ''}>인사팀</option>
		            <option value="D3" ${member.deptId == 'D3' ? 'selected' : ''}>영업팀</option>
		        </select>
		    </div>
			</div>
		
			<div class="update-row">
			    <div class="update-label">직급</div>
				    <div class="update-value">
				        <select name="positionId">
				            <option value="P1" ${member.positionId == 'P1' ? 'selected' : ''}>사원</option>
				            <option value="P2" ${member.positionId == 'P2' ? 'selected' : ''}>대리</option>
				            <option value="P3" ${member.positionId == 'P3' ? 'selected' : ''}>과장</option>
				            <option value="P4" ${member.positionId == 'P4' ? 'selected' : ''}>부장</option>
				        </select>
				    </div>
				</div>
			
			<div class="update-row">
				<div class="update-label">입사일</div>
				<div class="update-value">
					<fmt:formatDate var="fmtHireDate" value="${member.hireDate}" pattern="yyyy-MM-dd"/>
					<input type="date" name="hireDate" value="${fmtHireDate}">
				</div>
			</div>
			
			<div class="update-row">
				<div class="update-label">상태</div>
				<div class="update-value">
					<select name="status">
						<option value="Y" ${member.status == 'Y' ? 'selected' : ''}>재직</option>
						<option value="R" ${member.status == 'R' ? 'selected' : ''}>휴직</option>
						<option value="N" ${member.status == 'N' ? 'selected' : ''}>퇴사</option>
					</select>
				</div>
			</div>
			
			<div class="btn-group">
				<button type="submit" class="btn btn-primary">저장하기</button>
				<button type="button" class="btn btn-secondary" onclick="history.back();">취소</button>
			</div>
		</form>
	</div>
</body>
</html>