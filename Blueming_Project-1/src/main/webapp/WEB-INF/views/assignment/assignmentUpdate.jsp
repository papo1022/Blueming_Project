<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>blueming</title>
<style>
    .outer {
        width: 90%;
        margin: 0 auto;
    }

    #assignmentTitle,
    #description,
    #startDate,
    #dueDate,
    #maxScore {
        width: 80%;
    }

    #description {
        height: 220px;
        resize: none;
    }
</style>
</head>
<body>

    <jsp:include page="../common/mainMenubar.jsp" />

    <br><br>
    <h1 align="center">과제 수정</h1>
    <br><br>

    <div class="outer">
        <form id="assignmentForm" action="/blueming/assignment/update" method="post" align="center">
            <input type="hidden" name="assignmentId" value="${assignment.assignmentId}">
            <input type="hidden" name="chapterId" value="${chapter.chapterId}">
            <table class="table">
                <tr>
                    <td>챕터명</td>
                    <td>${chapter.chapterTitle}</td>
                </tr>
                <tr>
                    <td>* 과제명</td>
                    <td><input type="text" id="assignmentTitle" name="assignmentTitle" value="${assignment.assignmentTitle}" required></td>
                </tr>
                <tr>
                    <td>과제 설명</td>
                    <td><textarea id="description" name="description">${assignment.description}</textarea></td>
                </tr>
                <tr>
                    <td>* 시작일</td>
                    <td><input type="date" id="startDate" name="startDate" value="${assignment.startDate}" required></td>
                </tr>
                <tr>
                    <td>* 마감일</td>
                    <td><input type="date" id="dueDate" name="dueDate" value="${assignment.dueDate}" required></td>
                </tr>
                <tr>
                    <td>* 만점</td>
                    <td><input type="number" id="maxScore" name="maxScore" min="0" value="${assignment.maxScore}" required></td>
                </tr>
            </table>
            <br><br>
            <div align="center">
                <button type="button" class="btn btn-primary" onclick="submitAssignmentForm();">확인</button>
                <button type="button" class="btn btn-secondary" onclick="cancelAssignmentForm();">취소</button>
            </div>
        </form>
    </div>

    <script>
        function submitAssignmentForm() {
            if (confirm("과제를 수정하시겠습니까?")) {
                document.getElementById("assignmentForm").submit();
            }
        }

        function cancelAssignmentForm() {
            if (confirm("작업을 취소하고 이전 페이지로 돌아가시겠습니까?")) {
                location.href = "/blueming/course/chapterDetailView?chapterId=${chapter.chapterId}";
            }
        }
    </script>
</body>
</html>