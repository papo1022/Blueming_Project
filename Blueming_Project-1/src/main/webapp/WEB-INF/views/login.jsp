<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>blueming</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
	body {
		margin: 0;
		height: 100vh;

		display: flex;
		justify-content: center; /* 가로 가운데 */
		align-items: center;     /* 세로 가운데 */
	}

	/* Caps Lock 경고 메시지 스타일 */
	.caps-warning {
		color: #e74c3c;
		font-size: 12px;
		font-weight: bold;
		text-align: left;
		padding-top: 3px;
		display: none; /* 기본적으로 숨김 */
	}
	.login-error{
    width: 320px;
    margin-bottom: 15px;
    padding: 12px;

    background: #fff5f5;
    border: 1px solid #ffb3b3;
    border-radius: 6px;

    color: #ff1616;
    font-size: 13px;
    text-align: left;
    box-sizing: border-box;
}
</style>

</head>
<body>

		<c:if test="${ not empty errorMsg }">
    <div class="login-error">
        아이디 또는 비밀번호를 잘못 입력했습니다.<br>
        입력하신 내용을 다시 확인해주세요.
    </div>
		</c:if>
		<div class="login-area" align="center">
	
					<form id="login-form" action="/blueming/member/login" method="post"> 
			
						<table>
							<tr>
							    <th>아이디</th>
							    <td>
							        <input type="text" id="loginId" name="loginId" required value="${ cookie.saveId.value }">
							        
							    </td>
							</tr>
							<tr>
							    <th>비밀번호</th>
							    <td>
							        <input type="password" id="loginPwd" name="loginPwd" required>
							        <div id="capslock-warning" class="caps-warning">⚠️ Caps Lock이 켜져 있습니다.</div>
							    </td>
							</tr>
							<tr align="right">
								<th colspan="2">
									<input type="checkbox" id="saveId" name="saveId" value="y">
									<label for="saveId">아이디 저장</label>
								</th>
							</tr>
							<tr align="center">
								<th colspan="2">
									<button type="submit" class="btn btn-secondary btn-sm">로그인</button>
								</th>
							</tr>
							<tr align="center">
								<th colspan="2">
									<button type="button" class="btn btn-secondary btn-sm" 
														onclick="enrollPage1()">사원ID 찾기</button>
									<button type="button" class="btn btn-secondary btn-sm"
														onclick="enrollPage2()">사원PWD 찾기</button>
								</th>
							</tr>
							
						</table>
			
					</form>	
					<script>
					function enrollPage1() {
						location.href = "/blueming/member/enrollForm1";
					}
				</script>
				<script>
					function enrollPage2() {
						location.href = "/blueming/member/enrollForm2";
					}
				</script>	
			
		</div>
	
		<br clear="both"> <br>
	
		<script>
		$(function() {
		    
		    // 3. 쿠키가 있다면 요소에 아이디 저장을 표현해주기
		    let saveId = "${ cookie.saveId.value }"; 
		    if(saveId != "") {
		        $("#saveId").prop("checked", true);
		    }
		    
		    // ==========================================
		    // 4. 전역(Window) Caps Lock 감지 및 입력 전 알림 처리
		    // ==========================================
		    
		    const $idInput = $("#loginId");
		    const $pwdInput = $("#loginPwd");
		    
		    const $idWarning = $("#id-capslock-warning");
		    const $pwdWarning = $("#capslock-warning");

		    // 현재 Caps Lock의 전역 상태를 저장할 변수
		    let isCapsLockOn = false;

		    // 윈도우 전체에서 키보드나 마우스 조작이 일어날 때 Caps Lock 상태를 계속 업데이트
		    $(window).on("keydown keyup click", function(e) {
		        if (e.originalEvent && e.originalEvent.getModifierState) {
		            isCapsLockOn = e.originalEvent.getModifierState("CapsLock");
		            
		            // 사용자가 다른 곳을 누르다가도 현재 포커스된 창이 있다면 실시간 갱신
		            if (isCapsLockOn) {
		                if ($idInput.is(":focus")) $idWarning.show();
		                if ($pwdInput.is(":focus")) $pwdWarning.show();
		            } else {
		                $idWarning.hide();
		                $pwdWarning.hide();
		            }
		        }
		    });

		   

		    // [비밀번호 입력창 포커스 이벤트]
		    $pwdInput.on("focus", function() {
		        // 입력하기 전(포커스된 순간)에 이미 윈도우가 감지한 상태가 true라면 바로 표시
		        if (isCapsLockOn) {
		            $pwdWarning.show();
		        }
		    }).on("blur", function() {
		        $pwdWarning.hide();
		    });
		    
		});
		</script>
</body>
</html>