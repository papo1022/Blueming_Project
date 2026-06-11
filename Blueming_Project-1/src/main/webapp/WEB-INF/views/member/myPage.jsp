<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

<style>
body {
    background: #f5f7fb;
    margin: 0;
    font-family: "맑은 고딕", sans-serif;
}

/* 메인 영역 위치 조정 */
.outer {
    margin-left: 270px; 
    padding-top: 100px; 
    padding-bottom: 60px;
    padding-right: 40px;
}

/* 프로필 카드 박스 크기 슬림화 */
.mypage-container {
    width: 100%;
    max-width: 900px; 
    margin: 0;
}

/* 프로필 카드 메인 */
.profile-card {
    background: #fff;
    border-radius: 24px;
    overflow: hidden;
    box-shadow: 0 4px 25px rgba(0,0,0,.03);
    min-height: 650px; 
    border: 1px solid #e2e8f0;
    position: relative;
}

/* 상단 디자인 헤더 밴드 */
.profile-header {
    height: 150px;
    background: linear-gradient(90deg, #e6f7f4, #f0f4ff);
    width: 100%;
}

/* 프로필 이미지 & 이름 배치 */
.profile-top {
    display: flex;
    align-items: center;
    gap: 30px;
    padding: 0 60px;
    margin-top: -60px;
    position: relative;
    z-index: 10;
}

/* 프로필 이미지 원형 컴포넌트 */
.profile-image-wrap {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    background: #fff;
    box-shadow: 0 4px 15px rgba(0,0,0,0.08);
    flex-shrink: 0; 
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
    border: 4px solid #fff;
}

.profile-image-default {
    font-size: 50px;
    line-height: 120px;
    text-align: center;
}

/* 이름 & 이메일 상단 출력 */
.profile-info {
    display: flex;
    flex-direction: column;
    margin-top: 50px;
}

.profile-info h2 {
    margin: 0 0 6px 0;
    font-size: 26px;
    font-weight: 700;
    color: #1e293b;
}

.profile-info span {
    color: #64748b;
    font-size: 14px;
}

/* 그리드 레이아웃 */
.info-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    row-gap: 50px;
    column-gap: 10%; 
    padding: 50px 60px 40px;
}

.info-item {
    display: flex;
    flex-direction: column;
}

/* 주소 단독 열 배치 */
.info-item.full-width {
    grid-column: 1 / 3;
}

/* 라벨 제목 */
.info-item .label-title {
    font-size: 14px;
    font-weight: 700;
    color: #0f172a;
    margin-bottom: 10px;
}

/* ★ 타이핑이 정상적으로 가능하도록 인풋 스타일 전면 수정 ★ */
.info-item input.view-input {
    font-size: 15px;
    color: #334155;
    font-weight: 500;
    border: none;
    border-bottom: 1.5px solid #e2e8f0; /* 투명한 대신 세련된 밑줄을 주어 입력칸임을 표시 */
    background: #fff;
    padding: 8px 4px;
    outline: none;
    transition: border-color 0.2s;
}

/* 입력창을 클릭(포커스)했을 때 세련된 민트색 밑줄로 변경되게 설정 */
.info-item input.view-input:focus {
    border-bottom-color: #4fd1c5;
    color: #000;
}

/* 아이디는 읽기전용(readonly)이므로 약간 흐리게 처리하고 마우스 클릭 제한 */
.info-item input.view-input[readonly] {
    background: #f8fafc;
    border-bottom-style: dashed;
    color: #94a3b8;
}

/* 하단 버튼 영역 */
.button-area {
    text-align: center;
    padding: 20px 0 50px;
}

.btn-save {
    background: #3b82f6;
    color: white;
    border: none;
    padding: 12px 30px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 600;
    margin-right: 14px;
    transition: background 0.2s;
}

.btn-save:hover {
    background: #2563eb;
    cursor: pointer;
}

.btn-password {
    background: #4fd1c5;
    color: white;
    border: none;
    padding: 12px 30px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 600;
    transition: background 0.2s;
}

.btn-password:hover {
    background: #38b2ac;
    cursor: pointer;
}

/* 모달 내부 테이블 디자인 */
.modal-table {
    width: 100%;
}
.modal-table th {
    width: 35%;
    padding: 12px 5px;
    font-size: 14px;
    color: #475569;
    text-align: left;
}
.modal-table td {
    padding: 8px 0;
}
.modal-table input {
    width: 100%;
    height: 40px;
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    padding: 0 12px;
    font-size: 14px;
    transition: border-color 0.2s;
}
.modal-table input:focus {
    outline: none;
    border-color: #4fd1c5;
}
</style>
</head>
<body>

<div class="outer">

    <jsp:include page="../common/mainMenubar.jsp" />

    <div class="mypage-container">
        <div class="profile-card">
            
            <div class="profile-header"></div>

            <form id="mypage-form" action="/blueming/member/update" method="post">

                <div class="profile-top">
                    <div class="profile-image-wrap">
                        <span class="profile-image-default">👤</span>
                    </div>
                    <div class="profile-info">
                        <h2>${sessionScope.loginUser.name}</h2>
                        <span>${sessionScope.loginUser.email}</span>
                    </div>
                </div>

                <div class="info-grid">

                    <div class="info-item">
                        <span class="label-title">아이디</span>
                        <input type="text" name="loginId" readonly class="view-input"
                               maxlength="20"
                               value="${sessionScope.loginUser.loginId}">
                    </div>

                    <div class="info-item">
                        <span class="label-title">이름</span>
                        <input type="text" name="name" class="view-input"
                               maxlength="100"
                               value="${sessionScope.loginUser.name}">
                    </div>

                    <div class="info-item">
                        <span class="label-title">전화번호</span>
                        <input type="text" name="phone" class="view-input"
                               maxlength="13"
                               value="${sessionScope.loginUser.phone}">
                    </div>

                    <div class="info-item">
                        <span class="label-title">이메일</span>
                        <input type="email" name="email" class="view-input"
                               maxlength="100"
                               value="${sessionScope.loginUser.email}">
                    </div>

                    <div class="info-item full-width">
                        <span class="label-title">주소</span>
                        <input type="text" name="address" class="view-input"
                               maxlength="255"
                               value="${sessionScope.loginUser.address}">
                    </div>

                </div>

                <div class="button-area">
                    <button type="button"
                            class="btn-save"
                            data-toggle="modal"
                            data-target="#updateInfoModal">
                        정보변경
                    </button>

                    <button type="button"
                            class="btn-password"
                            data-toggle="modal"
                            data-target="#updatePwdModal">
                        비밀번호변경
                    </button>
                </div>

            </form>

        </div>
    </div>

</div>

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
                <button type="button" class="btn btn-primary" onclick="submitInfo();">
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


<div class="modal fade" id="updatePwdModal">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">비밀번호 변경</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>

            <div class="modal-body">

                <form id="updatePwdFrm" action="/blueming/member/updatePwd" method="post">

                    <input type="hidden" name="loginId" value="${sessionScope.loginUser.loginId}">

                    <table class="modal-table">
                        <tr>
                            <th>현재 비밀번호</th>
                            <td>
                                <input type="password" name="loginPwd" maxlength="20" required>
                            </td>
                        </tr>
                        <tr>
                            <th>변경 비밀번호</th>
                            <td>
                                <input type="password" name="updatePwd" maxlength="20" required>
                            </td>
                        </tr>
                        <tr>
                            <th>비밀번호 확인</th>
                            <td>
                                <input type="password" name="checkPwd" maxlength="20" required>
                            </td>
                        </tr>
                    </table>

                    <br>

                    <div align="center">
                        <button type="button" class="btn btn-info btn-sm px-4" onclick="validatePwd();">
                            비밀번호 변경
                        </button>
                    </div>

                </form>

            </div>

        </div>
    </div>
</div>


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