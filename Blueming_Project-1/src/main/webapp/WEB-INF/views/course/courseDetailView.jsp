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
        float : center;
        margin: 20px;
        margin-left: 270px;
        width : 80%;
    }
    #chapter-area>tbody>tr:hover {
        background-color: #f8f9fa;
        cursor: pointer;
    }
    .table {
        text-align: center;
    }
    .text-big {
        font-size: 20px;
        font-weight: bold;
    }
    .text-small {
        font-size: 13px;
        font-weight: bold;
    }
</style>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                                <button type="button" class="btn btn-secondary mr-1" onclick="courseUpdate();">
                                    강의 수정
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
                    <br>
                    <h5>총 이수율</h5>

                    <div style="position: relative; height: 30px;">
                        <div class="progress" style="height: 30px; margin-bottom: 0;">
                            <div id="totalProgressBar" class="progress-bar progress-bar-striped bg-success progress-bar-animated rounded-pill"
                                role="progressbar"
                                style="width: 0%;">
                            </div>
                        </div>
                        <span id="totalProgress" class="text-big"
                              style="position: absolute; top: 50%; transform: translateY(-50%); font-size: 16px; font-weight: bold; white-space: nowrap; pointer-events: none;"
                              >0%</span>
                    </div>
                </div>

                <!-- 챕터별 그래프 -->
                <div>
                    <h5>챕터별 이수율</h5>

                    <div style="height:400px; border:1px solid #ddd; border-radius:10px;"
                        class="d-flex justify-content-center align-items-center">
                        <canvas id="courseChart"></canvas>
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
                            <th width="50%">이수율</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ch" items="${chapterList}">
                            <tr>
                                <td style="display:none;">${ch.chapterId}</td>
                                <td>${ch.chapterOrder}</td>
                                <td>${ch.chapterTitle}</td>
                                <td>
                                    <div style="position: relative; height: 20px;">
                                        <div class="progress" style="height: 20px; margin-bottom: 0;">
                                            <div class="progress-bar progress-bar-striped bg-info progress-bar-animated rounded-pill chapter-progress-bar"
                                                role="progressbar"
                                                style="width: 0%;"
                                                data-rate="${ch.avgProgress}">
                                            </div>
                                        </div>
                                        <span class="text-small chapter-progress-text"
                                              style="position: absolute; top: 50%; transform: translateY(-50%); font-size: 12px; white-space: nowrap; pointer-events: none;"
                                              >0.00%</span>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        <br><br>
    </div>

</script>

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

        window.$(function() {
            initChapterProgressBars();
            totalProgress();
        });

        function initChapterProgressBars() {
            $(".chapter-progress-bar").each(function() {
                const rawRate = parseFloat($(this).data("rate"));
                const rate = Number.isFinite(rawRate) ? Math.max(0, Math.min(100, rawRate)) : 0;
                $(this).css("width", rate.toFixed(2) + "%");

                const label = rate.toFixed(2) + "%";
                const $wrap = $(this).closest("div[style*='position: relative']");
                const $text = $wrap.find(".chapter-progress-text");
                $text.text(label);

                // 텍스트가 바 안에 들어갈 수 있으면 바 안쪽에, 아니면 바 오른쪽 여백에 배치
                const barPx = $(this).width();
                const textPx = $text.outerWidth();
                const PADDING = 8;
                if (barPx >= textPx + PADDING) {
                    // 바 안에 표시 (흰 글자)
                    $text.css({ left: rate / 2 + "%", color: "#fff", transform: "translate(-50%, -50%)" });
                } else {
                    // 바 오른쪽 여백에 표시 (어두운 글자)
                    $text.css({ left: rate + "%", color: "#555", transform: "translate(4px, -50%)" });
                }
            });
        }
        
        function totalProgress(){
            let totalProgress = 0;
            let count = 0;
            <c:forEach var="ch" items="${chapterList}">
                totalProgress += ${ch.avgProgress};
                count++;
            </c:forEach>
            if (count === 0) {
                document.getElementById("totalProgress").textContent = "0.00%";
                document.getElementById("totalProgressBar").style.width = "0%";
                return;
            }

            totalProgress = (totalProgress / count).toFixed(2);
            const bar = document.getElementById("totalProgressBar");
            const label = document.getElementById("totalProgress");
            bar.style.width = totalProgress + "%";
            label.textContent = totalProgress + "%";

            // 텍스트가 바 안에 들어갈 수 있으면 안쪽(흰색), 아니면 바 오른쪽 여백(어두운색)
            requestAnimationFrame(function() {
                const barPx = bar.offsetWidth;
                const textPx = label.offsetWidth;
                const PADDING = 8;
                if (barPx >= textPx + PADDING) {
                    label.style.left = (parseFloat(totalProgress) / 2) + "%";
                    label.style.color = "#fff";
                    label.style.transform = "translate(-50%, -50%)";
                } else {
                    label.style.left = totalProgress + "%";
                    label.style.color = "#333";
                    label.style.transform = "translate(6px, -50%)";
                }
            });
        }

        new Chart(document.getElementById('courseChart'), {
            type: 'line',
            data: {
                labels: [
                    <c:forEach var="ch" items="${chapterList}" varStatus="status">
                        '${ch.chapterTitle}'
                        <c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                datasets: [{
                    label: '수강률',
                    data: [
                        <c:forEach var="ch" items="${chapterList}" varStatus="status">
                            ${ch.avgProgress}
                            <c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ]
                }]
            }
        });
    </script>
</body>
</html>