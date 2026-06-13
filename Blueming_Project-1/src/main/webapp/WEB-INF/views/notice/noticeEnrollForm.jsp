<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 작성</title>

<style>
body{
    background:#f5f7fb;
    margin:0;
    padding:0;
    font-family:"맑은 고딕", sans-serif;
}

.outer{
    margin-left:250px;
    width:calc(100vw - 250px);
    min-height:100vh;
    padding:30px;
    box-sizing:border-box;
}

/* 제목 */
.page-title{
    text-align:center;
    font-size:30px;
    font-weight:700;
    color:#2d3748;
    margin-bottom:25px;
}

/* 카드 */
.notice-card{
    background:white;
    border-radius:20px;
    overflow:hidden;
    box-shadow:0 4px 20px rgba(0,0,0,.08);
}

/* 상단 민트바 */
.notice-header{
    height:32px;
    background:#4fd1c5;
}

/* 폼 */
#enroll-form{
    padding:35px;
}

#enroll-form table{
    width:100%;
    border-collapse:collapse;
}

#enroll-form th{
    width:120px;
    padding:15px;
    border:1px solid #eef2f7;
    background:#fafbfc;
    color:#4a5568;
    font-weight:600;
}

#enroll-form td{
    padding:15px;
    border:1px solid #eef2f7;
}

/* 입력창 */
#enroll-form input[type=text]{
    width:100%;
    height:50px;
    border:none;
    outline:none;
    background:white;
    color:#000;
    font-size:18px;
    font-weight:600;
    padding:0 10px;
    box-sizing:border-box;
}

#enroll-form textarea{
    width:100%;
    min-height:600px;
    border:none;
    outline:none;
    background:white;
    color:#000;
    font-size:15px;
    line-height:1.8;
    padding:15px 10px;
    resize:none;
    box-sizing:border-box;
}

#enroll-form input:focus,
#enroll-form textarea:focus{
    border:none;
    outline:none;
}

/* 글자수 카운터 */
.counter-text{
    text-align:right;
    margin-top:8px;
    color:#94a3b8;
    font-size:13px;
}

/* 버튼 영역 */
.button-area{
    margin-top:30px;
    text-align:center;
}

/* 버튼 */
.btn-custom{
    border:none;
    padding:12px 28px;
    border-radius:10px;
    cursor:pointer;
    font-size:14px;
    font-weight:600;
    transition:.2s;
    margin:0 4px;
}

/* 등록 */
.btn-insert{
    background:#3b82f6;
    color:white;
}

.btn-insert:hover{
    background:#2563eb;
}

/* 초기화 */
.btn-reset{
    background:#64748b;
    color:white;
}

.btn-reset:hover{
    background:#475569;
}
/* 뒤로가기 */
.btn-back{
    background:#4fd1c5;
    color:white;
}

.btn-back:hover{
    background:#38b2ac;
}
</style>

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