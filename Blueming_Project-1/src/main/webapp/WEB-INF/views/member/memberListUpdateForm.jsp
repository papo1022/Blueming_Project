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
	.update-value input[type="text"], .update-value input[type="email"], .update-value select, .update-value input[type="date"] { width: 100%; padding: 8px; box-sizing: border-box; }
	.btn-group { text-align: center; margin-top: 30px; }
	.btn { padding: 10px 20px; margin: 0 5px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
	.btn-primary { background-color: #28a745; color: white; }
	.btn-secondary { background-color: #6c757d; color: white; }
	
	.leave-date-group { display: flex; align-items: center; gap: 10px; }
	.leave-date-group input[type="date"] { width: 45% !important; }
</style>
</head>
<body>
	<jsp:include page="../common/menubar.jsp"/>

	<div class="update-container">
		<h2>사원 정보 수정</h2>
		
		<form id="updateForm" action="/blueming/memberlist/update" method="post">
			<input type="hidden" name="memberId" value="${member.memberId}">
			
			<input type="hidden" id="realLeaveStartDate" name="leaveStartDate">
			<input type="hidden" id="realLeaveEndDate" name="leaveEndDate">
		
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
			    	<select name="deptId" id="deptSelect">
						 <c:forEach var="dept" items="${deptList}">
					            <option value="${dept.deptId}" 
					                    ${member.deptId == dept.deptId ? 'selected' : ''}>
					                ${dept.deptName}
					            </option>
       					 </c:forEach>
			        </select>
			    </div>
			</div>
		
			<div class="update-row">
			    <div class="update-label">직급</div>
			   	 <div class="update-value">
			    	 <select name="positionId" id="positionSelect">
					        <c:forEach var="pos" items="${posList}">
					            <option value="${pos.positionId}" 
					                    ${member.positionId == pos.positionId ? 'selected' : ''}>
					                ${pos.positionName}
					            </option>
					        </c:forEach>
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
					<select name="status" id="statusSelect" onchange="toggleLeaveInput();">
						<option value="Y" ${member.status == 'Y' ? 'selected' : ''}>재직</option>
						<option value="R" ${member.status == 'R' ? 'selected' : ''}>휴직</option>
						<option value="N" ${member.status == 'N' ? 'selected' : ''}>퇴사</option>
					</select>
				</div>
			</div>
			
			<div class="update-row" id="leaveDateRow" style="${member.status == 'R' ? '' : 'display:none;'}">
				<div class="update-label">휴직기간</div>
				<div class="update-value leave-date-group">
					<input type="date" id="viewLeaveStartDate">
					<span>~</span>
					<input type="date" id="viewLeaveEndDate">
				</div>
			</div>
			
			<div class="update-row" id="retireDateRow" style="${member.status == 'N' ? '' : 'display:none;'}">
			    <div class="update-label">퇴사일</div>
			   	 	<div class="update-value">
			        <input type="date" name="retireDate" id="retireDateInput" value="<fmt:formatDate value='${member.retireDate}' pattern='yyyy-MM-dd'/>">
			    </div>
			</div>
			
			
				<div class="btn-group">
				    <button type="button" class="btn btn-primary" onclick="submitUpdateForm();">저장하기</button>
				    
				    <button type="button" class="btn btn-secondary" onclick="location.href='/blueming/memberlist'">취소</button>
				</div>
			
		</form>
	</div>

	<script>
		// DB에서 가져온 8자리 숫자(YYYYMMDD)를 HTML5 <input type="date"> 포맷(YYYY-MM-DD)으로 파싱
		window.onload = function() {
			const startNum = "${member.leaveStartDate}".trim();
			const endNum = "${member.leaveEndDate}".trim();
			
			if(startNum && startNum.length === 8) {
				document.getElementById("viewLeaveStartDate").value = startNum.substring(0,4) + '-' + startNum.substring(4,6) + '-' + startNum.substring(6,8);
			}
			if(endNum && endNum.length === 8) {
				document.getElementById("viewLeaveEndDate").value = endNum.substring(0,4) + '-' + endNum.substring(4,6) + '-' + endNum.substring(6,8);
			}
		}

		function toggleLeaveInput() {
		    const currentStatus = document.getElementById("statusSelect").value;
		    const leaveRow = document.getElementById("leaveDateRow");
		    const retireRow = document.getElementById("retireDateRow");
		    
		    // 상태에 따른 표시
		    leaveRow.style.display = (currentStatus === 'R') ? 'flex' : 'none';
		    retireRow.style.display = (currentStatus === 'N') ? 'flex' : 'none';
		    
		    // 상태가 N이 아니면 입력값 초기화
		    if(currentStatus !== 'N') {
		        document.getElementById("retireDateInput").value = "";
		    }
		}

		// 전송 전 유효성 검사 및 하이픈 제거 후 정수형 변환 처리
		function submitUpdateForm() {
    const form = document.getElementById("updateForm");
    const currentStatus = document.getElementById("statusSelect").value;
    
    // 1. 먼저 요소들을 찾습니다.
    const retireInput = document.getElementById("retireDateInput");
    const leaveInputStart = document.getElementById("viewLeaveStartDate");
    const leaveInputEnd = document.getElementById("viewLeaveEndDate");
    
    // 2. 검증 전에 잠시 활성화하여 값을 읽을 수 있게 합니다.
    retireInput.disabled = false;
    leaveInputStart.disabled = false;
    leaveInputEnd.disabled = false;

    // --- [퇴사일 검증] ---
    if (currentStatus === 'N' && retireInput.value === "") {
        alert("퇴사 처리 시 퇴사일을 반드시 입력해야 합니다.");
        retireInput.focus();
        return; 
    }

    // 3. 이후 기존의 상태에 따른 필드 비활성화 로직 수행
    if (currentStatus !== 'R') {
        leaveInputStart.disabled = true;
        leaveInputEnd.disabled = true;
    }
    if (currentStatus !== 'N') {
        retireInput.disabled = true;
    }

    // 4. 휴직 날짜 처리 로직
    const startDateVal = leaveInputStart.value; 
    const endDateVal = leaveInputEnd.value;
    const cleanStart = startDateVal.replace(/-/g, "");
    const cleanEnd = endDateVal.replace(/-/g, "");
    
    const realStartInput = document.getElementById("realLeaveStartDate");
    const realEndInput = document.getElementById("realLeaveEndDate");

    if (currentStatus === 'R') {
        if(!cleanStart || !cleanEnd) {
            alert("휴직 상태일 경우 휴직 기간을 입력해야 합니다.");
            return;
        }
        realStartInput.value = parseInt(cleanStart);
        realEndInput.value = parseInt(cleanEnd);
    } else {
        realStartInput.value = "";
        realEndInput.value = "";
    }

    if(form.checkValidity()) {
        form.submit();
    } else {
        form.reportValidity(); 
    }
}
	</script>
</body>
</html>