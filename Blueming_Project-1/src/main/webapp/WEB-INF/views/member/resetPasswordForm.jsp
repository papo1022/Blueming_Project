<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Blueming - 비밀번호 변경</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/resetPasswordForm.css">
</head>
<body>

<div class="reset-area">
    <div class="reset-title">
        Blueming
    </div>
    
    <div class="reset-desc">
        새롭게 사용할 비밀번호를<br>안전하게 입력해 주세요.
    </div>
	
	<form id="reset-form" action="/blueming/member/resetPassword" method="post">
		<table>
			<tr>
				<th>새 비밀번호</th>
				<td>
                    <input type="password" id="newPwd" name="newPwd" placeholder="새 비밀번호 입력" maxlength="20" required>
			    </td>
			</tr>
			<tr>
				<th>비밀번호 확인</th>
				<td>
                    <input type="password" id="newPwdCheck" placeholder="비밀번호 재입력" maxlength="20" required>
					<span id="pwd-msg"></span>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="padding-top:25px;">
					<button type="submit" id="btn-submit">비밀번호 변경 완료</button>
				</td>
			</tr>
		</table>
	</form>
</div>

<script>
$(document).ready(function() {
	// 비밀번호와 비밀번호 확인 칸이 일치하는지 실시간 검증
	$("#newPwd, #newPwdCheck").keyup(function() {
		var pwd = $("#newPwd").val();
		var pwdCheck = $("#newPwdCheck").val();
		
		if(pwdCheck == "") {
			$("#pwd-msg").text("");
			return;
		}
		
		if(pwd === pwdCheck) {
			$("#pwd-msg").text("비밀번호가 일치합니다.").css("color", "#2e7d32"); // 조금 더 세련된 다크 그린
		} else {
			$("#pwd-msg").text("비밀번호가 일치하지 않습니다.").css("color", "#d32f2f"); // 테마와 맞는 다크 레드
		}
	});

	// form 전송 시 최종 체크
	$("#reset-form").submit(function(e) {
		var pwd = $("#newPwd").val();
		var pwdCheck = $("#newPwdCheck").val();
		
		if(pwd !== pwdCheck) {
			alert("비밀번호 확인이 불일치합니다.");
			e.preventDefault(); // submit 중단
			return false;
		}
	});
});
</script>

</body>
</html>