<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>

<%-- 공통 메뉴바 --%>
<jsp:include page="/WEB-INF/views/common/menubar.jsp"/>

<div class="container-fluid mt-4">
    <div class="row">

        <%-- 왼쪽: 강의 목록 --%>
        <div class="col-md-8">

            <%-- 인사말 --%>
            <h4>관리자 계정</h4>

            <%-- 강의 목록 --%>
            <h5 class="mt-4">관리할 강의 목록</h5>
            <div class="row">
                <c:forEach var="course" items="${courseList}">
                    <div class="col-md-6 mb-3">
                        <div class="card">
                            <div class="card-body">

                                <%-- 수정 버튼 --%>
                                <div class="text-right">
                                    <a href="/course/update?courseId=${course.courseId}"
                                       class="btn btn-info btn-sm">수정</a>
                                </div>

                                <%-- 강의명 --%>
                                <h6 class="card-title mt-2">${course.courseTitle}</h6>

                                <%-- D-day 및 상태 --%>
                                <c:choose>
                                    <c:when test="${course.courseStatus == 'CLOSED'}">
                                        <span class="text-muted font-weight-bold">마감</span>
                                    </c:when>
                                    <c:when test="${course.courseStatus == 'WAITING'}">
                                        <span class="text-primary font-weight-bold">예정</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-warning font-weight-bold">D-${course.dDay}</span>
                                    </c:otherwise>
                                </c:choose>

                                <%-- 강의 기간 --%>
                                <p class="text-muted mt-2">
                                    ${course.startDate} ~ ${course.endDate}
                                </p>

                            </div>
                        </div>
                    </div>
                </c:forEach>

                <%-- 데이터 없을 때 --%>
                <c:if test="${empty courseList}">
                    <div class="col-12">
                        <p class="text-center text-muted">등록된 강의가 없습니다.</p>
                    </div>
                </c:if>
            </div>

        </div>

        <%-- 오른쪽: 프로필 + 공지사항 --%>
        <div class="col-md-4">

            <%-- 프로필 --%>
            <div class="card mb-4">
                <div class="card-body text-center">
                    <h5>${profile.name}</h5>
                    <p class="text-muted">${profile.email}</p>
                </div>
            </div>

            <%-- 공지사항 최근 3개 --%>
            <h5>공지사항</h5>
            <div class="list-group">
                <c:forEach var="notice" items="${noticeList}">
                    <a href="/notice/detail/${notice.noticeId}"
                       class="list-group-item list-group-item-action">
                        <p class="mb-1">${notice.noticeTitle}</p>
                        <small class="text-muted">${notice.createdDate}</small>
                    </a>
                </c:forEach>

                <%-- 데이터 없을 때 --%>
                <c:if test="${empty noticeList}">
                    <p class="text-muted">공지사항이 없습니다.</p>
                </c:if>
            </div>

        </div>
    </div>
</div>

</body>
</html>