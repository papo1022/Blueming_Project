<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberDashboard.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/menubar.css">
<head>
<meta charset="UTF-8">
<title>과제 채점</title>

<style>

/* ===== 전체 ===== */
body{
    background:#f5f7fb;
    margin:0;
    padding:30px;
    font-family:"맑은 고딕", sans-serif;
}

/* ===== 컨테이너 ===== */
.container{
    width:1200px;
    max-width:95%;
    margin:auto;
}

/* ===== 제목 ===== */
.page-title{
    text-align:center;
    font-size:30px;
    font-weight:700;
    color:#2d3748;
    margin-bottom:25px;
}

/* ===== 카드 ===== */
.card{
    background:white;
    border-radius:15px;
    padding:25px;
    box-shadow:0 2px 10px rgba(0,0,0,.08);
}

/* ===== 상세 테이블 ===== */
.detail-table{
    width:100%;
    border-collapse:collapse;
    overflow:hidden;
}

.detail-table th{
    width:180px;
    background:#4fd1c5;
    color:white;
    text-align:center;
    vertical-align:middle;
    padding:15px;
    border:1px solid #e8f4f8;
    font-size:14px;
}

.detail-table td{
    padding:15px 20px;
    border:1px solid #eef2f7;
    background:white;
    color:#333;
}

/* ===== 내용 영역 ===== */
.content-box{
    min-height:180px;
    white-space:pre-wrap;
    line-height:1.8;
    padding:15px;
    background:#fafcff;
    border-radius:8px;
}

/* ===== 첨부파일 ===== */
.detail-table a{
    color:#4fd1c5;
    font-weight:600;
    text-decoration:none;
}

.detail-table a:hover{
    text-decoration:underline;
}

/* ===== 점수 ===== */
.score-text{
    color:#e53e3e;
    font-weight:700;
}

.score-input{
    width:120px;
    height:45px;
    text-align:center;
    font-size:18px;
    border:1px solid #dce3ea;
    border-radius:10px;
    outline:none;
}

.score-input:focus{
    border-color:#4fd1c5;
}

/* ===== 버튼 영역 ===== */
.button-area{
    margin-top:30px;
    text-align:center;
}

/* ===== 공통 버튼 ===== */
.btn{
    border:none;
    padding:12px 30px;
    border-radius:10px;
    cursor:pointer;
    font-size:15px;
    font-weight:600;
    transition:.2s;
}

/* ===== 저장 버튼 ===== */
.btn-save{
    background:#4fd1c5;
    color:white;
}

.btn-save:hover{
    background:#38b2ac;
}

/* ===== 목록 버튼 ===== */
.btn-list{
    display:inline-block;
    background:#6c757d;
    color:white;
    text-decoration:none;
    padding:12px 30px;
    border-radius:10px;
    margin-left:10px;
    font-weight:600;
    transition:.2s;
}

.btn-list:hover{
    background:#555;
    color:white;
}

/* ===== 행 Hover ===== */
.detail-table tr:hover td{
    background:#f9fcff;
}

/* ===== 반응형 ===== */
@media (max-width:768px){

    .detail-table th{
        width:120px;
        font-size:13px;
    }

    .detail-table td{
        font-size:13px;
    }

    .score-input{
        width:100px;
    }
}

</style>

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