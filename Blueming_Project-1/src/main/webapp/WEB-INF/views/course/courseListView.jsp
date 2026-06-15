<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>강의 리스트</title>
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
            <link rel="stylesheet"
                href="https://cdn-uicons.flaticon.com/uicons-regular-rounded/css/uicons-regular-rounded.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard/memberDashboard.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/mainMenubar.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/courseStyle.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/courseListView.css">
        </head>

        <body>
            <jsp:include page="../common/mainMenubar.jsp" />
            <jsp:include page="../common/dateFormatUtil.jsp" />

            <div class="outer">
                <div class="main-panel">
                    <h2 class="page-title-left">
                       <i class="page-title-left fi fi-sr-graduation-cap"> 강의리스트</i> 
                    </h2>

                    <div class="top-controls">
                        <div id="search-area" align="left">
                            <form action="/blueming/course/list" method="get">
                                <input type="search" name="keyword" value="${ keyword }" id="keyword-input">
                                <input type="hidden" name="sort" value="${ sort }" id="sort-hidden-input">
                                <input type="hidden" name="mineOnly" value="${mineOnly}" id="mineOnly-hidden-input">
                                <button type="submit" class="btn btn-primary">검색</button>
                                <c:if test="${sessionScope.loginUser.role eq 'S' }">
                                    <button type="button" onclick="courseAdd();" class="btn btn-primary">강의 등록</button>
                                </c:if>
                            </form>
                        </div>

                        <div class="course-toolbar">
                            <c:if test="${sessionScope.loginUser.role eq 'S'}">
                                <label class="mine-toggle" for="mine-only-checkbox">
                                    <input type="checkbox" id="mine-only-checkbox" value="true" ${mineOnly ? 'checked'
                                        : '' }>
                                    내 강의만 보기
                                </label>
                            </c:if>
                            <button type="button" class="sort-btn" data-sort="latest" id="sort-latest">최신순</button>
                            <span class="sort-divider">/</span>
                            <button type="button" class="sort-btn" data-sort="oldest" id="sort-oldest">오래된순</button>
                        </div>
                    </div>



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
                const CONTEXT_PATH = "${pageContext.request.contextPath}";
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

                function sanitizeThumbnailUrl(url) {
                    if (url == null) return "";

                    const trimmed = String(url).trim();
                    if (!trimmed) return "";

                    if (/^javascript:/i.test(trimmed) || /^data:/i.test(trimmed)) {
                        return "";
                    }

                    return trimmed;
                }

                function resolveThumbnailUrl(url) {
                    const sanitized = sanitizeThumbnailUrl(url);
                    if (!sanitized) {
                        return "";
                    }

                    if (/^https?:\/\//i.test(sanitized)) {
                        return sanitized;
                    }

                    if (sanitized.startsWith(CONTEXT_PATH + "/")) {
                        return sanitized;
                    }

                    if (sanitized.startsWith("/")) {
                        return CONTEXT_PATH + sanitized;
                    }

                    return CONTEXT_PATH + "/" + sanitized;
                }

                function cutDescription(desc) {
                    if (!desc) return "";
                    return desc.length > 40 ? desc.substring(0, 40) + "..." : desc;
                }

                function appendCourseCards(list) {
                    let resultStr = "";

                    for (let i = 0; i < list.length; i++) {
                        const course = list[i];
                        const resolvedThumbnail = resolveThumbnailUrl(course.thumbnailUrl);
                        const hasThumbnail = !!resolvedThumbnail;
                        const courseThumbnail = escapeHtml(resolvedThumbnail);
                        const title = escapeHtml(course.courseTitle);
                        const description = escapeHtml(cutDescription(course.description));
                        const startDate = formatDateOnlyKst(course.startDate);
                        const endDate = formatDateOnlyKst(course.endDate);
                        const period = escapeHtml(startDate + " ~ " + endDate + " (" + (course.status || "") + ")");
                        const totalHours = escapeHtml(String(course.totalHours == null ? "" : course.totalHours));
                        const imageDisplay = hasThumbnail ? "block" : "none";
                        const fallbackDisplay = hasThumbnail ? "none" : "flex";

                        resultStr += "<div class='course-card' onclick=\"location.href='/blueming/course/detail?courseId=" + course.courseId + "'\">"
                            + "<div class='course-thumbnail-wrap'>"
                            + "<img class='course-thumbnail-img' src='" + courseThumbnail + "' alt='Course Thumbnail' loading='lazy' style='display:" + imageDisplay + ";' onerror=\"this.style.display='none'; var fb=this.nextElementSibling; if(fb){fb.style.display='flex';}\">"
                            + "<div class='course-thumbnail-fallback' style='display:" + fallbackDisplay + ";'><i class='fi fi-rr-camera'></i></div>"
                            + "</div>"
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
                        success: function (result) {
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
                        error: function (xhr, textStatus) {
                            if (activeRequest !== request) {
                                return;
                            }

                            if (textStatus !== "abort") {
                                console.log("강의 목록 ajax 통신 실패");
                            }
                        },
                        complete: function () {
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

                $(function () {
                    if (sort !== "oldest") {
                        sort = "latest";
                    }

                    const $mineOnlyCheckbox = $("#mine-only-checkbox");
                    if ($mineOnlyCheckbox.length > 0) {
                        mineOnly = $mineOnlyCheckbox.is(":checked");
                        $mineOnlyCheckbox.prop("checked", mineOnly);
                    }

                    applySortButtonState();

                    loadCourseList();

                    $(".sort-btn").on("click", function () {
                        const selectedSort = $(this).data("sort");
                        if (sort === selectedSort) {
                            return;
                        }

                        sort = selectedSort;
                        applySortButtonState();
                        resetAndReload();
                    });

                    $("#mine-only-checkbox").on("change", function () {
                        mineOnly = $(this).is(":checked");
                        applySortButtonState();
                        resetAndReload();
                    });

                    $(window).on("pageshow", function () {
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

                    $(window).on("scroll", function () {
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

                function courseAdd() {
                    location.href = "addCourseView";
                }
            </script>
        </body>

        </html>