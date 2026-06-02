<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Blueming - 사원ID 찾기</title>
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
	.auth-area { display: none; } /* 인증번호 영역 처음엔 숨김 */
</style>
</head>
<body>

<div class="find-area" align="center">
	<h2>사원 ID 찾기</h2>
	<p style="font-size:13px; color:gray;">가입할 때 등록한 이름과 이메일을 입력해주세요.</p>
	
	<form id="find-id-form" action="/blueming/member/findId" method="post">
		<table>
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
					<button type="submit" id="btn-submit" disabled>확인</button>
					<button type="button" onclick="history.back();">취소</button>
				</th>
			</tr>
		</table>
	</form>
</div>

<script>
$(document).ready(function() {
	// 인증요청 버튼 클릭 시 AJAX 발송
	$("#btn-send-code").click(function() {
		var name = $("#name").val();
		var email = $("#email").val();
		
		if(name == "" || email == "") {
			alert("이름과 이메일을 모두 입력해주세요.");
			return;
		}
		
		$.ajax({
			url: "/blueming/member/sendCodeForId",
			type: "post",
			data: { name: name, email: email },
			success: function(result) {
				if(result === "SUCCESS") {
					alert("인증번호가 이메일로 발송되었습니다.");
					$(".auth-area").show();       // 인증번호 입력창 보여주기
					$("#btn-submit").prop("disabled", false); // 확인 버튼 활성화
				} else if(result === "NOT_FOUND") {
					alert("일치하는 사원 정보가 존재하지 않습니다.");
				} else {
					alert("이메일 발송 중 오류가 발생했습니다.");
				}
			},
			error: function() {
				alert("서버 통신에 실패했습니다.");
			}
		});
	});
});
</script>

</body>
</html>