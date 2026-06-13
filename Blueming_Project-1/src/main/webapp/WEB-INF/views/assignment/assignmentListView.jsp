    <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>blueming</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;800&display=swap" rel="stylesheet">
<style>
    :root {
        --bg-base: #eef1f6;
        --panel-bg: #ffffff;
        --panel-border: #d8dee8;
        --text-main: #1f2937;
        --text-sub: #5f6b7a;
        --brand-700: #1f3556;
        --brand-500: #2f4c78;
        --chip-bg: #f3f6fb;
        --chip-border: #d6dfec;
        --card-border: #d9e1ee;
        --card-hover: #f8faff;
        --ok: #136f4f;
        --wait: #946200;
    }

    body {
        background: linear-gradient(180deg, #f7f9fc 0%, var(--bg-base) 100%);
        font-family: 'Noto Sans KR', sans-serif;
        color: var(--text-main);
    }

    .outer {
        width: min(1260px, 95%);
        margin: 0 auto;
        padding: 18px 0 30px;
    }

    .main-panel {
        background-color: var(--panel-bg);
        border: 1px solid var(--panel-border);
        border-radius: 16px;
        padding: 18px;
        box-shadow: 0 8px 26px rgba(21, 40, 70, 0.08);
    }

    #search-area input[type="search"] {
        width: 320px;
        height: 38px;
        border: 1px solid #cbd5e1;
        border-radius: 8px;
        padding: 0 12px;
        font-size: 14px;
        color: var(--text-main);
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

    .assignment-toolbar {
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

    .top-controls {
        display: flex;
        justify-content: space-between;
        gap: 16px;
        align-items: center;
        margin-bottom: 16px;
        flex-wrap: wrap;
    }

    .course-section {
        margin-bottom: 18px;
    }

    .course-header {
        display: inline-block;
        background: linear-gradient(90deg, var(--brand-700), var(--brand-500));
        color: #ffffff;
        padding: 7px 14px;
        font-size: 14px;
        font-weight: 800;
        border-radius: 8px;
        letter-spacing: 0.2px;
        margin-bottom: 10px;
        box-shadow: 0 4px 12px rgba(29, 56, 93, 0.2);
    }

    .course-assignments {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .assignment-card {
        border: 1px solid var(--card-border);
        border-radius: 16px;
        padding: 14px 16px;
        cursor: pointer;
        background-color: #ffffff;
        transition: border-color 0.16s ease, background-color 0.16s ease, box-shadow 0.16s ease, transform 0.16s ease;
    }

    .assignment-card:hover {
        border-color: #becce0;
        background-color: var(--card-hover);
        box-shadow: 0 6px 16px rgba(27, 45, 72, 0.09);
        transform: translateY(-1px);
    }

    .assignment-card.expanded {
        border-color: #9fb5d4;
        background-color: #fbfdff;
    }

    .assignment-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 16px;
    }

    .assignment-main {
        flex: 1;
        min-width: 0;
    }

    .assignment-meta {
        display: flex;
        gap: 7px;
        flex-wrap: wrap;
        margin-bottom: 8px;
    }

    .meta-chip {
        font-size: 12px;
        padding: 4px 10px;
        border: 1px solid var(--chip-border);
        color: #344055;
        background-color: var(--chip-bg);
        border-radius: 999px;
        font-weight: 600;
    }

    .assignment-title {
        font-size: 15px;
        font-weight: 800;
        color: var(--text-main);
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .assignment-description {
        display: none;
        margin-top: 10px;
        padding-top: 10px;
        border-top: 1px dashed #cfd9e7;
        font-size: 13px;
        line-height: 1.6;
        color: #425267;
        white-space: normal;
        word-break: break-word;
    }

    .score-bubble {
        width: 120px;
        min-height: 88px;
        border-radius: 14px;
        background: linear-gradient(180deg, #f4f7fb 0%, #e8edf5 100%);
        border: 1px solid #d1dae8;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        text-align: center;
        flex-shrink: 0;
        padding: 10px 8px;
        cursor: pointer;
        transition: transform 0.14s ease, box-shadow 0.14s ease;
    }

    .score-bubble:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 10px rgba(43, 67, 103, 0.18);
    }

    .score-value {
        margin-top: 4px;
        font-size: 14px;
        font-weight: 800;
        color: #17263d;
    }

    .score-state {
        margin-top: 3px;
        font-size: 11px;
        font-weight: 800;
    }

    .score-state.done {
        color: var(--ok);
    }

    .score-state.pending {
        color: var(--wait);
    }

    .score-state.before {
        color: #6b7280;
    }

    .score-action {
        margin-top: 7px;
        padding: 3px 8px;
        border-radius: 999px;
        background: #dce6f5;
        color: #24364f;
        font-size: 11px;
        font-weight: 800;
        letter-spacing: 0.2px;
    }

    .assignment-submit-modal .modal-dialog {
        max-width: 760px;
    }

    .assignment-submit-modal .modal-content {
        border: 1px solid #d8e0ec;
        border-radius: 16px;
        box-shadow: 0 20px 40px rgba(28, 47, 75, 0.2);
        overflow: hidden;
    }

    .assignment-submit-modal .modal-header {
        border-bottom: 1px solid #e2e8f3;
        background: #f7f9fc;
        padding: 14px 18px;
    }

    .assignment-submit-modal .modal-title {
        font-size: 16px;
        font-weight: 800;
        color: #1f3556;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .assignment-submit-modal .modal-body {
        padding: 18px;
        background: #ffffff;
    }

    .modal-chip {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 999px;
        border: 1px solid #d7e1ef;
        background: #f2f6fc;
        color: #344055;
        font-size: 12px;
        font-weight: 700;
    }

    .submit-assignment-title {
        margin-top: 10px;
        font-size: 18px;
        font-weight: 800;
        color: #1f2937;
    }

    .modal-form-label {
        font-size: 13px;
        font-weight: 700;
        color: #334155;
        margin-bottom: 8px;
    }

    .assignment-submit-modal textarea,
    .assignment-submit-modal .custom-file-label {
        border: 1px solid #d2dbe9;
        border-radius: 10px;
    }

    .assignment-submit-modal textarea:focus,
    .assignment-submit-modal .custom-file-input:focus ~ .custom-file-label {
        border-color: var(--brand-500);
        box-shadow: 0 0 0 3px rgba(47, 76, 120, 0.14);
    }

    .assignment-submit-modal .modal-footer {
        border-top: 1px solid #e2e8f3;
        background: #f8fafc;
        padding: 14px 18px;
    }

    .submit-btn {
        width: 100%;
        background: var(--brand-700);
        border: 0;
        border-radius: 10px;
        color: #ffffff;
        font-size: 14px;
        font-weight: 800;
        padding: 11px;
    }

    .submit-btn:hover {
        background: #18304f;
    }

    #empty-message,
    #loading-area {
        display: none;
        text-align: center;
        color: var(--text-sub);
        padding: 18px 0;
    }

    @media (max-width: 900px) {
        .main-panel {
            border-radius: 12px;
            padding: 14px;
        }

        #search-area input[type="search"] {
            width: 220px;
        }

        .assignment-card {
            border-radius: 12px;
            padding: 12px;
        }

        .assignment-row {
            align-items: flex-start;
        }

        .score-bubble {
            width: 102px;
            min-height: 78px;
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

        .assignment-row {
            flex-direction: column;
            gap: 10px;
        }

        .score-bubble {
            width: 100%;
            min-height: 62px;
            border-radius: 10px;
        }
    }
</style>
</head>
<body>

    <jsp:include page="../common/mainMenubar.jsp" />
    <jsp:include page="../common/dateFormatUtil.jsp" />

    <div class="outer">
        <div class="main-panel">
            <div class="top-controls">
                <div id="search-area" align="left">
                    <form action="/blueming/assignment/list" method="get">
                        <input type="search" name="keyword" value="${keyword}" id = "keyword-input" placeholder="과제명/강의명/챕터명 검색" maxlength="100">
                        <input type="hidden" name="targetType" value="${targetType}" id="targetType-hidden-input">
                        <input type="hidden" name="mineOnly" value="${mineOnly}" id="mineOnly-hidden-input">
                        <button type="submit" class="btn btn-primary">검색</button>
                    </form>
                </div>

                <!-- 강의명 순 / 마감일 가까운 순 -->
                <div class="assignment-toolbar">
                    <c:if test="${sessionScope.loginUser.role eq 'S'}">
                        <label class="mine-toggle" for="mine-only-checkbox">
                            <input type="checkbox" id="mine-only-checkbox" value="true" ${mineOnly ? 'checked' : ''}>
                            내 강의만 보기
                        </label>
                    </c:if>
                    <button type="button" class="sort-btn" data-sort="cName" id="sort-latest">강의명순</button>
                    <span class="sort-divider">/</span>
                    <button type="button" class="sort-btn" data-sort="deadline" id="sort-deadline">마감일 가까운순</button>
                </div>
            </div>

            <div id="assignment-grid"></div>
            <div id="empty-message">검색 결과가 없습니다.</div>
            <div id="loading-area">불러오는 중...</div>
        </div>
    </div>

    <div class="modal fade assignment-submit-modal" id="assignmentSubmitModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">과제 제출</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="modal-chip" id="submit-modal-chapter">챕터: -</div>
                    <div class="submit-assignment-title" id="submit-modal-title">과제 이름</div>

                    <input type="hidden" id="submit-assignment-id">

                    <div class="form-group mt-4">
                        <label class="modal-form-label" for="submit-content">제출 내용</label>
                        <textarea id="submit-content" class="form-control" rows="4" placeholder="과제 제출 내용을 입력하세요." maxlength="2000"></textarea>
                    </div>

                    <div class="form-group">
                        <label class="modal-form-label" for="submit-file">첨부 파일</label>
                        <div id="submit-existing-file" class="text-muted mb-2" style="font-size:12px; display:none;"></div>
                        <div class="custom-file">
                            <input type="file" class="custom-file-input" id="submit-file">
                            <label class="custom-file-label" for="submit-file" id="submit-file-label">파일 선택</label>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="submit-btn" id="submit-assignment-btn">제출</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        let currentPage = 1;
        const limit = 8;
        let isLoading = false;
        let hasMore = true;
        let loadedCount = 0;
        let activeRequest = null;
        const keyword = ($('#keyword-input').val() || '').trim();
        let targetType = "${empty targetType ? 'cName' : targetType}";
        let mineOnly = "${mineOnly}" === "true";

        function applySortButtonState() {
            $(".sort-btn").removeClass("active");
            $(".sort-btn[data-sort='" + targetType + "']").addClass("active");
            $("#targetType-hidden-input").val(targetType);
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

        function formatDescription(description) {
            if (!description) {
                return "과제 설명이 등록되지 않았습니다.";
            }

            return escapeHtml(String(description)).replace(/\n/g, "<br>");
        }

        function openAssignmentSubmitModal(assignment) {
            $("#submit-assignment-id").val(assignment.assignmentId);
            $("#submit-modal-title").text(assignment.assignmentTitle || "과제 이름");
            $("#submit-modal-chapter").text("챕터: " + (assignment.chapterTitle || "챕터 미지정"));
            $("#submit-content").val(assignment.submittedContent || "");
            $("#submit-file").val("");
            $("#submit-file-label").text("파일 선택");

            if (assignment.submittedFileName) {
                $("#submit-existing-file")
                    .text("기존 첨부파일: " + assignment.submittedFileName + " (새 파일 선택 시 교체)")
                    .show();
            } else {
                $("#submit-existing-file").hide().text("");
            }

            $("#assignmentSubmitModal").modal("show");
        }

        /*
            과제명
            강의명
            기한
            점수
        */
        function getOrCreateCourseSection(courseId, courseTitle) {
            const sectionId = "course-section-" + courseId;
            let $section = $("#" + sectionId);

            if ($section.length === 0) {
                const sectionStr = "<div class='course-section' id='" + sectionId + "'>"
                                 + "<div class='course-header'>" + courseTitle + "</div>"
                                 + "<div class='course-assignments'></div>"
                                 + "</div>";
                $("#assignment-grid").append(sectionStr);
                $section = $("#" + sectionId);
            }

            return $section.find(".course-assignments");
        }

        function renderScore(submissionId, score, maxScore) {
            if (submissionId == null) {
                return {
                    scoreValue: "- / " + maxScore,
                    scoreState: "제출 전",
                    scoreStateClass: "before",
                    actionLabel: "제출하기"
                };
            }

            if (score == null) {
                return {
                    scoreValue: "- / " + maxScore,
                    scoreState: "채점 전",
                    scoreStateClass: "pending",
                    actionLabel: "수정하기"
                };
            }

            return {
                scoreValue: score + " / " + maxScore,
                scoreState: "채점 완료",
                scoreStateClass: "done",
                actionLabel: "재제출"
            };
        }

        function appendAssignmentCards(list) {
            for (let i = 0; i < list.length; i++) {
                const assignment = list[i];
                const courseId = assignment.courseId;
                const courseTitle = escapeHtml(assignment.courseTitle || "강의 미지정");
                const chapterTitle = escapeHtml(assignment.chapterTitle || "챕터 미지정");
                const title = escapeHtml(assignment.assignmentTitle);
                const startDate = escapeHtml(formatDateOnlyKst(assignment.startDate));
                const dueDate = escapeHtml(formatDateOnlyKst(assignment.dueDate));
                const maxScore = escapeHtml(String(assignment.maxScore));
                const scoreMeta = renderScore(assignment.submissionId, assignment.score, maxScore);
                const description = formatDescription(assignment.description);
                const cardStr = "<div class='assignment-card' data-assignment-id='" + assignment.assignmentId + "'>"
                              + "<div class='assignment-row'>"
                              + "<div class='assignment-main'>"
                              + "<div class='assignment-meta'>"
                              + "<span class='meta-chip'>챕터: " + chapterTitle + "</span>"
                              + "<span class='meta-chip'>기간: " + startDate + " ~ " + dueDate + "</span>"
                              + "</div>"
                              + "<div class='assignment-title'>" + title + "</div>"
                              + "<div class='assignment-description'>" + description + "</div>"
                              + "</div>"
                              + "<div class='score-bubble'>"
                              + "<div class='score-value'>" + scoreMeta.scoreValue + "</div>"
                              + "<div class='score-state " + scoreMeta.scoreStateClass + "'>" + scoreMeta.scoreState + "</div>"
                              + "<div class='score-action'>" + scoreMeta.actionLabel + "</div>"
                              + "</div>"
                              + "</div>"
                              + "</div>";

                getOrCreateCourseSection(courseId, courseTitle).append(cardStr);

                const $latestCard = getOrCreateCourseSection(courseId, courseTitle).children().last();
                $latestCard.find(".score-bubble").data("assignment", {
                    assignmentId: assignment.assignmentId,
                    assignmentTitle: assignment.assignmentTitle,
                    chapterTitle: assignment.chapterTitle,
                    submittedContent: assignment.submittedContent,
                    submittedFileName: assignment.submittedFileName
                });
            }
        }

        function loadAssignmentList() {
            if (isLoading || !hasMore) return;

            isLoading = true;
            $("#loading-area").show();

            let request = null;
            request = $.ajax({
                url: "/blueming/assignment/ajaxList",
                method: "get",
                data: {
                    page: currentPage,
                    limit: limit,
                    keyword: keyword,
                    targetType: targetType,
                    mineOnly: mineOnly
                },
                success : function(result) {
                    if (activeRequest !== request) {
                        return;
                    }

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
                error : function(xhr, textStatus) {
                    if (activeRequest !== request) {
                        return;
                    }

                    if (textStatus !== "abort") {
                        console.log("과제 목록 ajax 통신 실패");
                    }
                },
                complete : function() {
                    if (activeRequest !== request) {
                        return;
                    }

                    activeRequest = null;
                    isLoading = false;
                    $("#loading-area").hide();

                    if (hasMore && $(document).height() <= $(window).height()) {
                        loadAssignmentList();
                    }
                }
            });

            activeRequest = request;
        }

        $(function() {
            if (targetType !== "deadline") {
                targetType = "cName";
            }

            const $mineOnlyCheckbox = $("#mine-only-checkbox");
            if ($mineOnlyCheckbox.length > 0) {
                // Browser history navigation can restore checkbox UI state after render.
                // Prefer the actual checkbox state so UI and ajax filter stay consistent.
                mineOnly = $mineOnlyCheckbox.is(":checked");
                $mineOnlyCheckbox.prop("checked", mineOnly);
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

            $("#assignment-grid").on("click", ".assignment-card", function(e) {
                if ($(e.target).closest(".score-bubble").length > 0) {
                    return;
                }

                const $currentCard = $(this);
                const isExpanded = $currentCard.hasClass("expanded");

                $(".assignment-card.expanded").removeClass("expanded")
                    .find(".assignment-description").stop(true, true).slideUp(140);

                if (!isExpanded) {
                    $currentCard.addClass("expanded")
                        .find(".assignment-description").stop(true, true).slideDown(170);
                }
            });

            $("#assignment-grid").on("click", ".score-bubble", function(e) {
                e.stopPropagation();

                const assignmentInfo = $(this).data("assignment");
                if (!assignmentInfo) {
                    return;
                }

                openAssignmentSubmitModal(assignmentInfo);
            });

            $("#submit-file").on("change", function() {
                const fileName = this.files && this.files.length > 0 ? this.files[0].name : "파일 선택";
                $("#submit-file-label").text(fileName);
            });

            $("#submit-assignment-btn").on("click", function() {
                const assignmentId = $("#submit-assignment-id").val();
                const content = $("#submit-content").val().trim();
                const fileInput = $("#submit-file")[0];
                const hasFile = fileInput && fileInput.files && fileInput.files.length > 0;

                if (!assignmentId) {
                    alert("과제 정보가 올바르지 않습니다.");
                    return;
                }

                if (!content && !hasFile) {
                    alert("제출 내용 또는 첨부파일을 입력해주세요.");
                    $("#submit-content").focus();
                    return;
                }

                const formData = new FormData();
                formData.append("assignmentId", assignmentId);
                formData.append("content", content);
                if (hasFile) {
                    formData.append("upfile", fileInput.files[0]);
                }

                const $submitBtn = $(this);
                $submitBtn.prop("disabled", true).text("제출 중...");

                $.ajax({
                    url: "/blueming/assignment/submit",
                    method: "post",
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function(res) {
                        if (res && res.success) {
                            if (window.alertify && typeof window.alertify.success === "function") {
                                window.alertify.success(res.message || "과제가 제출되었습니다.");
                            } else {
                                alert(res.message || "과제가 제출되었습니다.");
                            }

                            $("#assignmentSubmitModal").modal("hide");
                            resetAndReload();
                        } else {
                            alert((res && res.message) ? res.message : "과제 제출에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("과제 제출 요청 중 오류가 발생했습니다.");
                    },
                    complete: function() {
                        $submitBtn.prop("disabled", false).text("제출");
                    }
                });
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