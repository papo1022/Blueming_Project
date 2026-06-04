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
    :root {
        --panel-bg: #ffffff;
        --panel-border: #d8dee8;
        --brand-700: #1f3556;
        --brand-500: #2f4c78;
    }

    .outer {
        max-width: 1200px;
        margin: 0 auto;
        padding-bottom: 20px;
    }

    .main-panel {
        background-color: var(--panel-bg);
        border: 1px solid var(--panel-border);
        border-radius: 16px;
        padding: 18px;
        box-shadow: 0 8px 26px rgba(21, 40, 70, 0.08);
    }

    .top-controls {
        display: flex;
        justify-content: space-between;
        gap: 16px;
        align-items: center;
        margin-bottom: 16px;
        flex-wrap: wrap;
    }

    #search-area input[type="search"] {
        width: 320px;
        height: 38px;
        border: 1px solid #cbd5e1;
        border-radius: 8px;
        padding: 0 12px;
        font-size: 14px;
        color: #1f2937;
        background-color: #ffffff;
    }

    #search-area input[type="search"]:focus {
        border-color: var(--brand-500);
        outline: none;
        box-shadow: 0 0 0 3px rgba(47, 76, 120, 0.14);
    }

    #search-area .btn {
        height: 38px;
        border-radius: 8px;
        border: 0;
        padding: 0 14px;
        font-weight: 700;
        background-color: var(--brand-700);
    }

    #search-area .btn:hover {
        background-color: #18304f;
    }

    .course-toolbar {
        margin: 0;
        display: inline-flex;
        align-items: center;
        background: #f6f8fb;
        border: 1px solid #e0e6ef;
        border-radius: 999px;
        padding: 4px;
    }

    .mine-toggle {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        margin: auto;
        margin-right: 8px;
        padding: 6px 10px;
        border-radius: 999px;
        border: 1px solid #d6dfec;
        background: #ffffff;
        color: #44556c;
        font-size: 12px;
        font-weight: 700;
        cursor: pointer;
        user-select: none;
    }

    .mine-toggle input[type="checkbox"] {
        width: 14px;
        height: 14px;
        margin: 0;
        accent-color: var(--brand-500);
    }

    .sort-btn {
        border: 0;
        background: transparent;
        color: #64748b;
        font-size: 13px;
        font-weight: 700;
        cursor: pointer;
        border-radius: 999px;
        padding: 6px 12px;
    }


    .sort-btn.active {
        color: #ffffff;
        background-color: var(--brand-500);
    }

    .sort-divider {
        margin: 0 6px;
        color: #c0cad7;
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

    @media (max-width: 900px) {
        #search-area input[type="search"] {
            width: 240px;
        }
    }

    @media (max-width: 640px) {
        .top-controls {
            flex-direction: column;
            align-items: stretch;
        }

        #search-area form {
            display: flex;
            gap: 8px;
        }

        #search-area input[type="search"] {
            width: 100%;
            min-width: 0;
        }
    }
</style>
</head>
<body>
    <jsp:include page="../common/mainMenubar.jsp" />
    <jsp:include page="../common/dateFormatUtil.jsp" />

    <div class="outer">
        <div class="main-panel">
            <h2 align="left" style="margin-bottom:16px;">강의리스트</h2>

            <div class="top-controls">
                <div id="search-area" align="left">
                    <form action="/blueming/course/list" method="get">
                        <input type="search" name="keyword" value="${ keyword }" id="keyword-input">
                        <input type="hidden" name="sort" value="${ sort }" id="sort-hidden-input">
                        <input type="hidden" name="mineOnly" value="${mineOnly}" id="mineOnly-hidden-input">
                        <button type="submit" class="btn btn-primary">검색</button>
                    </form>
                </div>

                <div class="course-toolbar">
                    <c:if test="${sessionScope.loginUser.role eq 'S'}">
                        <label class="mine-toggle" for="mine-only-checkbox">
                            <input type="checkbox" id="mine-only-checkbox" value="true" ${mineOnly ? 'checked' : ''}>
                            내 강의만 보기
                        </label>
                    </c:if>
                    <button type="button" class="sort-btn" data-sort="latest" id="sort-latest">최신순</button>
                    <span class="sort-divider">/</span>
                    <button type="button" class="sort-btn" data-sort="oldest" id="sort-oldest">오래된순</button>
                </div>
            </div>

            <c:if test="${sessionScope.loginUser.role eq 'S' }">
                <div align="left" style="margin-bottom:14px;">
                    <a href="/blueming/course/addCourseView" class="btn btn-primary">강의 등록</a>
                </div>
            </c:if>

            <div id="course-grid"></div>
            <div id="empty-message">검색 결과가 없습니다.</div>
            <div id="loading-area">불러오는 중...</div>
        </div>
    </div>

    <script>
        let currentPage = 1;
        const limit = 4;
        let isLoading = false;
        let hasMore = true;
        let loadedCount = 0;
        let activeRequest = null;
        const keyword = $("#keyword-input").val().trim();
        let sort = "${empty sort ? 'latest' : sort}";
        let mineOnly = "${mineOnly}" === "true";

        function applySortButtonState() {
            $(".sort-btn").removeClass("active");
            $(".sort-btn[data-sort='" + sort + "']").addClass("active");
            $("#sort-hidden-input").val(sort);
            $("#mineOnly-hidden-input").val(mineOnly);
        }

        function resetAndReload() {
            if (activeRequest) {
                const pendingRequest = activeRequest;
                activeRequest = null;
                pendingRequest.abort();
            }

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

        function appendCourseCards(list) {
            let resultStr = "";

            for (let i = 0; i < list.length; i++) {
                const course = list[i];
                const title = escapeHtml(course.courseTitle);
                const description = escapeHtml(cutDescription(course.description));
                const startDate = formatDateOnlyKst(course.startDate);
                const endDate = formatDateOnlyKst(course.endDate);
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

            let request = null;
            request = $.ajax({
                url: "/blueming/course/ajaxList",
                type: "get",
                data: {
                    page: currentPage,
                    limit: limit,
                    keyword: keyword,
                    sort: sort,
                    mineOnly: mineOnly
                },
                success: function(result) {
                    if (activeRequest !== request) {
                        return;
                    }

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
                error: function(xhr, textStatus) {
                    if (activeRequest !== request) {
                        return;
                    }

                    if (textStatus !== "abort") {
                        console.log("강의 목록 ajax 통신 실패");
                    }
                },
                complete: function() {
                    if (activeRequest !== request) {
                        return;
                    }

                    activeRequest = null;
                    isLoading = false;
                    $("#loading-area").hide();

                    if (hasMore && $(document).height() <= $(window).height()) {
                        loadCourseList();
                    }
                }
            });

            activeRequest = request;
        }

        $(function() {
            if (sort !== "oldest") {
                sort = "latest";
            }

            const $mineOnlyCheckbox = $("#mine-only-checkbox");
            if ($mineOnlyCheckbox.length > 0) {
                // Browser history navigation can restore checkbox UI state after render.
                // Prefer the actual checkbox state so UI and ajax filter stay consistent.
                mineOnly = $mineOnlyCheckbox.is(":checked");
                $mineOnlyCheckbox.prop("checked", mineOnly);
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

            $("#mine-only-checkbox").on("change", function() {
                mineOnly = $(this).is(":checked");
                applySortButtonState();
                resetAndReload();
            });

            $(window).on("pageshow", function() {
                if ($mineOnlyCheckbox.length === 0) {
                    return;
                }

                const restoredMineOnly = $mineOnlyCheckbox.is(":checked");
                if (mineOnly === restoredMineOnly) {
                    return;
                }

                mineOnly = restoredMineOnly;
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

        function courseAdd(){
            location.href = "addCourseView";
        }
    </script>
</body>
</html>
