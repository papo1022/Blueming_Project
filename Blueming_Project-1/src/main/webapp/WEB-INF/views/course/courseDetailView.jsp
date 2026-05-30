<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"
    uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>blueming</title>
<style>
    .outer {
        width : 90%;
        margin : 0 auto;
    }
    #chapter-area>tbody>tr:hover {
        background-color: #f8f9fa;
        cursor: pointer;
    }
</style>
</head>
<body>

    <jsp:include page="../common/mainMenubar.jsp" />

    <div class="outer">

        <br>
        <h2 align="center">강의 상세조회</h2>
        <br>

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

        <!-- 관리자에게만 보이는 버튼-->
        <div align="center">
            <button class="btn btn-primary" onclick="chapterAdd();">
                챕터 추가
            </button>
            <button class="btn btn-secondary" onclick="chapterUpdate();">
                강의 수정
            </button>
            <button class="btn btn-warning" onclick="">
                강의 환경설정
            </button>
            <button class="btn btn-danger" onclick="">
                강의 삭제
            </button>
        </div>
        <br><br>

        <table id="chapter-area" class="table">
            <thead>
                <tr>
                    <th width="10%">챕터</th>
                    <th width="40%">제목</th>
                    <th width="30%">그래프</th>
                    <th width="10%">이수률</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="ch" items="${chapterList}">
                    <tr>
                        <td>${ch.chapterOrder}</td>
                        <td>${ch.chapterTitle}</td>
                        <td>이수률 막대그래프</td>
                        <td>n%</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

    </div>

    <script>
        function chapterAdd(){
            location.href = "addChapterView?courseId=${course.courseId}";
        }

        function courseUpdate(){
            location.href = "updateCourserView?courseId=${course.courseId}";
        }

        $(function() {
            //tr 요소 클릭시 이벤트 부여
            $("#chapter-area>tbody>tr").click(function() {
                let bno = $(this).children().eq(0).text();
                
                location.href = "chapterDetailView?chapterId=" + bno;
            });
        });
    </script>
</body>
</html>