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

    #targetType, #targetValue {
        width : 80%;
    }

</style>
</head>
<body>

    <jsp:include page="../common/mainMenubar.jsp" />

    <h1 align="center">강의 등록</h1>

    <form action="addCourse" align="center" method="post" onsubmit="return validateForm();">
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
            <tr>
                <td>* 강좌 대상 유형</td>
                <td>
                    <select id="targetType" name="targetType" onchange="toggleTargetValue();">
                        <option value="전체" selected>전체</option>
                        <option value="부서">부서</option>
                        <option value="직급">직급</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>대상 값</td>
                <td>
                    <input type="text" id="targetValue" name="targetValue" placeholder="예: D02 또는 P03" disabled>
                </td>
            </tr>
        </table>

        <br><br>
        <div class="buttons" align="center">
            <button type="submit" class="btn btn-primary">등록하기</button>
            <button type="reset" class="btn btn-warning">초기화</button>
        </div>
    </form>

    <script>
        function validateForm() {
            const startDate = new Date(document.querySelector('input[name="startDate"]').value);
            const endDate = new Date(document.querySelector('input[name="endDate"]').value);
            const targetType = document.getElementById("targetType").value;
            const targetValue = document.getElementById("targetValue").value.trim();
            
            if (startDate > endDate) {
                alert("강의 시작 날짜는 마감 날짜보다 이전이어야 합니다.");
                return false;
            }

            if ((targetType === "부서" || targetType === "직급") && targetValue === "") {
                alert("대상 값(부서/직급 코드)을 입력해주세요.");
                return false;
            }
            return true;
        }

        function toggleTargetValue() {
            const targetType = document.getElementById("targetType").value;
            const targetValue = document.getElementById("targetValue");
            if (targetType === "전체") {
                targetValue.value = "";
                targetValue.disabled = true;
            } else {
                targetValue.disabled = false;
            }
        }

        toggleTargetValue();
    </script>
</body>
</html>