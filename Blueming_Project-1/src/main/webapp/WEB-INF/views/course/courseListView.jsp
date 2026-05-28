<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>강의 리스트</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
    /* 임시 스타일 */
    .outer {
        max-width: 1200px;
        margin: 0 auto;
    }

    #search-area input[type="search"] {
        width: 280px;
        padding: 8px 10px;
    }

    .course-toolbar {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        margin-bottom: 14px;
    }

    .sort-btn {
        border: none;
        background: transparent;
        color: #888;
        font-size: 15px;
        padding: 0;
    }

    .sort-btn.active {
        color: #e74c3c;
        font-weight: 700;
    }

    .sort-divider {
        color: #bbb;
        margin: 0 6px;
    }

    #course-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(230px, 1fr));
        gap: 18px;
        width: 100%;
    }

    .course-card {
        background: #ffffff;
        border: 1px solid #e7e7e7;
        border-radius: 12px;
        overflow: hidden;
        cursor: pointer;
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .course-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
    }

    .course-thumb {
        height: 120px;
        background: linear-gradient(180deg, #dfdfdf 0%, #d1d1d1 100%);
    }

    .course-meta {
        padding: 14px;
    }

    .course-line {
        margin-bottom: 8px;
        color: #222;
        font-size: 14px;
        line-height: 1.4;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .course-line:last-child {
        margin-bottom: 0;
    }

    .course-title {
        font-weight: 700;
    }

    #empty-message {
        display: none;
        text-align: center;
        color: #666;
        padding: 18px 0;
    }

    #loading-area {
        display: none;
        text-align: center;
        color: #666;
        padding: 12px 0;
    }
    /* 임시 스타일 끝 */
</style>
</head>
<body>
    <jsp:include page="../common/menubar.jsp" />

    <div class="outer">
        <br>
        <h2 align="left">강의리스트</h2>
        <br><br>

        <div id="search-area" align="left">
            <form action="/blueming/course/list" method="get">
                <input type="search" name="keyword" value="${ keyword }" id="keyword-input">
                <input type="hidden" name="sort" value="${ sort }" id="sort-hidden-input">
                <button type="submit" class="btn btn-primary">검색</button>
            </form>
        </div>

        <br><br>

        <c:if test="${sessionScope.loginUser.role eq 'S' }">
            <div align="left" style="width:90%">
                <a href="/blueming/course/enrollForm" class="btn btn-primary">강의 등록</a>
                <!-- todo -->
                <br><br>
            </div>
        </c:if>

        <div class="course-toolbar">
            <button type="button" class="sort-btn" data-sort="latest" id="sort-latest">최신순</button>
            <span class="sort-divider">/</span>
            <button type="button" class="sort-btn" data-sort="oldest" id="sort-oldest">오래된순</button>
        </div>

        <div id="course-grid"></div>
        <div id="empty-message">검색 결과가 없습니다.</div>
        <div id="loading-area">불러오는 중...</div>
    </div>

    <script>
        let currentPage = 1;
        const limit = 4;
        let isLoading = false;
        let hasMore = true;
        let loadedCount = 0;
        const keyword = $("#keyword-input").val().trim();
        let sort = "${empty sort ? 'latest' : sort}";

        function applySortButtonState() {
            $(".sort-btn").removeClass("active");
            $(".sort-btn[data-sort='" + sort + "']").addClass("active");
            $("#sort-hidden-input").val(sort);
        }

        function resetAndReload() {
            currentPage = 1;
            isLoading = false;
            hasMore = true;
            loadedCount = 0;
            $("#course-grid").empty();
            $("#empty-message").hide();
            loadCourseList();
        }

        function escapeHtml(str) {
            if (str == null) return "";
            return String(str)
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/\"/g, "&quot;")
                .replace(/'/g, "&#39;");
        }

        function cutDescription(desc) {
            if (!desc) return "";
            return desc.length > 40 ? desc.substring(0, 40) + "..." : desc;
        }

        function formatDateOnly(value) {
            if (!value) return "";
            const str = String(value);
            return str.includes("T") ? str.split("T")[0] : str;
        }

        function appendCourseCards(list) {
            let resultStr = "";

            for (let i = 0; i < list.length; i++) {
                const course = list[i];
                const title = escapeHtml(course.courseTitle);
                const description = escapeHtml(cutDescription(course.description));
                const startDate = formatDateOnly(course.startDate);
                const endDate = formatDateOnly(course.endDate);
                const period = escapeHtml(startDate + " ~ " + endDate + " (" + (course.status || "") + ")");
                const totalHours = escapeHtml(String(course.totalHours == null ? "" : course.totalHours));

                resultStr += "<div class='course-card' onclick=\"location.href='/blueming/course/detail?courseId=" + course.courseId + "'\">"
                           + "<div class='course-thumb'></div>"
                           + "<div class='course-meta'>"
                           + "<div class='course-line course-title'>" + title + "</div>"
                           + "<div class='course-line'>" + description + "</div>"
                           + "<div class='course-line'>" + period + "</div>"
                           + "<div class='course-line'>총 강의 시간: " + totalHours + "시간</div>"
                           + "</div>"
                           + "</div>";
            }

            $("#course-grid").append(resultStr);
        }

        function loadCourseList() {
            if (isLoading || !hasMore) {
                return;
            }

            isLoading = true;
            $("#loading-area").show();

            $.ajax({
                url: "/blueming/course/ajaxList",
                type: "get",
                data: {
                    page: currentPage,
                    limit: limit,
                    keyword: keyword,
                    sort: sort
                },
                success: function(result) {
                    if (result.length > 0) {
                        appendCourseCards(result);
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
                error: function() {
                    console.log("강의 목록 ajax 통신 실패");
                },
                complete: function() {
                    isLoading = false;
                    $("#loading-area").hide();

                    if (hasMore && $(document).height() <= $(window).height()) {
                        loadCourseList();
                    }
                }
            });
        }

        $(function() {
            if (sort !== "oldest") {
                sort = "latest";
            }

            applySortButtonState();

            loadCourseList();

            $(".sort-btn").on("click", function() {
                const selectedSort = $(this).data("sort");
                if (sort === selectedSort) {
                    return;
                }

                sort = selectedSort;
                applySortButtonState();
                resetAndReload();
            });

            $(window).on("scroll", function() {
                if (!hasMore || isLoading) {
                    return;
                }

                const scrollTop = $(window).scrollTop();
                const windowHeight = $(window).height();
                const docHeight = $(document).height();

                if (scrollTop + windowHeight >= docHeight - 200) {
                    loadCourseList();
                }
            });
        });
    </script>
</body>
</html>
