<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>blueming</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/assignment/assignmentForm.css">
</head>
<body>

    <jsp:include page="../common/mainMenubar.jsp" />

    <br><br>
    <h1 align="center">과제 수정</h1>
    <br><br>

    <div class="outer">
        <form id="assignmentForm" action="/blueming/assignment/update" method="post" align="center" novalidate>
            <input type="hidden" name="assignmentId" value="${assignment.assignmentId}">
            <input type="hidden" name="chapterId" value="${chapter.chapterId}">
            <table class="table">
                <tr>
                    <td>챕터명</td>
                    <td>${chapter.chapterTitle}</td>
                </tr>
                <tr>
                    <td>* 과제명</td>
                    <td>
                        <input type="text" id="assignmentTitle" name="assignmentTitle" value="${assignment.assignmentTitle}" maxlength="90">
                        <div class="field-error" id="assignmentTitleError"></div>
                    </td>
                </tr>
                <tr>
                    <td>과제 설명</td>
                    <td><textarea id="description" name="description" maxlength="2000">${assignment.description}</textarea></td>
                </tr>
                <tr>
                    <td>* 시작일</td>
                    <td>
                        <input type="date" id="startDate" name="startDate" value="${assignment.startDate}">
                        <div class="field-error" id="startDateError"></div>
                    </td>
                </tr>
                <tr>
                    <td>* 마감일</td>
                    <td>
                        <input type="date" id="dueDate" name="dueDate" value="${assignment.dueDate}">
                        <div class="field-error" id="dueDateError"></div>
                    </td>
                </tr>
                <tr>
                    <td>* 만점</td>
                    <td>
                        <input type="number" id="maxScore" name="maxScore" min="1" value="${assignment.maxScore}">
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

        function clearFieldError(fieldId) {
            setFieldError(fieldId, "");
        }

        function validateAssignmentForm() {
            const titleField = document.getElementById("assignmentTitle");
            const startDateField = document.getElementById("startDate");
            const dueDateField = document.getElementById("dueDate");
            const maxScoreField = document.getElementById("maxScore");
            let firstInvalidField = null;

            ["assignmentTitle", "startDate", "dueDate", "maxScore"].forEach(clearFieldError);

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
            const form = document.getElementById("assignmentForm");
            if (!form) {
                return;
            }

            const firstInvalidField = validateAssignmentForm();
            if (firstInvalidField) {
                firstInvalidField.focus();
                return;
            }

            if (confirm("과제를 수정하시겠습니까?")) {
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

        ["assignmentTitle", "startDate", "dueDate", "maxScore"].forEach(function(fieldId) {
            const field = document.getElementById(fieldId);
            if (!field) {
                return;
            }

            field.addEventListener("input", function() {
                validateAssignmentForm();
            });

            field.addEventListener("change", function() {
                validateAssignmentForm();
            });
        });
    </script>
</body>
</html>