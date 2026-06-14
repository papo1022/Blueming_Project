<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 상세조회</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/notice/noticeFormShared.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/notice/noticeDetailView.css">

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