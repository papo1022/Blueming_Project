<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>과제 채점</title>

<style>

body{
    font-family: "맑은 고딕";
    background-color: #f5f7fa;
    margin: 0;
    padding: 30px;
}

.container{
    width: 1000px;
    margin: auto;
}

.page-title{
    font-size: 28px;
    font-weight: bold;
    margin-bottom: 20px;
    color: #333;
}

.card{
    background: white;
    border-radius: 10px;
    padding: 30px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.detail-table{
    width: 100%;
    border-collapse: collapse;
}

.detail-table th{
    width: 180px;
    background: #4A90E2;
    color: white;
    padding: 15px;
    text-align: center;
}

.detail-table td{
    padding: 15px;
    border: 1px solid #e5e5e5;
}

.content-box{
    min-height: 150px;
    white-space: pre-wrap;
    line-height: 1.8;
}

.score-input{
    width: 120px;
    height: 40px;
    text-align: center;
    font-size: 18px;
    border: 1px solid #ccc;
    border-radius: 5px;
}

.button-area{
    margin-top: 30px;
    text-align: center;
}

.btn{
    border: none;
    padding: 12px 30px;
    border-radius: 5px;
    cursor: pointer;
    font-size: 15px;
}

.btn-save{
    background: #4A90E2;
    color: white;
}

.btn-save:hover{
    background: #357ABD;
}

.btn-list{
    display: inline-block;
    background: #6c757d;
    color: white;
    text-decoration: none;
    padding: 12px 30px;
    border-radius: 5px;
    margin-left: 10px;
}

.btn-list:hover{
    background: #555;
}

.score-text{
    color: #E74C3C;
    font-weight: bold;
}

</style>

</head>
<body>

<div class="container">

    <div class="page-title">
        📝 과제 채점
    </div>

    <div class="card">

        <form action="${pageContext.request.contextPath}/adminAssignment/updateScore"
              method="post">

            <input type="hidden"
                   name="submissionId"
                   value="${assignment.submissionId}">

            <table class="detail-table">

                <tr>
                    <th>사번</th>
                    <td>${assignment.memberId}</td>
                </tr>

                <tr>
                    <th>아이디</th>
                    <td>${assignment.loginId}</td>
                </tr>

                <tr>
                    <th>이름</th>
                    <td>${assignment.name}</td>
                </tr>

                <tr>
                    <th>부서</th>
                    <td>
                        <c:choose>
                            <c:when test="${assignment.departmentId eq 'D01'}">인사팀</c:when>
                            <c:when test="${assignment.departmentId eq 'D02'}">개발팀</c:when>
                            <c:when test="${assignment.departmentId eq 'D03'}">디자인팀</c:when>
                            <c:when test="${assignment.departmentId eq 'D04'}">영업팀</c:when>
                            <c:when test="${assignment.departmentId eq 'D05'}">마케팅팀</c:when>
                            <c:when test="${assignment.departmentId eq 'D06'}">운영팀</c:when>
                            <c:when test="${assignment.departmentId eq 'D07'}">품질관리팀</c:when>
                            <c:when test="${assignment.departmentId eq 'D08'}">전략기획팀</c:when>
                            <c:otherwise>부서없음</c:otherwise>
                        </c:choose>
                    </td>
                </tr>

                <tr>
                    <th>직급</th>
                    <td>
                        <c:choose>
                            <c:when test="${assignment.positionId eq 'P01'}">사원</c:when>
                            <c:when test="${assignment.positionId eq 'P02'}">주임</c:when>
                            <c:when test="${assignment.positionId eq 'P03'}">대리</c:when>
                            <c:when test="${assignment.positionId eq 'P04'}">과장</c:when>
                            <c:when test="${assignment.positionId eq 'P05'}">차장</c:when>
                            <c:when test="${assignment.positionId eq 'P06'}">부장</c:when>
                            <c:otherwise>직급없음</c:otherwise>
                        </c:choose>
                    </td>
                </tr>

                <tr>
                    <th>과제명</th>
                    <td>${assignment.assignmentTitle}</td>
                </tr>

                <tr>
                    <th>시작일</th>
                    <td>${assignment.startDate}</td>
                </tr>

                <tr>
                    <th>마감일</th>
                    <td>${assignment.dueDate}</td>
                </tr>

                <tr>
                    <th>과제 설명</th>
                    <td class="content-box">
                        ${assignment.description}
                    </td>
                </tr>

                <tr>
                    <th>제출 내용</th>
                    <td class="content-box">
                        ${assignment.submittedContent}
                    </td>
                </tr>

			    <tr>
				    <th>첨부파일</th>
				
				    <td>
				
				        <c:choose>
				
				            <c:when test="${not empty assignment.submittedFileName}">
				
				                <a href="${pageContext.request.contextPath}/adminAssignment/download?fileId=${assignment.submittedFileId}">
				
				                    📎 ${assignment.submittedFileName}
				
				                </a>
				
				            </c:when>
				
				            <c:otherwise>
				
				                첨부파일 없음
				
				            </c:otherwise>
				
				        </c:choose>
				
				    </td>
			</tr>

                <tr>
                    <th class="score-text">점수</th>
                    <td>

                        <input type="number"
                               class="score-input"
                               name="score"
                               min="0"
                               max="${assignment.maxScore}"
                               value="${assignment.score}">

                        / ${assignment.maxScore} 점

                    </td>
                </tr>

            </table>

            <div class="button-area">

                <button type="submit"
                        class="btn btn-save">
                    채점 완료
                </button>

                <a href="${pageContext.request.contextPath}/adminAssignment/list"
                   class="btn-list">
                    목록으로
                </a>

            </div>

        </form>

    </div>

</div>

</body>
</html>