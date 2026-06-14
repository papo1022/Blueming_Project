<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/notice/noticeFormShared.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/notice/noticeUpdateForm.css">
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
                               maxlength="50"
                               required>
                    </td>
                </tr>

                <tr>
                    <th>내용</th>
                    <td>
                        <textarea name="content"
                                  maxlength="2000"
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






