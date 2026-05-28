<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"
    uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>blueming</title>
</head>
<body>

    <jsp:include page="../common/menubar.jsp" />

    <div class="outer">

        <br>
        <h2 align="center">강의 상세조회</h2>
        <br>

        <!-- 관리자에게만 보이는 버튼-->
        <button class="btn btn-primary" onclick="chapterAdd();">
            챕터 추가
        </button>
        <br><br>

        <table id="detail-area" class="table">
            <tr>
                <th>강의명</th>
                <td>${ requestScope.course.courseTitle }</td>
            </tr>
            <tr>
                <th>강의 설명</th>
                <td>${ requestScope.course.description }</td>
            </tr>
            <tr>
                <th>작성자</th>
                <td>${ requestScope.course.memberId }</td>
            </tr>
            <tr>
                <th>총 수업 시간</th>
                <td>${ requestScope.course.totalHours }시간</td>
            </tr>
            <tr>
                <th>강의 기간</th>
                <td>${ requestScope.course.startDate } ~ ${ requestScope.course.endDate }</td>
            </tr>
            <tr>
                <th>강의 상태</th>
                <td>
                    <c:choose>
                        <c:when test="${ requestScope.course.status eq 'Y' }">
                            진행중
                        </c:when>
                        <c:when test="${ requestScope.course.status eq 'W' }">
                            예정
                        </c:when>
                        <c:when test="${ requestScope.course.status eq 'N' }">
                            종료
                        </c:when>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <th>등록일</th>
                <td>${ requestScope.course.createDate }</td>
            </tr>
            <tr>
                <th>수정일</th>
                <td>${ requestScope.course.updatedDate }</td>
            </tr>
        </table>

        <h2 align="center">챕터 리스트</h2>
        <br><br>
        <table id="chapter-area" class="table">

            <tr>
                <th width="10%">번호</th>
                <th width="40%">제목</th>
                <th width="30%">그래프</th>
                <th width="10%">이수률</th>
            </tr>

            <c:forEach var="ch" items="${requestScope.at}">
                <tr>
                    <td>${ch.chapterId}</td>
                    <td>${ch.chapterTitle}</td>
                    <td>이수률 막대그래프</td>
                    <td>n%</td>
                </tr>
            </c:forEach>

        </table>

    </div>

    <script>
        function chapterAdd(){
            location.href = "addChapterView?courseId=${course.courseId}";
        }
    </script>
</body>
</html>