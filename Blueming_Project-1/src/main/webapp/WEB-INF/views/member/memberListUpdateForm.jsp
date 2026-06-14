<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 정보 수정</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/memberList.css">
<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/uicons-regular-rounded/css/uicons-regular-rounded.css">
<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/uicons-solid-rounded/css/uicons-solid-rounded.css">

</head>
<body>
	<jsp:include page="../common/mainMenubar.jsp"/>

	<div class="container">

		
		<form id="updateForm" action="/blueming/memberlist/update" method="post">
			<input type="hidden" name="memberId" value="${member.memberId}">
			
			<input type="hidden" id="realLeaveStartDate" name="leaveStartDate">
			<input type="hidden" id="realLeaveEndDate" name="leaveEndDate">
		
			<div class="row">
    <div class="label">사원번호</div>
    <div class="value"><input type="text" value="${member.memberId}" readonly></div>
</div>

<div class="update-row">
    <div class="update-label">로그인ID</div>
    <div class="update-value">
		<input type="text" name="loginId" value="<c:out value='${member.loginId}' />" maxlength="20" readonly style="background-color: #e9ecef;">
    </div>
</div>

<div class="update-row">
    <div class="update-label">이름</div>
    <div class="update-value">
		<input type="text" name="name" value="<c:out value='${member.name}' />" maxlength="100" required>
    </div>
</div>

<div class="update-row">
    <div class="update-label">이메일</div>
    <div class="update-value">
		<input type="email" name="email" value="<c:out value='${member.email}' />" maxlength="100">
    </div>
</div>

<div class="row">
    <div class="label">연락처</div>
    <div class="value">
        <input type="text"
       name="phone"
       id="phoneInput"
       value="${fn:escapeXml(member.phone)}"
        placeholder="010-1234-5678" 
        maxlength="13" 
        pattern="010-[0-9]{3,4}-[0-9]{4}"
        title="010-XXXX-XXXX 형식의 13자리(하이픈 포함)로 입력해주세요." required>
    </div>
</div>

<div class="row">
    <div class="label">주소</div>
    <div class="value">
        <input type="text"
       name="address"
       value="${fn:escapeXml(member.address)}"
       maxlength="255">
    </div>
</div>
			
			<div class="row">
			    <div class="label">부서</div>
			    <div class="value">
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
		
			<div class="row">
			    <div class="label">직급</div>
			   	 <div class="value">
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
			
			<div class="row">
			    <div class="label">권한코드</div>
			    <div class="value">
			        <select name="role" id="role" required>
			            <option value="N" ${member.role == 'N' ? 'selected' : ''}>사원</option>
			            <option value="R" ${member.role == 'R' ? 'selected' : ''}>인사</option>
			            <option value="S" ${member.role == 'S' ? 'selected' : ''}>강사</option>
			        </select>
			    </div>
			</div>
			
			<div class="row">
				<div class="label">입사일</div>
				<div class="value">
					<fmt:formatDate var="fmtHireDate" value="${member.hireDate}" pattern="yyyy-MM-dd"/>
					<input type="date" name="hireDate" value="${fmtHireDate}">
				</div>
			</div>
			
			<div class="row ${member.status == 'Y' ? 'last-row' : ''}">
	    <div class="label">상태</div>
	   	 <div class="value">
		        <select name="status" id="statusSelect" onchange="toggleLeaveInput();">
		            <option value="Y" ${member.status == 'Y' ? 'selected' : ''}>재직</option>
		            <option value="R" ${member.status == 'R' ? 'selected' : ''}>휴직</option>
		            <option value="N" ${member.status == 'N' ? 'selected' : ''}>퇴사</option>
		        </select>
	    	</div>
		</div>
			
			<div class="row ${member.status == 'R' ? 'last-row' : ''}"
     id="leaveDateRow"
     style="${member.status == 'R' ? '' : 'display:none;'}">

    <div class="label">휴직기간</div>

    <div class="value leave-date-group">
        <input type="date" id="viewLeaveStartDate">
        <span>~</span>
        <input type="date" id="viewLeaveEndDate">
    </div>
</div>

<div class="row ${member.status == 'N' ? 'last-row' : ''}"
     id="retireDateRow"
     style="${member.status == 'N' ? '' : 'display:none;'}">

    <div class="label">퇴사일</div>

    <div class="value">
        <fmt:formatDate
            var="fmtRetireDate"
            value="${member.retireDate}"
            pattern="yyyy-MM-dd"/>

        <input type="date"
               name="retireDate"
               id="retireDateInput"
               value="${fmtRetireDate}">
    </div>
</div>
			<div class="row btn-row">
			<div class="value btn-group">
			    <button type="button" class="btn1" onclick="submitUpdateForm();">저장하기</button>
			    <button type="button" class="btn2" onclick="location.href='/blueming/memberlist'">취소</button>
			</div>
			</div>
		</form>
	</div>

			<div class="update-row" id="retireDateRow" style="display:none;">
				<div class="update-label">퇴사일</div>
				<div class="update-value">
					<input type="date" name="retireDate" id="retireDateInput" value="${fmtRetireDate}">
				</div>
			</div>
	<script>
		// DB에서 가져온 8자리 숫자(YYYYMMDD)를 HTML5 <input type="date"> 포맷(YYYY-MM-DD)으로 파싱
		// 🛡️ 안전하게 치환된 자바스크립트 변수 할당
		window.onload = function() {
		 
		    const startNum = "${fn:escapeXml(member.leaveStartDate)}".trim();
			const endNum = "${fn:escapeXml(member.leaveEndDate)}".trim();
		    
		    if(startNum && startNum.length === 8) {
		        document.getElementById("viewLeaveStartDate").value = startNum.substring(0,4) + '-' + startNum.substring(4,6) + '-' + startNum.substring(6,8);
		    }
		    if(endNum && endNum.length === 8) {
		        document.getElementById("viewLeaveEndDate").value = endNum.substring(0,4) + '-' + endNum.substring(4,6) + '-' + endNum.substring(6,8);
		    }

		    toggleLeaveInput();
		}

		function toggleLeaveInput() {

		    const currentStatus = document.getElementById("statusSelect").value;

		    const leaveRow = document.getElementById("leaveDateRow");
		    const retireRow = document.getElementById("retireDateRow");

		    // 기존 표시/숨김 처리
		    leaveRow.style.display = (currentStatus === 'R') ? 'flex' : 'none';
		    retireRow.style.display = (currentStatus === 'N') ? 'flex' : 'none';

		    // 기존 퇴사일 초기화
		    if(currentStatus !== 'N') {
		        document.getElementById("retireDateInput").value = "";
		    }

		    // last-row 초기화
		    document.querySelectorAll(".last-row")
		            .forEach(row => row.classList.remove("last-row"));

		    // 상태 행 찾기
		    const statusRow = document.getElementById("statusSelect").closest(".row");

		    if(currentStatus === 'R') {
		        leaveRow.classList.add("last-row");
		    }
		    else if(currentStatus === 'N') {
		        retireRow.classList.add("last-row");
		    }
		    else {
		        statusRow.classList.add("last-row");
		    }
		}

		// 전송 전 유효성 검사 및 하이픈 제거 후 정수형 변환 처리
		function submitUpdateForm() {
		    const form = document.getElementById("updateForm");
		    const currentStatus = document.getElementById("statusSelect").value;
		    
		    const retireInput = document.getElementById("retireDateInput");
		    const leaveInputStart = document.getElementById("viewLeaveStartDate");
		    const leaveInputEnd = document.getElementById("viewLeaveEndDate");
		    const phoneInput = document.getElementById("phoneInput"); // 🌟 연락처 매핑
		    
		    retireInput.disabled = false;
		    leaveInputStart.disabled = false;
		    leaveInputEnd.disabled = false;
		
		    // --- 🌟 [추가] 연락처 정확히 13자리 형식 예외 필터 검증 ---
		    if(phoneInput && phoneInput.value.length > 0 && phoneInput.value.length !== 13) {
		        alert("연락처는 하이픈(-)을 포함하여 정확히 13자리여야 합니다.");
		        phoneInput.focus();
		        return;
		    }

		    if (currentStatus === 'N' && retireInput.value === "") {
			    alert("퇴사 처리 시 퇴사일을 반드시 입력해야 합니다.");
			    retireInput.focus();
			    return; 
		    }
		
		    if (currentStatus !== 'R') {
			    leaveInputStart.disabled = true;
			    leaveInputEnd.disabled = true;
		    }
		    if (currentStatus !== 'N') {
			    retireInput.disabled = true;
		    }
		
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

		// 안전하게 외부로 분리된 DOM 로드 이벤트 구역
		document.addEventListener("DOMContentLoaded", function() {
		    const deptSelect = document.getElementById("deptSelect");
		    const roleSelect = document.getElementById("role");
		    const phoneInput = document.getElementById("phoneInput"); // 🌟 연락처 타겟 추가
		
		    // 1. 부서 변경 시 권한 코드 동적 제어
		    if(deptSelect && roleSelect) {
		        deptSelect.addEventListener("change", function() {
		            if (this.value === "D01") { 
		                roleSelect.value = "R"; 
		            } 
		            else if (this.value !== "") { 
		                roleSelect.value = "N"; 
		            }
		        });
		    }

		    // 2. 🌟 연락처 실시간 자동 하이픈 및 정규식 치환 포맷터
		    if(phoneInput) {
		        phoneInput.addEventListener("input", function() {
		            let val = this.value.replace(/[^0-9]/g, ''); // 숫자 제외한 문자 필터링
		            
		            if (val.length < 4) {
		                this.value = val;
		            } else if (val.length < 8) {
		                this.value = val.substring(0, 3) + '-' + val.substring(3);
		            } else {
		                this.value = val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + val.substring(7, 11);
		            }
		        });
		    }
		});
	</script>
</body>
</html>