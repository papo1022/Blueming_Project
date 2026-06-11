<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Blueming - 사원PWD 찾기</title>
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

.find-area{
    width:420px;
    padding:40px;

    background:#fff;
    border-radius:20px;

    box-shadow:0 10px 30px rgba(25,118,210,0.15);
}

.find-title{
    text-align:center;
    font-size:34px;
    font-weight:700;
    color:#1976d2;

    margin-bottom:10px;
}

.find-desc{
    text-align:center;
    color:#666;
    font-size:13px;
    margin-bottom:25px;
    line-height:1.6;
}

.find-area table{
    width:100%;
}

.find-area th{
    width:90px;
    text-align:left;
    color:#1565c0;
    font-size:14px;
}

.find-area td{
    padding:8px 0;
}

/* 모든 입력창 스타일 통일 */
.find-area input[type=text],
.find-area input[type=email]{
    width:100%;
    height:45px;

    border:1px solid #cfd8dc;
    border-radius:10px;

    padding:0 12px;
    box-sizing:border-box;

    transition:0.2s;
}

.find-area input[type=text]:focus,
.find-area input[type=email]:focus{
    outline:none;
    border-color:#2196f3;
    box-shadow:0 0 8px rgba(33,150,243,.25);
}

.email-wrap{
    display:flex;
    gap:8px;
}

.email-wrap input{
    flex:1;
}

#btn-send-code{
    width:100px;
    border:none;
    border-radius:10px;

    background:#1976d2;
    color:white;

    font-size:13px;
    font-weight:600;

    cursor:pointer;
    transition:0.2s;
}

#btn-send-code:hover{
    background:#1565c0;
}

/* 테이블 레이아웃 유지를 위한 클래스 제어 방식 */
.auth-area {
    display: none; 
}

.auth-area.is-visible {
    display: table-row !important;
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

#btn-submit:disabled{
    background:#b0bec5;
    cursor:not-allowed;
}

.cancel-btn{
    width:100%;
    height:45px;

    margin-top:10px;

    border:none;
    border-radius:10px;

    background:#eceff1;
    color:#546e7a;

    font-size:15px;
    font-weight:600;

    cursor:pointer;
    transition:0.2s;
}

.cancel-btn:hover{
    background:#dfe5e8;
}

.auth-notice{
    margin-top:8px;
    font-size:12px;
    color:#1976d2;
}

</style>
</head>
<body>

<div class="find-area">

    <div class="find-title">
        Blueming
    </div>

    <div class="find-desc">
        사원 ID와 가입 이메일을 입력하여<br>
        본인인증을 진행해주세요.
    </div>
    
    <form id="find-pwd-form" action="/blueming/member/verifyPwdCode" method="post">
        <table>
            <tr>
                <th>사원 ID</th>
                <td>
                    <input type="text" id="loginId" name="loginId" required>
                </td>
            </tr>
            <tr>
                <th>이름</th>
                <td>
                    <input type="text" id="name" name="name" required>
                </td>
            </tr>
            <tr>
                <th>이메일</th>
                <td>
                    <div class="email-wrap">
                        <input type="email" id="email" name="email" required>
                        <button type="button" id="btn-send-code">인증요청</button>
                    </div>
                </td>
            </tr>
            <tr class="auth-area">
                <th>인증번호</th>
                <td>
                    <input type="text" name="code" placeholder="6자리 숫자 입력" style="width:100%;">
                    <div class="auth-notice">
                        이메일로 받은 인증번호를 입력해주세요.
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding-top:20px;">
                    <button type="submit" id="btn-submit" disabled>인증 확인</button>
                    <button type="button" class="cancel-btn" onclick="history.back();">취소</button>
                </td>
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
                    // .show() 대신 테이블 레이아웃을 지켜주는 클래스 추가 방식으로 수정
                    $(".auth-area").addClass("is-visible");
                    $("#btn-submit").prop("disabled", false);
                } else if(result === "NOT_FOUND") {
                    alert("입력하신 정보와 일치하는 사원 정보가 없습니다.");
                } else {
                    alert("이메일 발송 중 내부 에러가 발생했습니다.");
                }
            },
            error: function() { 
                alert("서버 통신 실패"); 
            }
        });
    });
});
</script>

</body>
</html>