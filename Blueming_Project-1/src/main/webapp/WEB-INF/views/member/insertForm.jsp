<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 추가</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/memberList.css">
	<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/uicons-regular-rounded/css/uicons-regular-rounded.css">
	<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/uicons-solid-rounded/css/uicons-solid-rounded.css">
</head>
<body>
	<jsp:include page="../common/mainMenubar.jsp" />

    <div class="container">
       
        <form id="enrollForm" action="${pageContext.request.contextPath}/memberlist/insert" method="post">
            
            <div class="row">
			    <div class="label">사원번호</div>
			    <div class="value">
                    <input type="text" name="memberId" id="memberId" placeholder="숫자만 입력" required>
                    <span id="memMsg" style="color: red; font-size: 12px; display: none;"></span>
                </div>
			</div>
            
            <div class="row">
                <div class="label">로그인ID</div>
                <div class="value">
                    <input type="text" name="loginId" id="loginId" required>
                    <span id="idMsg" style="color: red; font-size: 12px; display: none;"></span>
                </div>
            </div>
            
            <div class="row">
			    <div class="label">비밀번호</div>
                <div class="value">
                    <input type="password" name="loginPwd" id="loginPwd" required>
			        <span id="pwdMsg" style="color: red; font-size: 12px; display: none;"></span>
			    </div>
			</div>
			
			<div class="row">
                <div class="label">이름</div>
                <div class="value">
                    <input type="text" name="name" id="name" required>
                    <span id="nameMsg" style="color: red; font-size: 12px; display: none;"></span>
                </div>
            </div>
			
			<div class="row">
			    <div class="label">이메일</div>
                <div class="value"><input type="email" name="email" maxlength="100" required></div>
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
			
			<div class="row">
			    <div class="label">주소</div>
                <div class="value">
                    <input type="text" name="address" id="address" required>
                    <span id="addressMsg" style="color: red; font-size: 12px; display: none;"></span>
                </div>
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
    // 1. 확장형 공통 글자수 및 정규식 제한 함수
    function handleLengthLimit(inputEl, msgEl, limit, fieldType) {
        if (!inputEl) return;
        
        let val = inputEl.value;
        let filtered = val;
        let errorMsg = "";

        if (fieldType === "empNo") {
            filtered = val.replace(/[^0-9]/g, '');
            if (val !== filtered) errorMsg = "사원번호는 숫자만 입력 가능합니다.";
            
        } else if (fieldType === "id") {
            filtered = val.replace(/[^a-zA-Z0-9]/g, '');
            if (val !== filtered) errorMsg = "아이디는 영문과 숫자만 입력 가능합니다.";
            
        } else if (fieldType === "name") {
            filtered = val.replace(/[^a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣\s]/g, '');
            if (val !== filtered) errorMsg = "이름은 영문과 한글만 입력 가능합니다.";
            
        } else if (fieldType === "address") {
            filtered = val.replace(/[^a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣\s]/g, '');
            if (val !== filtered) errorMsg = "주소에는 특수문자를 입력할 수 없습니다.";
        }

        if (val !== filtered) {
            if (msgEl) {
                msgEl.textContent = errorMsg;
                msgEl.style.color = "red";
                msgEl.style.display = "block";
            }
            inputEl.value = filtered;
            return;
        }

        if (filtered.length >= limit) {
            if (msgEl) {
                msgEl.textContent = `최대 ${limit}자까지 입력 가능합니다.`;
                msgEl.style.color = "red";
                msgEl.style.display = "block";
            }
            if (filtered.length > limit) {
                inputEl.value = filtered.substring(0, limit);
            }
        } else {
            // 사원번호는 실시간 검사 결과를 유지해야 하므로 empNo가 아닐 때만 숨김
            if (msgEl && fieldType !== "empNo") msgEl.style.display = "none";
        }
    }

    // 🌟 [컨트롤러 안 건드리는 우회 통신] 
    // 새 매핑 주소 대신 이미 만들어져서 정상 작동하는 "사원 목록 페이지" 주소를 활용해 사번을 조회합니다.
    function checkMemberIdDup(memberIdInput, msgEl) {
        const memberId = memberIdInput.value.trim();
        
        if(memberId === "") {
            msgEl.style.display = "none";
            memberIdInput.setAttribute("data-checked", "false");
            return;
        }

        // 기존 사원 목록 화면 주소를 찌릅니다.
        const url = `${pageContext.request.contextPath}/memberlist`;

        fetch(url)
            .then(response => response.text()) // 화면 HTML 전체를 문자로 긁어옴
            .then(html => {
                // 가져온 사원 목록 페이지 텍스트 안에 입력한 사원번호가 그대로 포함되어 있다면?
                // 중복된 사원으로 판단하고 가드를 올립니다.
                if (html.includes(memberId)) { 
                    msgEl.textContent = "이미 존재하는 사원번호입니다.";
                    msgEl.style.color = "red";
                    msgEl.style.display = "block";
                    memberIdInput.setAttribute("data-checked", "false"); // 등록 차단
                } else {
                    msgEl.textContent = "사용 가능한 사원번호입니다.";
                    msgEl.style.color = "green";
                    msgEl.style.display = "block";
                    memberIdInput.setAttribute("data-checked", "true"); // 등록 허용
                }
            })
            .catch(err => {
                console.error("중복 검사 오류:", err);
            });
    }

    // 2. 최종 등록 버튼 클릭 시 유효성 완벽 최종 검사
    function submitEnrollForm() {
        const form = document.getElementById("enrollForm");
        const memberId = document.getElementById("memberId");
        const loginId = document.getElementById("loginId");
        const loginPwd = document.getElementById("loginPwd");
        const name = document.getElementById("name");
        const phoneInput = document.getElementById("phoneInput");
        const address = document.getElementById("address");

        if (!/^[0-9]+$/.test(memberId.value)) {
            alert("사원번호는 숫자만 입력 가능합니다.");
            memberId.focus();
            return;
        }

        // 🌟 배경 조회를 통과하지 못하면 애초에 서버(컨트롤러)로 데이터가 넘어가지 못하게 막습니다. (500 에러 원천 차단)
        if (memberId.getAttribute("data-checked") !== "true") {
            alert("사원번호 중복 확인이 필요하거나 이미 사용 중인 번호입니다.");
            memberId.focus();
            return;
        }
        
        if (!/^[a-zA-Z0-9]+$/.test(loginId.value)) {
            alert("아이디는 영문과 숫자만 입력 가능합니다.");
            loginId.focus();
            return;
        }

        if (loginId.value.length > 20) {
            alert("아이디는 최대 20자까지 가능합니다.");
            loginId.focus();
            return;
        }

        if (loginPwd.value.length > 20) {
            alert("비밀번호는 최대 20자까지 가능합니다.");
            loginPwd.focus();
            return;
        }
        
        if (!/^[a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣\s]+$/.test(name.value)) {
            alert("이름은 영문과 한글만 입력 가능합니다.");
            name.focus();
            return;
        }

        if (phoneInput.value.length !== 13) {
            alert("연락처는 010-1234-5678 형식으로 입력해주세요.");
            phoneInput.focus();
            return;
        }
        
        if (!/^[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣\s]+$/.test(address.value)) {
            alert("주소는 한글, 영문, 숫자, 공백만 입력 가능합니다.");
            address.focus();
            return;
        }

        if (form.checkValidity()) {
            document.querySelectorAll("input[type='text'], input[type='password'], input[type='email']")
                .forEach(function(el) {
                    el.value = removeXss(el.value);
                });
            form.submit();
        } else {
            form.reportValidity();
        }
    }

    // 3. 이벤트 감지기 바인딩
    document.addEventListener("DOMContentLoaded", function() {
        const memberIdInput = document.getElementById("memberId");
        const loginIdInput = document.getElementById("loginId");
        const loginPwdInput = document.getElementById("loginPwd");
        
        const memMsg = document.getElementById("memMsg");
        const idMsg = document.getElementById("idMsg");
        const pwdMsg = document.getElementById("pwdMsg");
        const nameMsg = document.getElementById("nameMsg");
        const addressMsg = document.getElementById("addressMsg");
        
        const nameInput = document.getElementById("name");
        const addressInput = document.getElementById("address");
        const deptSelect = document.getElementById("deptSelect");
        const roleSelect = document.getElementById("role");
        const phoneInput = document.getElementById("phoneInput");

        // 사원번호 세팅 (실시간 입력 제한 + 목록 HTML 기반 실시간 검증 재호출)
        if (memberIdInput && memMsg) {
            memberIdInput.addEventListener("input", function() {
                handleLengthLimit(this, memMsg, 15, "empNo");
                checkMemberIdDup(this, memMsg); // 👈 실시간 우회 대조 활성화
            });
        }

        // 아이디 세팅
        if (loginIdInput && idMsg) {
            loginIdInput.addEventListener("input", function() {
                handleLengthLimit(this, idMsg, 20, "id");
            });
        }

        // 비밀번호 세팅
        if (loginPwdInput && pwdMsg) {
            loginPwdInput.addEventListener("input", function() {
                handleLengthLimit(this, pwdMsg, 20, "pwd");
            });
        }

        // 이름 세팅
        if (nameInput && nameMsg) {
            nameInput.addEventListener("input", function() {
                handleLengthLimit(this, nameMsg, 30, "name");
            });
        }

        // 주소 세팅
        if (addressInput && addressMsg) {
            addressInput.addEventListener("input", function() {
                handleLengthLimit(this, addressMsg, 200, "address");
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
                    this.value = val.substring(0, 3) + '-' + val.substring(3);
                } else {
                    this.value = val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + val.substring(7, 11);
                }
            });
        }
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