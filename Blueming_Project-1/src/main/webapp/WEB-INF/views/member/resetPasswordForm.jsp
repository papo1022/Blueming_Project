<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Blueming - 비밀번호 변경</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>

body{
    margin:0;
    height:100vh;

    display:flex;
    justify-content:center;
    align-items:center;

    background:linear-gradient(135deg,#e8f4ff,#f7fbff);
    font-family:'Noto Sans KR',sans-serif;
}

.reset-area{
    width:420px;
    padding:40px;

    background:#fff;
    border-radius:20px;

    box-shadow:0 10px 30px rgba(25,118,210,0.15);
    box-sizing: border-box;
}

.reset-title{
    text-align:center;
    font-size:34px;
    font-weight:700;
    color:#1976d2;

    margin-bottom:10px;
}

.reset-desc{
    text-align:center;
    color:#666;
    font-size:13px;
    margin-bottom:25px;
    line-height:1.6;
}

.reset-area table{
    width:100%;
}

.reset-area th{
    width:110px; /* 라벨 텍스트 길이에 맞춰 약간 확장 */
    text-align:left;
    color:#1565c0;
    font-size:14px;
}

.reset-area td{
    padding:8px 0;
}

/* 입력창 스타일 통일 (password 타입 추가) */
.reset-area input[type=password]{
    width:100%;
    height:45px;

    border:1px solid #cfd8dc;
    border-radius:10px;

    padding:0 12px;
    box-sizing:border-box;

    transition:0.2s;
}

.reset-area input[type=password]:focus{
    outline:none;
    border-color:#2196f3;
    box-shadow:0 0 8px rgba(33,150,243,.25);
}

#btn-submit{
    width:100%;
    height:45px;

    border:none;
    border-radius:10px;

    background:#1976d2;
    color:white;

    font-size:15px;
    font-weight:600;

    cursor:pointer;
    transition:0.2s;
}

#btn-submit:hover{
    background:#1565c0;
}

#pwd-msg{
    display: inline-block;
    margin-top:6px;
    font-size:12px;
    font-weight: 500;
}

</style>
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