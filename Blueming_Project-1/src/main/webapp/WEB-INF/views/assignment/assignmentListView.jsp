    <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>blueming</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>

    <jsp:include page="../common/menubar.jsp" />

    <div class="outer">
        <br>
        <h2 align="left">과제리스트</h2>
        <br><br>

        <div id="search-area" align="left">
            <form action="/blueming/assignment/list" method="get">
                <input type="search" name="keyword" value="${keyword}" id = "keyword-input">
                <input type="hidden" name="targetType" value="${targetType}" id="targetType-hidden-input">
                <button type="submit" class="btn btn-primary">검색</button>
            </form>
        </div>

        <br><br>

        <c:if test="${sessionScope.loginUser.role eq 'S'}">
            <div align="left" style="width:90%">
                <a href="/blueming/assignment/enrollForm" class="btn btn-primary">
                    과제 등록
                </a>  
                <br><br>
            </div>
        </c:if>

        <!-- 강의명 순 / 마감일 가까운 순 -->
        <div class="assignment-toolbar">
            <button type="button" class="sort-btn" data-sort="cName" id="sort-latest">강의명순</button>
            <span class="sort-divider">/</span>
            <button type="button" class="sort-btn" data-sort="deadline" id="sort-deadline">마감일 가까운순</button>
        </div>
        
        <div id="assignment-grid"></div>
        <div id="empty-message">검색 결과가 없습니다.</div>
        <div id="loading-area">불러오는 중...</div>
    </div>

    <script>
        let currentPage = 1;
        const limit = 8;
        let isLoading = false;
        let hasMore = true;
        let loadedCount = 0;
        const keyword = ($('#keyword-input').val() || '').trim();
        let targetType = "${empty targetType ? 'cName' : targetType}";

        function applySortButtonState() {
            $(".sort-btn").removeClass("active");
            $(".sort-btn[data-sort='" + targetType + "']").addClass("active");
            $("#targetType-hidden-input").val(targetType);
        }

        function resetAndReload() {
            currentPage = 1;
            isLoading = false;
            hasMore = true;
            loadedCount = 0;
            $("#assignment-grid").empty();
            $("#empty-message").hide();
            loadAssignmentList();
        }

        function escapeHtml(str) {
            if (!str) return '';
            return str.replace(/&/g, "&amp;")
                      .replace(/</g, "&lt;")
                      .replace(/>/g, "&gt;")
                      .replace(/"/g, "&quot;")
                      .replace(/'/g, "&#039;");
        }

        function formatDateOnly(value) {
            if (!value) return '';
            const str = String(value);
            return str.includes("T") ? str.split("T")[0] : str;
        }

        /*
            과제명
            강의명
            기한
            점수
        */
        function appendAssignmentCards(list) {
            let resultStr = "";

            for (let i = 0; i < list.length; i++) {
                const assignment = list[i];
                const title = escapeHtml(assignment.assignmentTitle);
                const courseTitle = escapeHtml(assignment.courseTitle);
                const startDate = formatDateOnly(assignment.startDate);
                const dueDate = formatDateOnly(assignment.dueDate);
                const period = escapeHtml(startDate + " ~ " + dueDate);
                const score = escapeHtml(String(assignment.score == null ? "채점 전" : assignment.score));
                const maxScore = escapeHtml(String(assignment.maxScore));
    
                resultStr += "<div class='assignment-card' onclick=\"location.href='/blueming/assignment/detail?assignmentId=" + assignment.assignmentId + "'\">"
                           + "<div class='assignment-meta'>"
                           + "<div class='course-line assignment-title'>" + title + "</div>"
                           + "<div class='course-line course-title'>" + courseTitle + "</div>"
                           + "<div class='course-line'>" + period + "</div>"
                           + "<div class='course-line'>" + score + " / " + maxScore + "</div>"
                           + "</div>"
                           + "</div>";
            }
            
            $("#assignment-grid").append(resultStr);
        }

        function loadAssignmentList() {
            if (isLoading || !hasMore) return;

            isLoading = true;
            $("#loading-area").show();

            $.ajax({
                url: "/blueming/assignment/ajaxList",
                method: "get",
                data: {
                    page: currentPage,
                    limit: limit,
                    keyword: keyword,
                    targetType: targetType
                },
                success : function(result) {
                    if (result.length > 0) {
                        appendAssignmentCards(result);
                        loadedCount += result.length;
                        currentPage++;
                    }

                    if (result.length < limit) {
                        hasMore = false;
                        if (loadedCount === 0) {
                            $("#empty-message").show();
                        }
                    }
                },
                error : function() {
                    console.log("과제 목록 ajax 통신 실패");
                },
                complete : function() {
                    isLoading = false;
                    $("#loading-area").hide();

                    if (hasMore && $(document).height() <= $(window).height()) {
                        loadAssignmentList();
                    }
                }
            });
        }

        $(function() {
            if (targetType !== "deadline") {
                targetType = "cName";
            }

            applySortButtonState();

            loadAssignmentList();

            $(".sort-btn").on("click", function() {
                const selectedTargetType = $(this).data("sort");
                if (targetType === selectedTargetType) {
                    return;
                }

                targetType = selectedTargetType;
                applySortButtonState();
                resetAndReload();
            });

            $(window).on("scroll", function() {
                if (!hasMore || isLoading) return;

                const scrollTop = $(window).scrollTop();
                const windowHeight = $(window).height();
                const docHeight = $(document).height();

                if (scrollTop + windowHeight >= docHeight - 200) {
                    loadAssignmentList();
                }
            });
        });

    </script>
</body>
</html>