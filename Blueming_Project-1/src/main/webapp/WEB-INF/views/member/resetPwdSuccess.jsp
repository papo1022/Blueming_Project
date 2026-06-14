<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Blueming - 비밀번호 변경 완료</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/resetPwdSuccess.css">
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