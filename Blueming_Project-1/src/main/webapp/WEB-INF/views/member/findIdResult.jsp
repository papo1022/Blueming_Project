<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Blueming - 사원ID 찾기 결과</title>
<style>
	body {
		margin: 0;
		height: 100vh;

		display: flex;
		justify-content: center; /* 가로 가운데 */
		align-items: center;     /* 세로 가운데 */
		background-color: #f5f6f7;
	}

	.result-area {
		border: 1px solid #ccc;
		padding: 40px 30px;
		background: white;
		border-radius: 8px;
		box-shadow: 0 4px 6px rgba(0,0,0,0.05);
		min-width: 320px;
	}

	.id-display-box {
		background-color: #f8f9fa;
		border: 1px dashed #03c75a;
		padding: 20px;
		margin: 20px 0;
		font-size: 18px;
		font-weight: bold;
		color: #03c75a;
		border-radius: 4px;
		letter-spacing: 1px;
	}
	
	.btn-area {
		margin-top: 20px;
	}
	
	/* 기존 로그인 화면의 버튼 스타일 유지용 임시 클래스 */
	.btn-secondary {
		background-color: #6c757d;
		color: white;
		border: none;
		padding: 5px 10px;
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
		
	<div class="result-area" align="center">
		
		<h2 style="margin-top: 0; color: #333;">사원 ID 찾기 완료</h2>
		<p style="font-size: 13px; color: gray; margin-bottom: 25px;">
			입력하신 본인확인 이메일 정보와<br>일치하는 사원 ID입니다.
		</p>

		<div class="id-display-box">
			${ loginId }
		</div>
		
		<div class="btn-area">
			<button type="button" class="btn btn-secondary btn-sm" 
					onclick="location.href='/blueming/'">로그인 화면으로</button>
		</div>

	</div>	

</body>
</html>