<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 상세조회</title>

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

/* 카드 */
.notice-view{
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

/* 본문 */
.notice-body{
    padding:40px;
}

/* 제목 */
.notice-title{
    font-size:32px;
    font-weight:700;
    color:#333;
    margin-bottom:20px;
}

/* 작성자 정보 */
.notice-info{
    display:flex;
    gap:30px;
    color:#666;
    font-size:14px;
    padding-bottom:25px;
    border-bottom:1px solid #ececec;
}

/* 내용 */
.notice-content{
    min-height:600px;
    padding:35px 0;
    line-height:2;
    color:#444;
    font-size:15px;
    border-bottom:1px solid #ececec;
    white-space:pre-wrap;
}

/* 버튼 */
.notice-footer{
    padding:25px;
    text-align:center;
}

.btn-custom{
    display:inline-block;
    padding:12px 28px;
    border:none;
    border-radius:10px;
    font-size:14px;
    font-weight:600;
    cursor:pointer;
    text-decoration:none;
    transition:.2s;
}

.btn-list{
    background:#6c757d;
    color:white;
}

.btn-list:hover{
    background:#555;
    color:white;
}

.btn-update{
 background:#3b82f6;
    color:white;
}

.btn-update:hover{
       background:#2563eb;

}

/* 삭제하기 */
.btn-delete{
    background:#4fd1c5;
    color:white;
}

.btn-delete:hover{
    background:#38b2ac;
}

/* 반응형 */
@media(max-width:768px){

    .outer{
        margin-left:0;
        width:100%;
        padding:15px;
    }

    .notice-title{
        font-size:24px;
    }

    .notice-info{
        flex-direction:column;
        gap:8px;
    }

}

</style>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

</head>
<body>

<jsp:include page="../common/mainMenubar.jsp"/>

<div class="outer">

    <div class="notice-view">

        <div class="notice-header"></div>

        <div class="notice-body">

            <div class="notice-title">
                ${requestScope.n.noticeTitle}
            </div>

            <div class="notice-info">

                <span>
                    <c:choose>
                        <c:when test="${requestScope.n.memberId == 1}">
                            관리자
                        </c:when>
                        <c:otherwise>
                            ${requestScope.n.memberId}
                        </c:otherwise>
                    </c:choose>
                </span>

                <span>
                    ${requestScope.n.createdDate}
                </span>

            </div>

            <div class="notice-content">
${requestScope.n.content}
            </div>

        </div>

        <div class="notice-footer">

            <a href="/blueming/notice/list"
               class="btn-custom btn-list">
                목록으로
            </a>

            <c:if test="${(not empty sessionScope.loginUser)
                        and (sessionScope.loginUser.memberId eq requestScope.n.memberId)}">

                <button type="button"
                        class="btn-custom btn-update"
                        onclick="postFormSubmit(1)">
                    수정하기
                </button>

                <button type="button"
                        class="btn-custom btn-delete"
                        onclick="postFormSubmit(2)">
                    삭제하기
                </button>

                <form id="postForm" action="" method="post">
                    <input type="hidden"
                           name="nno"
                           value="${requestScope.n.noticeId}">
                </form>

            </c:if>

        </div>

    </div>

</div>

<script>

function postFormSubmit(num){

    if(num == 1){

        $("#postForm")
            .prop("action","/blueming/notice/updateForm")
            .submit();

    }else{

        if(confirm("정말 삭제하시겠습니까?")){

            $("#postForm")
                .prop("action","/blueming/notice/delete")
                .submit();

        }

    }

}

</script>

</body>
</html>