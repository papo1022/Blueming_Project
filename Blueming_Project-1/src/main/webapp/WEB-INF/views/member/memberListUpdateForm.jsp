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

            <div class="row">
                <div class="label">로그인ID</div>
                <div class="value">
                    <input type="text" name="loginId" value="<c:out value='${member.loginId}' />" maxlength="20" readonly style="background-color: #e9ecef;">
                </div>
            </div>

            <div class="row">
                <div class="label">이름</div>
                <div class="value">
                    <input type="text" name="name" id="name" value="<c:out value='${member.name}' />" required>
                    <span id="nameMsg" style="color: red; font-size: 12px; display: none;"></span>
                </div>
            </div>

            <div class="row">
                <div class="label">이메일</div>
                <div class="value">
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
                    <input type="text" name="address" id="address" value="${fn:escapeXml(member.address)}">
                    <span id="addressMsg" style="color: red; font-size: 12px; display: none;"></span>
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
			
			<div class="row ${member.status == 'R' ? 'last-row' : ''}" id="leaveDateRow" style="${member.status == 'R' ? '' : 'display:none;'}">
                <div class="label">휴직기간</div>
                <div class="value leave-date-group">
                    <input type="date" id="viewLeaveStartDate">
                    <span>~</span>
                    <input type="date" id="viewLeaveEndDate">
                </div>
            </div>

            <div class="row ${member.status == 'N' ? 'last-row' : ''}" id="retireDateRow" style="${member.status == 'N' ? '' : 'display:none;'}">
                <div class="label">퇴사일</div>
                <div class="value">
                    <fmt:formatDate var="fmtRetireDate" value="${member.retireDate}" pattern="yyyy-MM-dd"/>
                    <input type="date" name="retireDate" id="retireDateInput" value="${fmtRetireDate}">
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

	<script>
        // 🌟 1. 확장형 공통 글자수 및 정규식 제한 함수
        function handleLengthLimit(inputEl, msgEl, limit, fieldType) {
            if (!inputEl) return;
            
            let val = inputEl.value;
            let filtered = val;
            let errorMsg = "";

            if (fieldType === "name") {
                // 이름: 영문, 한글, 공백만 허용 (숫자 및 특수문자 완벽 차단)
                filtered = val.replace(/[^a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣\s]/g, '');
                if (val !== filtered) errorMsg = "이름은 영문과 한글만 입력 가능합니다.";
                
            } else if (fieldType === "address") {
                // 주소: 영문, 숫자, 한글, 공백만 허용 (순수 특수문자만 차단)
                filtered = val.replace(/[^a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣\s]/g, '');
                if (val !== filtered) errorMsg = "주소에는 특수문자를 입력할 수 없습니다.";
            }

            if (val !== filtered) {
                if (msgEl) {
                    msgEl.textContent = errorMsg;
                    msgEl.style.display = "block";
                }
                inputEl.value = filtered;
                return;
            }

            if (filtered.length >= limit) {
                if (msgEl) {
                    msgEl.textContent = `최대 ${limit}자까지 입력 가능합니다.`;
                    msgEl.style.display = "block";
                }
                if (filtered.length > limit) {
                    inputEl.value = filtered.substring(0, limit);
                }
            } else {
                if (msgEl) msgEl.style.display = "none";
            }
        }

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

		    leaveRow.style.display = (currentStatus === 'R') ? 'flex' : 'none';
		    retireRow.style.display = (currentStatus === 'N') ? 'flex' : 'none';

		    if(currentStatus !== 'N') {
		        document.getElementById("retireDateInput").value = "";
		    }

		    document.querySelectorAll(".last-row").forEach(row => row.classList.remove("last-row"));

		    const statusRow = document.getElementById("statusSelect").closest(".row");

		    if(currentStatus === 'R') {
		        leaveRow.classList.add("last-row");
		    } else if(currentStatus === 'N') {
		        retireRow.classList.add("last-row");
		    } else {
		        statusRow.classList.add("last-row");
		    }
		}

		// 🌟 2. 최종 저장하기 버튼 클릭 유효성 검사
		function submitUpdateForm() {
		    const form = document.getElementById("updateForm");
		    const currentStatus = document.getElementById("statusSelect").value;
		    
		    const retireInput = document.getElementById("retireDateInput");
		    const leaveInputStart = document.getElementById("viewLeaveStartDate");
		    const leaveInputEnd = document.getElementById("viewLeaveEndDate");
		    const phoneInput = document.getElementById("phoneInput");
		    const name = document.getElementById("name");
		    const address = document.getElementById("address");
		    
		    retireInput.disabled = false;
		    leaveInputStart.disabled = false;
		    leaveInputEnd.disabled = false;
		
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
		    
		    // 🌟 이름 최종 패턴 확인 (영문, 한글, 공백만 허용)
		    if (!/^[a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣\s]+$/.test(name.value)) {
	            alert("이름은 영문과 한글만 입력 가능합니다.");
	            name.focus();
	            return;
	        }
		    
		    // 🌟 주소 최종 패턴 확인 (영문, 숫자, 한글, 공백 허용 / 특수문자 차단)
		    if (!/^[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣\s]+$/.test(address.value)) {
	            alert("주소는 한글, 영문, 숫자, 공백만 입력 가능합니다. (특수문자 제외)");
	            address.focus();
	            return;
	        }
		
		    if(form.checkValidity()) {
                // 저장 전 최종 패키징 단계 XSS 클린업 처리
                document.querySelectorAll("input[type='text'], input[type='email']")
                    .forEach(function(el) {
                        el.value = removeXss(el.value);
                    });
			    form.submit();
		    } else {
			    form.reportValidity(); 
		    }
		} 

		// 🌟 3. 이벤트 리스너 바인딩 구역
		document.addEventListener("DOMContentLoaded", function() {
		    const deptSelect = document.getElementById("deptSelect");
		    const roleSelect = document.getElementById("role");
		    const phoneInput = document.getElementById("phoneInput");
            const nameInput = document.getElementById("name");
            const addressInput = document.getElementById("address");
            const nameMsg = document.getElementById("nameMsg");
            const addressMsg = document.getElementById("addressMsg");
		
            // 이름 실시간 유효성 연동 (최대 30자)
            if (nameInput && nameMsg) {
                nameInput.addEventListener("input", function() {
                    handleLengthLimit(this, nameMsg, 30, "name");
                });
            }

            // 주소 실시간 유효성 연동 (최대 200자)
            if (addressInput && addressMsg) {
                addressInput.addEventListener("input", function() {
                    handleLengthLimit(this, addressMsg, 200, "address");
                });
            }

		    // 부서 변경 시 권한 코드 동적 제어
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

		    // 연락처 실시간 자동 하이픈 포맷터
		    if(phoneInput) {
		        phoneInput.addEventListener("input", function() {
		            let val = this.value.replace(/[^0-9]/g, '');
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

        // 🌟 4. XSS 문자 치환 백업 필터
        function removeXss(value) {
            return value
                .replace(/</g, "")
                .replace(/>/g, "")
                .replace(/"/g, "")
                .replace(/'/g, "")
                .replace(/&/g, "")
                .replace(/\(/g, "")
                .replace(/\)/g, "");
        }
	</script>
</body>
</html>