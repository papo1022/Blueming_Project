<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard/memberDashboard.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/mainMenubar.css">
<head>
<meta charset="UTF-8">
<title>과제 채점</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/assignment/assignmentDetail.css">

</head>
<body>

<div class="container">

    <div class="page-title">
        <i class="fi fi-sr-document"></i> 과제 채점
    </div>

    <div class="card">

          <form action="${pageContext.request.contextPath}/assignment/admin/updateScore"
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
				
                            <c:when test="${not empty assignment.submittedFileName and not empty assignment.submissionId}">
				
                                <a href="${pageContext.request.contextPath}/assignment/admin/download?submissionId=${assignment.submissionId}">
				
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
                               value="${assignment.score}"  >

                        / ${assignment.maxScore} 점

                    </td>
                </tr>

            </table>

            <div class="button-area">

                <button type="submit"
                        class="btn btn-save">
                    채점 완료
                </button>

                <a href="${pageContext.request.contextPath}/assignment/admin/list"
                   class="btn-list">
                    목록으로
                </a>

            </div>

        </form>

    </div>

</div>

</body>
</html>