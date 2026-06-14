<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 작성</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/notice/noticeFormShared.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/notice/noticeEnrollForm.css">

</head>
<body>

<jsp:include page="../common/mainMenubar.jsp" />

<div class="outer">

    <div class="page-title">
        공지사항 작성
    </div>

    <div class="notice-card">

        <div class="notice-header"></div>

        <form id="enroll-form"
              action="/blueming/notice/insert"
              method="post">

            <input type="hidden"
                   name="memberId"
                   value="${sessionScope.loginUser.memberId}">

            <table>

                <tr>
                    <th>제목</th>
                    <td>

                        <input type="text"
                               id="notice-title"
                               name="noticeTitle"
                               maxlength="15"
                               placeholder="제목을 입력하세요"
                               required>

                        <div class="counter-text">
                            <span id="title-curr">0</span> / 15자
                        </div>

                    </td>
                </tr>

                <tr>
                    <th>내용</th>
                    <td>

                        <textarea id="notice-content"
                                  name="content"
                                  maxlength="400"
                                  placeholder="내용을 입력하세요"
                                  required></textarea>

                        <div class="counter-text">
                            <span id="content-curr">0</span> / 400자
                        </div>

                    </td>
                </tr>

            </table>

            <div class="button-area">

                <button type="submit"
                        class="btn-custom btn-insert">
                    등록하기
                </button>

                <button type="reset"
                        class="btn-custom btn-reset">
                    초기화
                </button>

                <button type="button"
                        class="btn-custom btn-back"
                        onclick="history.back();">
                    뒤로가기
                </button>

            </div>

        </form>

    </div>

</div>

<script>
document.addEventListener("DOMContentLoaded", function(){

    const titleInput = document.getElementById("notice-title");
    const titleCurr = document.getElementById("title-curr");

    const contentInput = document.getElementById("notice-content");
    const contentCurr = document.getElementById("content-curr");

    function bindCounter(inputEl, counterEl, maxLength){

        inputEl.addEventListener("input", function(){

            const currentLength = inputEl.value.length;

            counterEl.textContent = currentLength;

            if(currentLength >= maxLength){
                counterEl.style.color = "#ef4444";
                counterEl.style.fontWeight = "700";
            }else{
                counterEl.style.color = "#94a3b8";
                counterEl.style.fontWeight = "400";
            }
        });
    }

    bindCounter(titleInput, titleCurr, 15);
    bindCounter(contentInput, contentCurr, 400);

    document.getElementById("enroll-form")
    .addEventListener("reset", function(){

        setTimeout(function(){

            titleCurr.textContent = "0";
            contentCurr.textContent = "0";

            titleCurr.style.color = "#94a3b8";
            contentCurr.style.color = "#94a3b8";

            titleCurr.style.fontWeight = "400";
            contentCurr.style.fontWeight = "400";

        },10);

    });

});
</script>

</body>
</html>