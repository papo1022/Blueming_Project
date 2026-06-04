<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
    .outer {
        width : 90%;
        margin : 0 auto;
    }

    #courseTitle {
        width : 80%;
        margin : 10px;
    }

    #description {
        width : 80%;
        height : 300px;
        resize : none;
    }

    #chapterTitle{
        width : 80%;
    }
</style>
</head>
<body>

    <jsp:include page="../common/mainMenubar.jsp" />

    <br><br>
    <h1 align="center">챕터 수정</h1>
    <br><br>

    <div class="outer" id="detail-area">
        <form action="updateChapter" align="center" method="post" enctype="multipart/form-data">
            <input type="hidden" name="memberId" value="${sessionScope.loginUser.memberId}"><br>
            <input type="hidden" name="courseId" value="${courseId}">
            <input type="hidden" name="chapterId" value="${chapter.chapterId}">
            <table class="table">
                <tr>
                    <td>챕터 번호</td>
                    <td><input type="number" name="chapterOrder" value="${chapter.chapterOrder}" required readonly ></td>
                </tr>
                <tr>
                    <td>* 챕터명 </td>
                    <td><input type="text" name="chapterTitle" id="chapterTitle" value="${chapter.chapterTitle}" required></td>
                </tr>
                <tr>
                    <td>동영상 첨부파일</td>
                    <td><input type="file" accept="video/*" name="video" value="${chapter.videoFileId}"></td>
                </tr>
            </table>
            <br><br> 
            <div class="buttons" align="center">
                <button type="submit" class="btn btn-primary">수정하기</button>
                <button type="reset" class="btn btn-warning">초기화</button>
            </div>
        </form>
    </div>

    
</body>
</html>