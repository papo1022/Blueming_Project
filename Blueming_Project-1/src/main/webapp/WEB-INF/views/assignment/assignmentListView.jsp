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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/assignment/assignmentListView.css">
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