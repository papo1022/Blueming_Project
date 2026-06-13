<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Blueming Login</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

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

.login-area{
    width:420px;
    padding:40px;

    background:#fff;
    border-radius:20px;

    box-shadow:0 10px 30px rgba(25,118,210,0.15);
}

.login-title{
    text-align:center;
    font-size:34px;
    font-weight:700;
    color:#1976d2;

    margin-bottom:30px;
}

.login-area table{
    width:100%;
}

.login-area th{
    width:90px;
    text-align:left;
    color:#1565c0;
    font-size:14px;
}

.login-area td{
    padding:8px 0;
}

.login-area input[type=text],
.login-area input[type=password]{
    width:100%;
    height:45px;

    border:1px solid #cfd8dc;
    border-radius:10px;

    padding:0 12px;
    box-sizing:border-box;

    transition:0.2s;
}

.login-area input[type=text]:focus,
.login-area input[type=password]:focus{
    outline:none;
    border-color:#2196f3;
    box-shadow:0 0 8px rgba(33,150,243,.25);
}

.login-error{
    width:100%;
    margin-bottom:15px;
    padding:14px;

    background:#eef7ff;
    border:1px solid #90caf9;
    border-left:5px solid #1976d2;

    border-radius:10px;

    color:#0d47a1;
    font-size:13px;
    line-height:1.5;

    box-sizing:border-box;
}

.caps-warning{
    color:#1565c0;
    font-size:12px;
    font-weight:bold;
    padding-top:5px;
    display:none;
}

.login-btn{
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

.login-btn:hover{
    background:#1565c0;
}

.sub-btn{
    border:none;
    background:none;

    color:#1976d2;
    font-size:13px;

    cursor:pointer;
}

.sub-btn:hover{
    text-decoration:underline;
}

</style>
</head>
<body>

<div class="login-area">

    <div class="login-title">
        Blueming
    </div>

    <c:if test="${ not empty errorMsg }">
        <div class="login-error">
            아이디 또는 비밀번호가 일치하지 않습니다.<br>
            입력한 정보를 다시 확인해주세요.
        </div>
    </c:if>

    <form id="login-form" action="/blueming/member/login" method="post">

        <table>
            <tr>
                <th>아이디</th>
                <td>
                    <input type="text"
                           id="loginId"
                           name="loginId"
                              maxlength="20"
                           required
                           value="${cookie.saveId.value}">
                </td>
            </tr>

            <tr>
                <th>비밀번호</th>
                <td>
                    <input type="password"
                           id="loginPwd"
                           name="loginPwd"
                              maxlength="20"
                           required>

                    <div id="capslock-warning"
                         class="caps-warning">
                        ⚠ Caps Lock이 켜져 있습니다.
                    </div>
                </td>
            </tr>

            <tr>
                <td colspan="2" align="right">
                    <input type="checkbox"
                           id="saveId"
                           name="saveId"
                           value="y">

                    <label for="saveId">
                        아이디 저장
                    </label>
                </td>
            </tr>

            <tr>
                <td colspan="2">
                    <button type="submit"
                            class="login-btn">
                        로그인
                    </button>
                </td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <button type="button"
                            class="sub-btn"
                            onclick="enrollPage1()">
                        사원 ID 찾기
                    </button>

                    |

                    <button type="button"
                            class="sub-btn"
                            onclick="enrollPage2()">
                        비밀번호 찾기
                    </button>
                </td>
            </tr>

        </table>

    </form>

</div>

<script>

function enrollPage1(){
    location.href="/blueming/member/enrollForm1";
}

function enrollPage2(){
    location.href="/blueming/member/enrollForm2";
}

$(function(){

    let saveId = "${cookie.saveId.value}";

    if(saveId != ""){
        $("#saveId").prop("checked", true);
    }

    const $pwdInput = $("#loginPwd");
    const $pwdWarning = $("#capslock-warning");

    let isCapsLockOn = false;

    $(window).on("keydown keyup click", function(e){

        if(e.originalEvent &&
           e.originalEvent.getModifierState){

            isCapsLockOn =
                e.originalEvent.getModifierState("CapsLock");

            if(isCapsLockOn){
                if($pwdInput.is(":focus")){
                    $pwdWarning.show();
                }
            }else{
                $pwdWarning.hide();
            }
        }
    });

    $pwdInput.on("focus", function(){

        if(isCapsLockOn){
            $pwdWarning.show();
        }

    }).on("blur", function(){

        $pwdWarning.hide();

    });

});

</script>

</body>
</html>