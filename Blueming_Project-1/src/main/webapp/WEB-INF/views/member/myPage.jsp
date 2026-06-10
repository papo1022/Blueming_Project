<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MyPage</title>

<script src="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/alertify.min.js"></script>

<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/alertify.min.css"/>
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/themes/default.min.css"/>
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.14.0/build/css/themes/semantic.min.css"/>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

</head>

<body>

<div class="outer">

    <br>
    <h2 align="center">마이페이지</h2>
    <br>

    <!-- 정보 수정 form -->
    <form id="mypage-form" action="/blueming/member/update" method="post">

        <table>

            <tr>
                <th>아이디</th>
                <td>
                    <input type="text" name="loginId" readonly
                           value="${sessionScope.loginUser.loginId}">
                </td>
            </tr>

            <tr>
                <th>이름</th>
                <td>
                    <input type="text" name="name"
                           value="${sessionScope.loginUser.name}">
                </td>
            </tr>

            <tr>
                <th>전화번호</th>
                <td>
                    <input type="text" name="phone"
                           value="${sessionScope.loginUser.phone}">
                </td>
            </tr>

            <tr>
                <th>이메일</th>
                <td>
                    <input type="email" name="email"
                           value="${sessionScope.loginUser.email}">
                </td>
            </tr>

            <tr>
                <th>주소</th>
                <td>
                    <input type="text" name="address"
                           value="${sessionScope.loginUser.address}">
                </td>
            </tr>

        </table>

        <br>

        <div align="center">
            <button type="button"
                    class="btn btn-primary btn-sm"
                    data-toggle="modal"
                    data-target="#updateInfoModal">
                정보변경
            </button>

            <button type="button"
                    class="btn btn-warning btn-sm"
                    data-toggle="modal"
                    data-target="#updatePwdModal">
                비밀번호변경
            </button>
        </div>

    </form>

</div>

<!-- ========================= -->
<!-- 정보 변경 확인 모달 -->
<!-- ========================= -->
<div class="modal fade" id="updateInfoModal">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">정보 변경 확인</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>

            <div class="modal-body text-center">
                입력한 정보로 변경하시겠습니까?
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">
                    취소
                </button>

                <button type="button" class="btn btn-primary"
                        onclick="submitInfo();">
                    확인
                </button>
            </div>

        </div>
    </div>
</div>

<script>
function submitInfo() {
    document.getElementById("mypage-form").submit();
}
</script>


<!-- ========================= -->
<!-- 비밀번호 변경 모달 -->
<!-- ========================= -->
<div class="modal fade" id="updatePwdModal">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <h4 class="modal-title">비밀번호 변경</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>

            <div class="modal-body">

                <form id="updatePwdFrm" action="/blueming/member/updatePwd" method="post">

                    <input type="hidden" name="loginId"
                           value="${sessionScope.loginUser.loginId}">

                    <table>

                        <tr>
                            <th>현재 비밀번호</th>
                            <td>
                                <input type="password" name="loginPwd" required>
                            </td>
                        </tr>

                        <tr>
                            <th>변경 비밀번호</th>
                            <td>
                                <input type="password" name="updatePwd" required>
                            </td>
                        </tr>

                        <tr>
                            <th>비밀번호 확인</th>
                            <td>
                                <input type="password" name="checkPwd" required>
                            </td>
                        </tr>

                    </table>

                    <br>

                    <div align="center">
                        <button type="button"
                                class="btn btn-secondary btn-sm"
                                onclick="validatePwd();">
                            비밀번호 변경
                        </button>
                    </div>

                </form>

            </div>

        </div>
    </div>
</div>


<!-- ========================= -->
<!-- 비밀번호 검증 + confirm -->
<!-- ========================= -->
<script>

function validatePwd() {

    let updatePwd = $("input[name=updatePwd]").val();
    let checkPwd = $("input[name=checkPwd]").val();

    if(updatePwd != checkPwd) {
        alertify.alert("알림", "비밀번호가 일치하지 않습니다.");
        return false;
    }

    alertify.confirm(
        "비밀번호 변경",
        "정말 비밀번호를 변경하시겠습니까?",
        function() {
            $("#updatePwdFrm").submit();
        },
        function() {
            alertify.error("취소되었습니다.");
        }
    );

    return false;
}

</script>

</body>
</html>