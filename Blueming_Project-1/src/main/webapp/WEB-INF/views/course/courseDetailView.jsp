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

        <div class="card mt-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h2>강의 상세조회</h2>
                <!-- 관리자에게만 보이는 버튼-->
                <c:choose>
                    <c:when test="${ sessionScope.loginUser.role eq 'S' }">
                        <div class="d-flex justify-content-end gap-2">
                            <form>
                                <button type="button" class="btn btn-secondary" onclick="courseUpdate();">
                                    강의 수정
                                </button>
                                <button type="button" class="btn btn-warning mr-1" onclick="">
                                    강의 환경설정
                                </button>
                            </form>
                            <form id="deleteForm" action="deleteCourse" method="post">
                                <input type="hidden" name="courseId" value="${course.courseId}">
                                <button type="button" class="btn btn-danger" onclick="courseDelete();">
                                    강의 삭제
                                </button>
                            </form>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <style>
                            .d-flex {
                                display: none;
                            }
                        </style>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="card-body">
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
                        <td>${ requestScope.course.name }</td>
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
            </div>
        </div>


        <!-- 통계 영역 -->
        <div class="card mt-4">
            <div class="card-header">
                <h2 class="mb-0">강의 통계</h2>
            </div>

            <div class="card-body">

                <!-- 총 이수율 -->
                <div class="mb-5">
                    <h5>총 이수율</h5>

                    <div class="progress" style="height: 30px;">
                        <div class="progress-bar bg-success"
                            role="progressbar"
                            style="width: 75%;">
                            75%
                        </div>
                    </div>
                </div>

                <!-- 챕터별 그래프 -->
                <div>
                    <h5>챕터별 이수율</h5>

                    <div style="height:400px; border:1px solid #ddd; border-radius:10px;"
                        class="d-flex justify-content-center align-items-center">
                        그래프 영역
                    </div>
                </div>

            </div>
        </div>

        <div class="card mt-4">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h2 class="mb-0">챕터 리스트</h2>
                <!-- 관리자에게만 보이는 버튼-->
                <c:choose>
                    <c:when test="${ sessionScope.loginUser.role eq 'S' }">
                        <div align="center" class="d-flex gap-2">
                            <form>
                                <button type="button" class="btn btn-primary" onclick="chapterAdd();">
                                    챕터 추가
                                </button>
                            </form>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <style>
                            .d-flex {
                                display: none;
                            }
                        </style>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="card-body">
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
                                <td style="display:none;">${ch.chapterId}</td>
                                <td>${ch.chapterOrder}</td>
                                <td>${ch.chapterTitle}</td>
                                <td>이수률 막대그래프</td>
                                <td>n%</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        <br><br>
    </div>

    <script>
        function chapterAdd(){
            location.href = "addChapterView?courseId=${course.courseId}";
        }

        function courseUpdate(){
            location.href = "updateCourseView?courseId=${course.courseId}";
        }

        $(function() {
            //tr 요소 클릭시 이벤트 부여
            $("#chapter-area>tbody>tr").click(function() {
                let chno = $(this).children().eq(0).text();
                location.href = "chapterDetailView?chapterId=" + chno;
            });
        });

        function courseDelete(){
            if(confirm("정말로 강의를 삭제하시겠습니까?")){
                document.getElementById("deleteForm").submit();
            }
        }
    </script>
</body>
</html>