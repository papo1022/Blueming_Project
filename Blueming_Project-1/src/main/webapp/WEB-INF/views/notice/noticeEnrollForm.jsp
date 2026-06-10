<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 작성</title>

<style>
body {
    margin: 0;
    font-family: "맑은 고딕", sans-serif;
    background: #eef3fb;
}

/* 전체 영역 */
.outer {
    width: 1100px;
    margin: 80px auto;
}

/* 카드 박스 */
.card {
    background: #fff;
    border-radius: 14px;
    padding: 50px 60px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.10);
}

/* textarea */
textarea {
    width: 100%;
    height: 320px;
    padding: 14px;
    border: 1px solid #d6dce5;
    border-radius: 8px;
    resize: none;
    box-sizing: border-box; /* 패딩이 크기에 영향을 주지 않도록 추가 */
}
/* 제목 */
h2 {
    text-align: center;
    color: #2f5fd6;
    margin-bottom: 25px;
}

/* 테이블 */
.table {
    width: 100%;
    border-collapse: collapse;
}

.table th {
    width: 120px;
    text-align: left;
    padding: 12px;
    color: #333;
    font-weight: bold;
    vertical-align: top;
}

.table td {
    padding: 12px;
}

/* input */
input[type="text"] {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid #d6dce5;
    border-radius: 8px;
    outline: none;
    transition: 0.2s;
    box-sizing: border-box;
}

input[type="text"]:focus {
    border-color: #2f5fd6;
    box-shadow: 0 0 0 3px rgba(47,95,214,0.15);
}

textarea:focus {
    border-color: #2f5fd6;
    box-shadow: 0 0 0 3px rgba(47,95,214,0.15);
}

/* ✨ 글자 수 카운트 카운터 스타일 추가 */
.counter-text {
    text-align: right;
    color: #888;
    font-size: 12px;
    margin-top: 4px;
    user-select: none;
}

/* 버튼 영역 */
.btn-area {
    text-align: center;
    margin-top: 25px;
}

/* 버튼 */
button {
    border: none;
    padding: 8px 16px;
    margin: 0 5px;
    border-radius: 6px;
    font-size: 13px;
    cursor: pointer;
    transition: 0.2s;
}

/* 등록 */
.btn-primary {
    background: #2f5fd6;
    color: white;
}
.btn-primary:hover {
    background: #244bb0;
}

/* 기본 */
.btn-secondary {
    background: #e4e8f0;
    color: #333;
}
.btn-secondary:hover {
    background: #d2d8e5;
}
</style>

</head>
<body>

<jsp:include page="../common/mainMenubar.jsp" />

<div class="outer">

    <div class="card">

        <h2>공지사항 작성</h2>

        <form id="enroll-form" action="/blueming/notice/insert" method="post">

            <input type="hidden" name="memberId" 
                   value="${ sessionScope.loginUser.memberId }">

            <table class="table">
                <tr>
                    <th>제목</th>
                    <td>
                        <input type="text" id="notice-title" name="noticeTitle" placeholder="제목을 입력하세요" maxlength="15" required>
                        <div class="counter-text"><span id="title-curr">0</span> / 15자</div>
                    </td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td>
                        <textarea id="notice-content" name="content" placeholder="내용을 입력하세요" maxlength="400" required></textarea>
                        <div class="counter-text"><span id="content-curr">0</span> / 400자</div>
                    </td>
                </tr>
            </table>

            <div class="btn-area">
                <button type="submit" class="btn-primary">등록하기</button>
                <button type="reset" class="btn-secondary">초기화</button>
                <button type="button" class="btn-secondary" onclick="history.back();">뒤로가기</button>
            </div>

        </form>

    </div>

</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    // 각각의 입력창과 스팬 태그 셀렉트
    const titleInput = document.getElementById("notice-title");
    const titleCurr = document.getElementById("title-curr");
    
    const contentInput = document.getElementById("notice-content");
    const contentCurr = document.getElementById("content-curr");

    // 공통 카운터 바인딩 함수 (입력창 객체, 변경될 카운터 스팬 객체, 최대길이)
    function bindCounter(inputEl, counterEl, maxLength) {
        inputEl.addEventListener("input", function() {
            const currentLength = inputEl.value.length;
            counterEl.textContent = currentLength;

            // 글자 수가 꽉 차면 직관적인 빨간색 포인트 경고 효과 제공
            if (currentLength >= maxLength) {
                counterEl.style.color = "#E74C3C";
                counterEl.style.fontWeight = "bold";
            } else {
                counterEl.style.color = "#888";
                counterEl.style.fontWeight = "normal";
            }
        });
    }

    // 각각의 요소에 실시간 카운터 기능 작동 정의
    bindCounter(titleInput, titleCurr, 15);
    bindCounter(contentInput, contentCurr, 400);

    // [추가] 초기화 버튼 클릭 시 글자 수 표기 숫자가 0으로 자동 리셋되도록 조치
    document.getElementById("enroll-form").addEventListener("reset", function() {
        setTimeout(function() {
            titleCurr.textContent = 0;
            titleCurr.style.color = "#888";
            titleCurr.style.fontWeight = "normal";
            
            contentCurr.textContent = 0;
            contentCurr.style.color = "#888";
            contentCurr.style.fontWeight = "normal";
        }, 10); // reset 이벤트가 완료된 스택 직후 실행하기 위해 미세 딜레이 삽입
    });
});
</script>

</body>
</html>