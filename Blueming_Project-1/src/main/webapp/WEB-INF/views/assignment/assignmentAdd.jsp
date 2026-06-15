<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>blueming</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/assignment/assignmentForm.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/courseStyle.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/courseForm.css">
    </head>

    <body>

        <jsp:include page="../common/mainMenubar.jsp" />

        <div class="outer">
            <form id="content-card" action="/blueming/assignment/add" method="post" align="center" novalidate>
                <input type="hidden" name="chapterId" value="${chapter.chapterId}">
                <h1 class="page-title">과제 추가</h1>
                <br>
                <table class="table" id="detail-area">
                    <tr>
                        <td>챕터명</td>
                        <td>${chapter.chapterTitle}</td>
                    </tr>
                    <tr>
                        <td>* 과제명</td>
                        <td>
                            <input type="text" id="assignmentTitle" name="assignmentTitle" maxlength="30">
                            <div class="field-error" id="assignmentTitleError"></div>
                        </td>
                    </tr>
                    <tr>
                        <td>과제 설명</td>
                        <td><textarea id="description" name="description" maxlength="2000"></textarea></td>
                    </tr>
                    <tr>
                        <td>* 과제 제한 시간</td>
                        <td><input type="date" name="startDate" id="startDate"
                                required>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>~</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input
                                type="date" name="dueDate" id="dueDate" required></td>
                    </tr>
                    <tr>
                        <td>* 만점</td>
                        <td>
                            <input type="number" id="maxScore" name="maxScore" min="1">
                            <div class="field-error" id="maxScoreError"></div>
                        </td>
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
            function setFieldError(fieldId, message) {
                const field = document.getElementById(fieldId);
                const errorBox = document.getElementById(fieldId + "Error");

                if (field) {
                    field.classList.toggle("is-invalid", !!message);
                }

                if (errorBox) {
                    errorBox.textContent = message || "";
                }
            }

            function validateAssignmentForm() {
                const titleField = document.getElementById("assignmentTitle");
                const startDateField = document.getElementById("startDate");
                const dueDateField = document.getElementById("dueDate");
                const maxScoreField = document.getElementById("maxScore");
                let firstInvalidField = null;

                setFieldError("assignmentTitle", "");
                setFieldError("startDate", "");
                setFieldError("dueDate", "");
                setFieldError("maxScore", "");

                if (!titleField.value.trim()) {
                    setFieldError("assignmentTitle", "과제명을 입력해주세요.");
                    firstInvalidField = firstInvalidField || titleField;
                }

                if (!startDateField.value) {
                    setFieldError("startDate", "시작일을 입력해주세요.");
                    firstInvalidField = firstInvalidField || startDateField;
                }

                if (!dueDateField.value) {
                    setFieldError("dueDate", "마감일을 입력해주세요.");
                    firstInvalidField = firstInvalidField || dueDateField;
                }

                if (!maxScoreField.value.trim()) {
                    setFieldError("maxScore", "만점을 입력해주세요.");
                    firstInvalidField = firstInvalidField || maxScoreField;
                } else if (Number(maxScoreField.value) < 1) {
                    setFieldError("maxScore", "만점은 1 이상 입력해주세요.");
                    firstInvalidField = firstInvalidField || maxScoreField;
                }

                if (startDateField.value && dueDateField.value && dueDateField.value < startDateField.value) {
                    setFieldError("dueDate", "마감일은 시작일보다 빠를 수 없습니다.");
                    firstInvalidField = firstInvalidField || dueDateField;
                }

                return firstInvalidField;
            }

            function submitAssignmentForm() {
                const form = document.getElementById("content-card");
                if (!form) {
                    return;
                }

                const firstInvalidField = validateAssignmentForm();
                if (firstInvalidField) {
                    firstInvalidField.focus();
                    return;
                }

                if (confirm("과제를 등록하시겠습니까?")) {
                    if (form.requestSubmit) {
                        form.requestSubmit();
                    } else {
                        form.submit();
                    }
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