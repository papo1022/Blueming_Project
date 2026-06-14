<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Blueming Login</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/login.css">
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