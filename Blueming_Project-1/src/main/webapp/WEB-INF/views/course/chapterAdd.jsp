<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Insert title here</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/courseStyle.css">
    </head>

    <body>

        <jsp:include page="../common/mainMenubar.jsp" />

        <div class="outer">
            <form id="content-card" action="addChapter" align="center" method="post" enctype="multipart/form-data">
                <h1 class="page-title">챕터 추가</h1>

                <input type="hidden" name="memberId" value="${sessionScope.loginUser.memberId}"><br>
                <input type="hidden" name="courseId" value="${courseId}">
                <table class="table">
                    <tr>
                        <td>챕터 번호</td>
                        <td><input type="number" name="chapterOrder" value="${nextOrder}" required readonly></td>
                    </tr>
                    <tr>
                        <td>* 챕터명 </td>
                        <td><input type="text" name="chapterTitle" id="chapterTitle" maxlength="30" required></td>
                    </tr>
                    <tr>
                        <td>동영상 첨부파일</td>
                        <td><input type="file" accept="video/*" name="video"></td>
                    </tr>
                </table>
                <br><br>
                <div class="buttons" align="center">
                    <button type="submit" class="btn btn-primary">등록하기</button>
                    <button type="reset" class="btn btn-warning">초기화</button>
                    <a href="${pageContext.request.contextPath}/course/detail?courseId=${courseId}"
                        class="btn btn-secondary">
                        목록으로
                    </a>
                </div>
            </form>
        </div>


    </body>

    </html>