<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Blueming - 비밀번호 변경 완료</title>
<style>
	body {
		margin: 0;
		height: 100vh;

		display: flex;
		justify-content: center; /* 가로 가운데 */
		align-items: center;     /* 세로 가운데 */
		background-color: #f5f6f7;
	}

	.success-area {
		border: 1px solid #ccc;
		padding: 40px 30px;
		background: white;
		border-radius: 8px;
		box-shadow: 0 4px 6px rgba(0,0,0,0.05);
		min-width: 340px;
	}

	.icon-box {
		font-size: 45px;
		color: #03c75a;
		margin-bottom: 15px;
	}
	
	.btn-area {
		margin-top: 25px;
	}
	
	/* 기존 로그인 화면의 버튼 스타일 유지용 클래스 */
	.btn-secondary {
		background-color: #6c757d;
		color: white;
		border: none;
		padding: 6px 12px;
		cursor: pointer;
		border-radius: 4px;
	}
	.btn-sm {
		font-size: 14px;
	}
	.btn-secondary:hover {
		background-color: #5a6268;
	}
</style>
</head>
<body>
		
	<div class="success-area" align="center">
		
		<div class="icon-box">✔</div>
		
		<h2 style="margin-top: 0; color: #333; font-size: 22px;">비밀번호 변경 완료</h2>
		
		<p style="font-size: 13px; color: gray; line-height: 1.5; margin-bottom: 10px;">
			사원님의 비밀번호가<br>성공적으로 재설정되었습니다.
		</p>
		<p style="font-size: 12px; color: #dc3545; font-weight: bold;">
			안전을 위해 기존에 생성된<br>인증 세션은 모두 초기화되었습니다.
		</p>
		
		<div class="btn-area">
			<button type="button" class="btn btn-secondary btn-sm" 
					onclick="location.href='/blueming/'">로그인 하러가기</button>
		</div>

	</div>	

</body>
</html>