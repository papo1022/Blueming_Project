<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
#update-form{
    padding:35px;
}

#update-form table{
    width:100%;
    border-collapse:collapse;
}


#update-form td{
    padding:15px;
    border:1px solid #eef2f7;
}

/* 입력창 */
#update-form input[type=text]{
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

#update-form textarea{
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

#update-form input:focus,
#update-form textarea:focus{
    border:none;
    outline:none;
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
}

/* 수정하기 (파랑) */
.btn-update{
    background:#3b82f6;
    color:white;
}

.btn-update:hover{
    background:#2563eb;
}

/* 뒤로가기 (민트) */
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
         공지사항 수정
    </div>

    <div class="notice-card">

        <div class="notice-header"></div>

        <form id="update-form"
              action="/blueming/notice/update"
              method="post">

            <input type="hidden"
                   name="noticeId"
                   value="${requestScope.n.noticeId}">

            <table>

                <tr>
                    <th>제목</th>
                    <td>
                        <input type="text"
                               name="noticeTitle"
                               value="${requestScope.n.noticeTitle}"
                               required>
                    </td>
                </tr>

                <tr>
                    <th>내용</th>
                    <td>
                        <textarea name="content"
                                  required>${requestScope.n.content}</textarea>
                    </td>
                </tr>

            </table>

            <div class="button-area">

                <button type="submit"
                        class="btn-custom btn-update">
                    수정하기
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
	
	<br><br>

</body>
</html>






