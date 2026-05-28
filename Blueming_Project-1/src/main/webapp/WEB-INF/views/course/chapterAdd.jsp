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

    <h1>챕터 추가</h1>

    <form action="addChapter" align="center" method="post">
        <input type="hidden" name="chapterId" value="${requestScope.chapter.chapterId}"><br>
        * 챕터명 <input type="text" name="chapterTitle" id="chapterTitle" required><br>
        동영상 첨부파일 <input type="file" accept="video/*">
        


        <br><br>
        <div class="buttons" align="center">
            <button type="submit" class="btn btn-primary">등록하기</button>
            <button type="reset" class="btn btn-warning">초기화</button>
        </div>
    </form>
</body>
</html>