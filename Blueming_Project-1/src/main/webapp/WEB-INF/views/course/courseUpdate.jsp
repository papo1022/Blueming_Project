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
    
    input[type="date"] {
        width : 80%;
    }

</style>
</head>
<body>

    <jsp:include page="../common/mainMenubar.jsp" />

    <h1 align="center">강의 수정</h1>
    
    <div class="outer">
        <form action="updateCourse" align="center" method="post" onsubmit="return validateForm();">
            <input type="hidden" name="memberId" value="${sessionScope.loginUser.memberId}">
            <input type="hidden" name="courseId" value="${requestScope.c.courseId}">
            <br>
            <table class="table">
                <tr>
                    <td>* 강의명</td>
                    <td><input type="text" name="courseTitle" id="courseTitle" value="${requestScope.ch.courseTitle}" required></td>
                </tr>
                <tr>
                    <td>* 강의 설명</td>
                    <td><textarea name="description" id="description" required>${requestScope.c.description}</textarea></td>
                </tr>
                <tr>
                    <td>* 강의 시작 시간</td>
                    <td><input type="date" name="startDate" value="${requestScope.c.startDate}" required></td>
                </tr>
                <tr>
                    <td>* 강의 마감 시간</td>
                    <td><input type="date" name="endDate" value="${requestScope.c.endDate}" required></td>
                </tr> 
            </table>

            <br><br>
            <div class="buttons" align="center">
                <button type="submit" class="btn btn-primary">수정하기</button>
                <button type="reset" class="btn btn-warning">초기화</button>
            </div>
        </form>
    </div>
    
    <script>
        function validateForm() {
            const startDate = new Date(document.querySelector('input[name="startDate"]').value);
            const endDate = new Date(document.querySelector('input[name="endDate"]').value);
            
            if (startDate > endDate) {
                alert("강의 시작 날짜는 마감 날짜보다 이전이어야 합니다.");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>