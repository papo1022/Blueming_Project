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
    
    input[type="date"] {
        width : 80%;
    }

</style>
</head>
<body>

    <jsp:include page="../common/mainMenubar.jsp" />

    <h1 align="center">강의 등록</h1>

    <form action="addCourse" align="center" method="post">
        <input type="hidden" name="memberId" value="${sessionScope.loginUser.memberId}"><br>
        <table class="table">
            <tr>
                <td>* 강의명</td>
                <td><input type="text" name="courseTitle" id="courseTitle" required></td>
            </tr>
            <tr>
                <td>* 강의 설명</td>
                <td><textarea name="description" id="description" required></textarea></td>
            </tr>
            <tr>
                <td>* 강의 시작 시간</td>
                <td><input type="date" name="startDate" required></td>
            </tr>
            <tr>
                <td>* 강의 마감 시간</td>
                <td><input type="date" name="endDate" required></td>
            </tr> 
        </table>

        <br><br>
        <div class="buttons" align="center">
            <button type="submit" class="btn btn-primary">등록하기</button>
            <button type="reset" class="btn btn-warning">초기화</button>
        </div>
    </form>
</body>
</html>