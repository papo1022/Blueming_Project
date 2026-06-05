<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Blueming - 사원PWD 찾기</title>
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
	.find-area {
		border: 1px solid #ccc;
		padding: 30px;
		background: white;
		border-radius: 8px;
	}
	table th { text-align: left; padding: 5px; }
	table td { padding: 5px; }
	.auth-area { display: none; }
</style>
</head>
<body>

<div class="find-area" align="center">
	<h2>사원 PWD 찾기</h2>
	<p style="font-size:13px; color:gray;">사원 ID와 가입 이메일을 입력하여 본인인증을 진행해주세요.</p>
	
	<form id="find-pwd-form" action="/blueming/member/verifyPwdCode" method="post">
		<table>
			<tr>
				<th>사원 ID</th>
				<td><input type="text" id="loginId" name="loginId" required></td>
			</tr>
			<tr>
				<th>이름</th>
				<td><input type="text" id="name" name="name" required></td>
			</tr>
			<tr>
				<th>이메일</th>
				<td>
					<input type="email" id="email" name="email" required>
					<button type="button" id="btn-send-code">인증요청</button>
				</td>
			</tr>
			<tr class="auth-area">
				<th>인증번호</th>
				<td>
					<input type="text" name="code" placeholder="6자리 숫자 입력" required>
				</td>
			</tr>
			<tr align="center">
				<th colspan="2" style="padding-top:15px;">
					<button type="submit" id="btn-submit" disabled>인증 확인</button>
					<button type="button" onclick="history.back();">취소</button>
				</th>
			</tr>
		</table>
	</form>
</div>

<script>
$(document).ready(function() {
	$("#btn-send-code").click(function() {
		var loginId = $("#loginId").val();
		var name = $("#name").val();
		var email = $("#email").val();
		
		if(loginId == "" || name == "" || email == "") {
			alert("모든 빈칸을 채워주세요.");
			return;
		}
		
		$.ajax({
			url: "/blueming/member/sendCodeForPwd",
			type: "post",
			data: { loginId: loginId, name: name, email: email },
			success: function(result) {
				if(result === "SUCCESS") {
					alert("인증번호가 이메일로 발송되었습니다.");
					$(".auth-area").show();
					$("#btn-submit").prop("disabled", false);
				} else if(result === "NOT_FOUND") {
					alert("입력하신 정보와 일치하는 사원 정보가 없습니다.");
				} else {
					alert("이메일 발송 중 내부 에러가 발생했습니다.");
				}
			},
			error: function() { alert("서버 통신 실패"); }
		});
	});
});
</script>

</body>
</html>