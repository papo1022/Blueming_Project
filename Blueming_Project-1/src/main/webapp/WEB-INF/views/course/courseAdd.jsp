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

    <h1>강의 등록</h1>

    <form action="addCourse" align="center" method="post">
        <!--<input type="hidden" name="memberId" value="${sessionScope.loginUser.memberId}"><br>-->
        <input type="hidden" name="memberId" value="1"><br>
        * 강의명 <input type="text" name="courseTitle" id="courseTitle" required><br>
        * 강의 설명 <textarea name="description" id="description" required></textarea><br>
        * 강의 시작 시간 <input type="date" name="startDate" required><br>
        * 강의 마감 시간 <input type="date" name="endDate" required><br>


        <br><br>
        <div class="buttons" align="center">
            <button type="submit" class="btn btn-primary">등록하기</button>
            <button type="reset" class="btn btn-warning">초기화</button>
        </div>
    </form>
</body>
</html>