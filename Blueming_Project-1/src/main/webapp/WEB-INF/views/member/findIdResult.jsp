<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    justify-content: center;
    align-items: center;

    /* 첫 번째 화면과 동일한 배경 그라데이션 및 폰트 */
    background: linear-gradient(135deg, #e8f4ff, #f7fbff);
    font-family: 'Noto Sans KR', sans-serif;
}

.result-area {
    width: 420px; /* 너비 통일 */
    padding: 40px; /* 패딩 통일 */

    background: #fff;
    border-radius: 20px; /* 라운드 코너 통일 */

    /* 동일한 블러 값과 블루톤 그림자 적용 */
    box-shadow: 0 10px 30px rgba(25, 118, 210, 0.15);
    box-sizing: border-box;
    text-align: center;
}

.result-title {
    font-size: 28px;
    font-weight: 700;
    color: #1976d2; /* 메인 블루 컬러 */
    margin-top: 0;
    margin-bottom: 10px;
}

.result-desc {
    color: #666;
    font-size: 13px;
    margin-bottom: 25px;
    line-height: 1.6;
}

/* 초록색 점선 박스를 브랜드 감성의 부드러운 블루 박스로 변경 */
.id-display-box {
    background-color: #f0f7ff;
    border: 1px dashed #2196f3;
    padding: 20px;
    margin: 30px 0;
    
    font-size: 22px;
    font-weight: 700;
    color: #1565c0;
    
    border-radius: 12px;
    letter-spacing: 1px;
}

.btn-area {
    margin-top: 20px;
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
        
    <div class="result-area">
        
        <div class="result-title">사원 ID 찾기 완료</div>
        
        <div class="result-desc">
            입력하신 본인확인 이메일 정보와<br>일치하는 사원 ID입니다.
        </div>

        <div class="id-display-box">
            ${ loginId }
        </div>
        
        <div class="btn-area">
            <button type="button" class="btn-primary" 
                    onclick="location.href='/blueming/'">로그인 화면으로</button>
        </div>

    </div>  

</body>
</html>