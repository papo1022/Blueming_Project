<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    justify-content: center;
    align-items: center;

    /* 첫 번째 화면과 동일한 배경 그라데이션 및 폰트 */
    background: linear-gradient(135deg, #e8f4ff, #f7fbff);
    font-family: 'Noto Sans KR', sans-serif;
}

.success-area {
    width: 420px; /* 너비 통일 */
    padding: 40px; /* 패딩 통일 */

    background: #fff;
    border-radius: 20px; /* 라운드 코너 통일 */

    /* 동일한 블러 값과 블루톤 그림자 적용 */
    box-shadow: 0 10px 30px rgba(25, 118, 210, 0.15);
    box-sizing: border-box;
    text-align: center;
}

/* 체크 아이콘을 Blueming 메인 블루 컬러로 변경 및 부드러운 박스 처리 */
.icon-box {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    width: 60px;
    height: 60px;
    background-color: #f0f7ff;
    border-radius: 50%;
    
    font-size: 28px;
    color: #1976d2;
    margin-bottom: 20px;
}

.success-title {
    font-size: 28px;
    font-weight: 700;
    color: #1976d2;
    margin-top: 0;
    margin-bottom: 15px;
}

.success-desc {
    color: #666;
    font-size: 13px;
    line-height: 1.6;
    margin-bottom: 12px;
}

/* 경고 문구 색상을 테마에 맞게 톤 다운된 고급스러운 레드로 변경 */
.alert-notice {
    font-size: 12px;
    color: #c62828;
    font-weight: 600;
    line-height: 1.6;
}

.btn-area {
    margin-top: 30px;
}

/* 첫 번째 화면의 '확인' 버튼과 동일한 스타일 적용 */
.btn-primary {
    width: 100%;
    height: 45px;

    border: none;
    border-radius: 10px;

    background: #1976d2;
    color: white;

    font-size: 15px;
    font-weight: 600;

    cursor: pointer;
    transition: 0.2s;
}

.btn-primary:hover {
    background: #1565c0;
}

</style>
</head>
<body>
        
    <div class="success-area">
        
        <div class="icon-box">✔</div>
        
        <div class="success-title">비밀번호 변경 완료</div>
        
        <div class="success-desc">
            사원님의 비밀번호가<br>성공적으로 재설정되었습니다.
        </div>
        
        <div class="alert-notice">
            안전을 위해 기존에 생성된<br>인증 세션은 모두 초기화되었습니다.
        </div>
        
        <div class="btn-area">
            <button type="button" class="btn-primary" 
                    onclick="location.href='/blueming/'">로그인 하러가기</button>
        </div>

    </div>  

</body>
</html>