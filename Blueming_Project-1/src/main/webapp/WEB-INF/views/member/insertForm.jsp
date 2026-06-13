<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 추가</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberList.css">
	<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/uicons-regular-rounded/css/uicons-regular-rounded.css">
	<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/uicons-solid-rounded/css/uicons-solid-rounded.css">

</head>
<body>
	<jsp:include page="../common/mainMenubar.jsp" />

    <div class="container">
       
        <form id="enrollForm" action="${pageContext.request.contextPath}/memberlist/insert" method="post">
            
            <div class="row">
			    <div class="label">사원번호</div>
			    <div class="value"><input type="text" name="memberId" required></div>
			</div>
            
            <div class="insert-row">
                <div class="insert-label">로그인ID</div>
                <div class="insert-value"><input type="text" name="loginId" id="loginId" maxlength="20" required>
                <span id="idMsg" style="color: red; font-size: 12px; display: none;"></span>
                </div>
            </div>
            
            <div class="insert-row">
			    <div class="insert-label">비밀번호</div>
                <div class="insert-value"><input type="password" name="loginPwd" id="loginPwd" maxlength="20" required>
			    <span id="pwdMsg" style="color: red; font-size: 12px; display: none;"></span>
			    </div>
			</div>
			
			<div class="insert-row">
                <div class="insert-label">이름</div>
                <div class="insert-value"><input type="text" name="name" maxlength="100" required></div>
            </div>
			
			<div class="insert-row">
			    <div class="insert-label">이메일</div>
                <div class="insert-value"><input type="email" name="email" maxlength="100" required></div>
			</div>
			
			<div class="row">
			    <div class="label">전화번호</div>
			    <div class="value">
			        <input type="tel" 
			               name="phone" 
			               id="phoneInput" 
			               placeholder="010-1234-5678" 
			               maxlength="13" 
			               pattern="010-[0-9]{3,4}-[0-9]{4}" 
			               title="010-XXXX-XXXX 형식의 13자리(하이픈 포함)로 입력해주세요." 
			               required>
			    </div>
			</div>
			
			<div class="insert-row">
			    <div class="insert-label">주소</div>
                <div class="insert-value"><input type="text" name="address" maxlength="255" required></div>
			</div>
			
            <div class="row">
                <div class="label">부서</div>
                <div class="value">
                    <select name="deptId" id="deptSelect" required>
                        <option value="">-- 부서 선택 --</option>
                        <c:forEach var="dept" items="${deptList}">
                            <option value="<c:out value='${dept.deptId}' />">
                                <c:out value="${dept.deptName}" />
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            
            <div class="row">
                <div class="label">직급</div>
                <div class="value">
                    <select name="positionId" required>
                        <option value="">-- 직급 선택 --</option>
                        <c:forEach var="pos" items="${posList}">
                            <option value="<c:out value='${pos.positionId}' />">
                                <c:out value="${pos.positionName}" />
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            
            <div class="row">
                <div class="label">권한코드</div>
                <div class="value">
                    <select name="role" id="role" required>
                        <option value="N">사원</option>
                        <option value="R">인사</option>
                        <option value="S">강사</option>
                    </select>
                </div>
            </div>
            
            <div class="row last-row">
                <div class="label">입사일</div>
                <div class="value"><input type="date" name="hireDate" required></div>
            </div>
		
			<div class="row btn-row">
            <div class="value btn-group">
                <button type="button" class="btn1" onclick="submitEnrollForm();">등록</button>
		        <button type="button" class="btn2" onclick="history.back()">취소</button>
   		    </div>
   		    </div>
        </form>
    </div>

 <script>
    // 입력 제한 함수
    function handleLengthLimit(inputEl, msgEl, limit, isIdField) {

    let val = inputEl.value;

    // 아이디는 영문/숫자만
    if (isIdField) {

        const filtered = val.replace(/[^a-zA-Z0-9]/g, '');

        if (val !== filtered) {
            msgEl.textContent = "아이디는 영문과 숫자만 입력 가능합니다.";
            msgEl.style.display = "block";

            inputEl.value = filtered;
            return;
        }
    }

    if (val.length >= limit) {
        msgEl.textContent = "최대 20자까지 입력 가능합니다.";
        msgEl.style.display = "block";

        if (val.length > limit) {
            inputEl.value = val.substring(0, limit);
        }
    } else {
        msgEl.style.display = "none";
    }
}

    // 등록 버튼 클릭
    function submitEnrollForm() {

        const form = document.getElementById("enrollForm");
        const loginId = document.getElementById("loginId");
        const loginPwd = document.getElementById("loginPwd");
        const phoneInput = document.getElementById("phoneInput");

        // 아이디 영문/숫자 체크
        if (!/^[a-zA-Z0-9]+$/.test(loginId.value)) {
            alert("아이디는 영문과 숫자만 입력 가능합니다.");
            loginId.focus();
            return;
        }

        // 아이디 길이 체크
        if (loginId.value.length > 20) {
            alert("아이디는 최대 20자까지 가능합니다.");
            loginId.focus();
            return;
        }

        // 비밀번호 길이 체크
        if (loginPwd.value.length > 20) {
            alert("비밀번호는 최대 20자까지 가능합니다.");
            loginPwd.focus();
            return;
        }

        // 전화번호 길이 체크
        if (phoneInput.value.length !== 13) {
            alert("연락처는 010-1234-5678 형식으로 입력해주세요.");
            phoneInput.focus();
            return;
        }

        if (form.checkValidity()) {
            form.submit();
        } else {
            form.reportValidity();
        }
     // XSS 제거
        document.querySelectorAll("input[type='text'], input[type='password'], input[type='email']")
            .forEach(function(el) {
                el.value = removeXss(el.value);
            });
    }

    document.addEventListener("DOMContentLoaded", function() {

        const loginIdInput = document.getElementById("loginId");
        const loginPwdInput = document.getElementById("loginPwd");
        const idMsg = document.getElementById("idMsg");
        const pwdMsg = document.getElementById("pwdMsg");
        const deptSelect = document.getElementById("deptSelect");
        const roleSelect = document.getElementById("role");
        const phoneInput = document.getElementById("phoneInput");

        // 아이디 입력 제한
        if (loginIdInput && idMsg) {
            loginIdInput.addEventListener("input", function() {
                handleLengthLimit(loginIdInput, idMsg, 20, true);
            });
        }

        // 비밀번호 입력 제한
        if (loginPwdInput && pwdMsg) {
            loginPwdInput.addEventListener("input", function() {
                handleLengthLimit(loginPwdInput, pwdMsg, 20, false);
            });
        }

        // 부서 선택 시 권한 자동 변경
        if (deptSelect && roleSelect) {
            deptSelect.addEventListener("change", function() {

                if (this.value === "D01") {
                    roleSelect.value = "R";
                } else if (this.value !== "") {
                    roleSelect.value = "N";
                }

            });
        }

        // 전화번호 자동 하이픈
        if (phoneInput) {

            phoneInput.addEventListener("input", function() {

                let val = this.value.replace(/[^0-9]/g, '');

                if (val.length < 4) {
                    this.value = val;
                } else if (val.length < 8) {
                    this.value =
                        val.substring(0, 3) +
                        '-' +
                        val.substring(3);
                } else {
                    this.value =
                        val.substring(0, 3) +
                        '-' +
                        val.substring(3, 7) +
                        '-' +
                        val.substring(7, 11);
                }

            });

        }
        const textInputs = document.querySelectorAll(
        	    "#loginId, #loginPwd, input[name='name'], input[name='email'], input[name='address']"
        	);

        	textInputs.forEach(function(input) {

        	    input.addEventListener("input", function() {

        	        const cleaned = removeXss(this.value);

        	        if (this.value !== cleaned) {
        	            alert("특수문자는 입력할 수 없습니다.");
        	            this.value = cleaned;
        	        }

        	    });

        	});

    });
    
    
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