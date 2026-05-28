<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
    #courseTitle {
        width : 80%;
        margin : 10px;
    }

    #description {
        width : 80%;
        height : 300px;
        resize : none;
    }
</style>
</head>
<body>

    <jsp:include page="../common/menubar.jsp" />

    <br><br>
    <h1 align="center">챕터 추가</h1>
    <br><br>

    <div class="outer" id="detail-area">
        <form action="addChapter" align="center" method="post">
        <input type="hidden" name="chapterId" value="${requestScope.chapter.chapterId}">
        <table class="table">
            <tr>
                <td>* 챕터명 </td>
                <td><input type="text" name="chapterTitle" id="chapterTitle" required></td>
            </tr>
            <tr>
                <td>동영상 첨부파일</td>
                <td><input type="file" accept="video/*"></td>
            </tr>
        </table>
        <br><br>
        <div class="buttons" align="center">
            <button type="submit" class="btn btn-primary">등록하기</button>
            <button type="reset" class="btn btn-warning">초기화</button>
        </div>
    </form>
    </div>

    
</body>
</html>