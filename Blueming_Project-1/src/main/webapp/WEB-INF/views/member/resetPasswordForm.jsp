<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Blueming - 비밀번호 변경</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
	body {
		margin: 0;
		height: 100vh;
		display: flex;
		justify-content: center;
		align-items: center;
		background-color: #f5f6f7;
	}
	.reset-area {
		border: 1px solid #ccc;
		padding: 30px;
		background: white;
		border-radius: 8px;
	}
	table th { text-align: left; padding: 5px; }
	table td { padding: 5px; }
</style>
</head>
<body>

<div class="reset-area" align="center">
	<h2>새 비밀번호 설정</h2>
	<p style="font-size:13px; color:gray;">새롭게 사용할 비밀번호를 안전하게 입력해 주세요.</p>
	
	<form id="reset-form" action="/blueming/member/resetPassword" method="post">
		<table>
			<tr>
				<th>새 비밀번호</th>
				<td><input type="password" id="newPwd" name="newPwd" required></td>
			</tr>
			<tr>
				<th>비밀번호 확인</th>
				<td>
					<input type="password" id="newPwdCheck" required>
					<br><span id="pwd-msg" style="font-size:12px;"></span>
				</td>
			</tr>
			<tr align="center">
				<th colspan="2" style="padding-top:15px;">
					<button type="submit">비밀번호 변경 완료</button>
				</th>
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
			$("#pwd-msg").text("비밀번호가 일치합니다.").css("color", "green");
		} else {
			$("#pwd-msg").text("비밀번호가 일치하지 않습니다.").css("color", "red");
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