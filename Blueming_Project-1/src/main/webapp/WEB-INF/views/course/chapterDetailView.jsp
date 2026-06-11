<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>blueming</title>
            <link rel="stylesheet"
                href="https://cdn-uicons.flaticon.com/uicons-regular-rounded/css/uicons-regular-rounded.css">
            <link rel="stylesheet"
                href="https://cdn-uicons.flaticon.com/uicons-solid-rounded/css/uicons-solid-rounded.css">
            <style>
                .outer {
                    float: center;
                    margin: 20px;
                    margin-left: 270px;
                    width: 80%;
                }

                .assignment-empty {
                    text-align: center;
                    color: #666;
                    padding: 18px 0;
                }

                .assignment-actions {
                    display: flex;
                    justify-content: center;
                    gap: 8px;
                    flex-wrap: wrap;
                }

                .assignment-clickable {
                    cursor: pointer;
                }

                .assignment-clickable:hover {
                    background-color: #f8f9fa;
                }

                /* 영상 플레이어 */
                .video-section {
                    margin-bottom: 30px;
                }

                .player-shell {
                    background: linear-gradient(135deg, #121926 0%, #1f2d44 100%);
                    border-radius: 12px;
                    padding: 14px;
                    box-shadow: 0 10px 24px rgba(17, 25, 40, 0.24);
                }

                .video-section video {
                    width: 100%;
                    max-height: 480px;
                    background: #000;
                    border-radius: 8px;
                    display: block;
                }

                .video-section video:fullscreen {
                    width: 100vw;
                    height: 100vh;
                    max-height: none;
                    object-fit: contain;
                    border-radius: 0;
                }

                .video-section video:-webkit-full-screen {
                    width: 100vw;
                    height: 100vh;
                    max-height: none;
                    object-fit: contain;
                    border-radius: 0;
                }

                .player-controls {
                    margin-top: 10px;
                    display: flex;
                    flex-wrap: wrap;
                    gap: 8px;
                    align-items: center;
                }

                .control-btn {
                    border: 0;
                    border-radius: 8px;
                    background: rgba(255, 255, 255, 0.12);
                    color: #f0f6ff;
                    font-size: 13px;
                    padding: 7px 12px;
                    line-height: 1;
                    cursor: pointer;
                    transition: background 0.2s ease;
                }

                .control-btn.icon-btn {
                    width: 34px;
                    height: 34px;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    padding: 0;
                    font-size: 16px;
                }

                .control-btn.icon-btn i {
                    line-height: 1;
                }

                .control-btn:hover,
                .control-btn:focus {
                    background: rgba(255, 255, 255, 0.24);
                    outline: none;
                }

                .control-btn.is-active {
                    background: #2ca9e1;
                    color: #fff;
                }

                .speed-select {
                    border: 0;
                    border-radius: 8px;
                    background: rgba(255, 255, 255, 0.12);
                    color: #f0f6ff;
                    font-size: 13px;
                    padding: 7px 10px;
                    min-width: 84px;
                    cursor: pointer;
                }

                .speed-select:focus {
                    outline: none;
                    background: rgba(255, 255, 255, 0.24);
                }

                .speed-select option {
                    color: #111;
                }

                .volume-wrap {
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    min-width: 120px;
                }

                .volume-wrap input[type="range"] {
                    width: 90px;
                    accent-color: #2ca9e1;
                }

                .seek-wrap {
                    flex: 1 1 240px;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    min-width: 180px;
                }

                .seek-wrap input[type="range"] {
                    width: 100%;
                    accent-color: #2ca9e1;
                }

                .time-label {
                    color: #d9e4f7;
                    font-size: 12px;
                    min-width: 110px;
                    text-align: right;
                }

                .player-status {
                    margin-top: 8px;
                    color: #b6c8e2;
                    font-size: 12px;
                }

                @media (max-width: 768px) {
                    .player-shell {
                        padding: 10px;
                    }

                    .control-btn {
                        padding: 7px 10px;
                        font-size: 12px;
                    }

                    .time-label {
                        min-width: 96px;
                        font-size: 11px;
                    }
                }

                .progress-info {
                    margin-top: 8px;
                    font-size: 14px;
                    color: #555;
                }

                .progress-bar-wrap {
                    height: 8px;
                    background: #ddd;
                    border-radius: 4px;
                    margin-top: 4px;
                    overflow: hidden;
                }

                .progress-bar-fill {
                    height: 100%;
                    background: #5bc0de;
                    border-radius: 4px;
                    transition: width 0.3s;
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

                /* 댓글 영역 강제 노출 (기존 꼬인 display:none 무력화) */
                #replyList,
                #replyList * {
                    display: revert !important;
                }

                #replyList .card {
                    display: block !important;
                }

                #replyList .d-flex {
                    display: flex !important;
                    visibility: visible !important;
                    opacity: 1 !important;
                }
            </style>
        </head>

        <body>

            <jsp:include page="../common/mainMenubar.jsp" />

            <div class="outer">
                <div class="card mt-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h2 align="center">챕터 상세조회</h2>
                        <!-- 관리자에게만 보이는 버튼-->
                        <c:choose>
                            <c:when test="${ sessionScope.loginUser.role eq 'S' }">
                                <div align="center" class="d-flex justify-content-center gap-2">
                                    <button class="btn btn-warning mr-1" onclick="updateChapter();">
                                        챕터 수정
                                    </button>
                                    <form id="deleteForm" action="deleteChapter" method="post">
                                        <input type="hidden" name="chapterId" value="${chapter.chapterId}">
                                        <input type="hidden" name="videoFileId" value="${chapter.videoFileId}">
                                        <button type="button" class="btn btn-danger mr-1" onclick="chapterDelete();">
                                            챕터 삭제
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
                                <th>챕터명</th>
                                <td>${ requestScope.chapter.chapterTitle }</td>
                            </tr>
                            <tr>
                                <th>올린 날짜</th>
                                <td>${ requestScope.chapter.createDate }</td>
                            </tr>
                            <tr>
                                <th>업데이트 날짜</th>
                                <td>${ requestScope.chapter.updatedDate}</td>
                            </tr>
                        </table>
                    </div>
                </div>

                <!-- ====== 영상 플레이어 ====== -->
                <div class="card mt-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h2 align="center">강의 영상</h2>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty videoAttachment}">
                                <div class="video-section">

                                    <div class="player-shell" id="chapterPlayerShell">
                                        <video id="chapterVideo" preload="metadata"
                                            src="${pageContext.request.contextPath}/${videoAttachment.filePath}${videoAttachment.changedName}">
                                            브라우저가 video 태그를 지원하지 않습니다.
                                        </video>
                                        <div class="player-controls" id="playerControls" aria-label="동영상 제어 패널">
                                            <button type="button" class="control-btn icon-btn" id="btnPlayPause"
                                                aria-label="재생 또는 일시정지">
                                                <i class="fi fi-sr-play"></i>
                                            </button>
                                            <button type="button" class="control-btn" id="btnRewind">-10초</button>
                                            <button type="button" class="control-btn" id="btnForward">+10초</button>
                                            <div class="seek-wrap">
                                                <input type="range" id="videoSeekBar" min="0" max="100" step="0.1"
                                                    value="0" aria-label="재생 위치">
                                                <span class="time-label" id="videoTimeLabel">00:00 / 00:00</span>
                                            </div>
                                            <select id="speedSelect" class="speed-select" aria-label="재생속도 선택">
                                                <option value="0.75">0.75x</option>
                                                <option value="1" selected>1.0x</option>
                                                <option value="1.25">1.25x</option>
                                                <option value="1.5">1.5x</option>
                                                <option value="2">2.0x</option>
                                            </select>
                                            <div class="volume-wrap">
                                                <button type="button" class="control-btn icon-btn" id="btnMuteToggle"
                                                    aria-label="음소거 전환">
                                                    <i class="fi fi-rr-volume"></i>
                                                </button>
                                                <input type="range" id="volumeSlider" min="0" max="1" step="0.01"
                                                    value="1" aria-label="볼륨 조절">
                                            </div>
                                            <button type="button" class="control-btn icon-btn" id="btnFullscreen"
                                                aria-label="전체화면">
                                                <i class="fi fi-rr-arrow-up-right-and-arrow-down-left-from-center"></i>
                                            </button>
                                        </div>
                                        <div class="player-status" id="playerStatus">준비됨</div>
                                    </div>
                                    <c:if test="${enrollmentId > 0}">
                                        <div class="progress-info">
                                            <span>수강률: <strong id="compRateDisplay">${not empty existingProgress ?
                                                    existingProgress.chapCompRate : 0}</strong>%</span>
                                            <c:if
                                                test="${not empty existingProgress and existingProgress.isCompleted eq 'Y'}">
                                                <span class="label label-success" style="margin-left:8px;">이수 완료</span>
                                            </c:if>
                                        </div>
                                        <div class="progress-bar-wrap">
                                            <div class="progress-bar-fill" id="compRateBar"
                                                data-rate="${not empty existingProgress ? existingProgress.chapCompRate : 0}">
                                            </div>
                                        </div>
                                    </c:if>
                                    <c:if test="${enrollmentId <= 0}">
                                        <p class="text-muted" style="margin-top:6px;font-size:13px;">※ 수강 신청 후 진도가
                                            저장됩니다.</p>
                                    </c:if>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info" align="center">등록된 강의 영상이 없습니다.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <!-- ====== /영상 플레이어 ====== -->

                <div class="card mt-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h2 align="center">과제 목록</h2>
                        <c:choose>
                            <c:when test="${ sessionScope.loginUser.role eq 'S' }">
                                <div align="center" class="d-flex justify-content-center gap-2">
                                    <button type="button" class="btn btn-primary mr-1" onclick="addAssignment();">
                                        과제 추가
                                    </button>
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
                        <table id="assignment-area" class="table">
                            <thead>
                                <tr>
                                    <th>과제명</th>
                                    <th>마감일</th>
                                    <c:if test="${sessionScope.loginUser.role eq 'S'}">
                                        <th>관리</th>
                                    </c:if>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty assignmentList}">
                                        <c:forEach var="assignment" items="${assignmentList}">
                                            <tr class="assignment-clickable"
                                                data-assignment-title="${assignment.assignmentTitle}"
                                                data-assignment-description="${assignment.description}"
                                                data-assignment-start-date="${assignment.startDate}"
                                                data-assignment-due-date="${assignment.dueDate}"
                                                data-assignment-max-score="${assignment.maxScore}">
                                                <td>${assignment.assignmentTitle}</td>
                                                <td>${assignment.dueDate}</td>
                                                <c:if test="${sessionScope.loginUser.role eq 'S'}">
                                                    <td>
                                                        <div class="assignment-actions">
                                                            <button type="button" class="btn btn-sm btn-primary"
                                                                onclick="">
                                                                채점
                                                            </button>
                                                            <button type="button" class="btn btn-sm btn-warning"
                                                                onclick="updateAssignment(${assignment.assignmentId});">
                                                                수정
                                                            </button>
                                                            <form action="/blueming/assignment/delete" method="post">
                                                                <input type="hidden" name="assignmentId"
                                                                    value="${assignment.assignmentId}">
                                                                <input type="hidden" name="chapterId"
                                                                    value="${chapter.chapterId}">
                                                                <button type="submit" class="btn btn-sm btn-danger"
                                                                    onclick="return confirm('정말로 과제를 삭제하시겠습니까?');">
                                                                    삭제
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </c:if>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td class="assignment-empty"
                                                colspan="${sessionScope.loginUser.role eq 'S' ? 3 : 2}">등록된 과제가 없습니다.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- 과제 목록 테이블 -->
                    <div class="modal fade" id="assignmentDetailModal" tabindex="-1" role="dialog" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="assignmentDetailTitle">과제 상세</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <table class="table">
                                        <tr>
                                            <th>과제명</th>
                                            <td id="modalAssignmentTitle"></td>
                                        </tr>
                                        <tr>
                                            <th>시작일</th>
                                            <td id="modalAssignmentStartDate"></td>
                                        </tr>
                                        <tr>
                                            <th>마감일</th>
                                            <td id="modalAssignmentDueDate"></td>
                                        </tr>
                                        <tr>
                                            <th>만점</th>
                                            <td id="modalAssignmentMaxScore"></td>
                                        </tr>
                                        <tr>
                                            <th>설명</th>
                                            <td id="modalAssignmentDescription"></td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card mt-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h2 align="center">댓글</h2>
                    </div>
                    <div class="card-body">
                        <input type="hidden" id="chapterId" value="${chapter.chapterId}">

                        <div id="replyList" style="max-width: 800px; margin: 0 auto; margin-bottom: 20px;"></div>

                        <div style="max-width: 800px; margin: 0 auto;">
                            <div class="input-group" style="display: flex; align-items: stretch; height: 45px;">
                                <input type="text" id="replyContent" class="form-control" placeholder="댓글을 입력해주세요..."
                                    style="border-radius: 6px 0 0 6px;">

                                <input type="file" id="replyFile" style="display: none;" onchange="showFileName(this)">

                                <button type="button" class="btn btn-outline-secondary"
                                    onclick="$('#replyFile').click();">파일 첨부</button>

                                <button type="button" id="insertReplyBtn" class="btn btn-primary"
                                    style="border-radius: 0 6px 6px 0; padding: 0 20px;">등록</button>
                            </div>

                            <div id="fileInfoArea"
                                style="margin-top: 8px; padding: 5px 10px; background-color: #f8f9fa; border-radius: 4px; display: none; align-items: center; justify-content: space-between; border: 1px solid #eee;">
                                <span id="fileName" style="font-size: 13px; color: #495057;">선택된 파일 없음</span>
                                <button type="button" class="btn btn-sm btn-link text-danger" onclick="clearFile()"
                                    style="padding: 0; font-size: 12px;">삭제</button>
                            </div>
                        </div>
                        <br><br>

                        <div style="margin-top:20px;">
                            <textarea id="replyContent" class="form-control" rows="3" placeholder="댓글을 입력해주세요."
                                maxlength="333"></textarea>
                            <br>

                            <div class="d-flex gap-2" style="display: flex !important;">
                                <button type="button" id="insertReplyBtn" class="btn btn-primary mr-2">
                                    댓글 등록
                                </button>

                                <button type="button" id="clearReplyBtn" class="btn btn-outline-secondary"
                                    onclick="$('#replyContent').val('');">
                                    작성 취소
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card mt-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h2 align="center">통계</h2>
                    </div>
                </div>
                <div class="card-body">
                    <!-- 총 이수율 -->
                    <div class="mb-5">
                        <h5>총 이수율</h5>
                        <input type="hidden" id="courseId" value="${chapter.courseId}">
                        <input type="hidden" id="chapterIdStat" value="${chapter.chapterId}">
                        <div class="progress" style="height: 30px;">
                            <div id="totalCourseProgressBar"
                                class="progress-bar progress-bar-striped bg-success progress-bar-animated rounded-pill"
                                role="progressbar" style="width: 0%;" data-rate="${chapter.avgProgress}">
                                <span align="center" class="text-small">${String.format("%.2f",
                                    chapter.avgProgress)}%</span>
                            </div>
                        </div>


                        <br>
                        <h5>총 과제 제출률</h5>
                        <div class="progress" style="height: 30px;">
                            <div id="totalAssignmentProgressBar"
                                class="progress-bar progress-bar-striped bg-danger progress-bar-animated rounded-pill"
                                role="progressbar" style="width: 0%;"
                                data-rate="${chapter.avgAssignmentSubmissionRate}">
                                <span align="center" class="text-small">${String.format("%.2f",
                                    chapter.avgAssignmentSubmissionRate)}%</span>
                            </div>
                        </div>
                        <br>
                    </div>
                </div>
            </div>
            </div>
            </div>


            <script>
                // 1. 파일 선택 시 이름 표시 (전역 함수 - 스크립트 최상단 배치)
                function showFileName(input) {
                    if (input.files && input.files[0]) {
                        $("#fileName").text(input.files[0].name);
                        $("#fileInfoArea").css("display", "flex");
                    }
                }

                // 2. 파일 삭제 (초기화)
                function clearFile() {
                    $("#replyFile").val("");
                    $("#fileName").text("선택된 파일 없음");
                    $("#fileInfoArea").hide();
                }

                // 3. 페이지 로드 시 단 1회만 호출
                $(function () {
                    loadReplyList();



                    // 등록 버튼 이벤트 등록 (중복 실행 방지)
                    $("#insertReplyBtn").off("click").on("click", function () {
                        const content = $("#replyContent").val();
                        const chapterId = $("#chapterId").val();
                        const file = $("#replyFile")[0].files[0];

                        if (!content.trim() && !file) {
                            alert("댓글 내용이나 파일을 선택해주세요.");
                            return;
                        }

                        let formData = new FormData();
                        formData.append("chapterId", chapterId);
                        formData.append("content", content);
                        if (file) formData.append("uploadFile", file);

                        $.ajax({
                            url: "${pageContext.request.contextPath}/reply/insert",
                            type: "post",
                            data: formData,
                            processData: false,
                            contentType: false,
                            success: function (result) {
                                if (result === "SUCCESS") {
                                    $("#replyContent").val("");
                                    clearFile();
                                    loadReplyList();
                                } else {
                                    alert("등록 실패");
                                }
                            },
                            error: function () { alert("서버 통신 오류"); }
                        });
                    });
                });

                // 4. 댓글 목록 조회
                function loadReplyList() {
                    $.ajax({
                        url: "${pageContext.request.contextPath}/reply/list",
                        type: "post",
                        data: { chapterId: $("#chapterId").val() },
                        success: function (list) {
                            console.log("서버에서 받은 댓글 리스트:", list);
                            let str = "";
                            const loginMemberId = "${sessionScope.loginUser.memberId}";
                            const loginUserRole = "${sessionScope.loginUser.role}";

                            for (let i = 0; i < list.length; i++) {
                                str += "<div class='card mb-2 reply-row' data-id='" + list[i].replyId + "'>";
                                str += "  <div class='card-body'>";
                                str += "    <b>" + list[i].name + "</b> (" + (list[i].deptName || '') + " " + (list[i].positionName || '') + ")<br>";
                                // loadReplyList 함수 내 for문 내부
                                str += "<p class='reply-content' style='margin-top:8px;'>" + list[i].content + "</p>";

                                // 🌟 파일명이 넘어왔다면 화면에 표시
                                if (list[i].originalName) {
                                    str += "<div style='margin-top:5px; font-size:12px; color:#007bff;'>"
                                        + "  <i class='fa fa-paperclip'></i> 📎 " + list[i].originalName
                                        + "</div>";
                                }
                                str += "    <textarea class='form-control edit-content' rows='2' style='display:none; margin-top:8px;'>" + list[i].content + "</textarea>";
                                str += "    <div style='display:flex; justify-content:space-between; align-items:center;'>";
                                str += "      <small class='text-muted'>" + list[i].createdDate + "</small>";
                                str += "      <div class='reply-btn-area'>";

                                if (loginMemberId == list[i].memberId) {
                                    str += "<button type='button' class='btn btn-sm btn-outline-warning btn-edit' onclick='showEditForm(this)'>수정</button> ";
                                    str += "<button type='button' class='btn btn-sm btn-outline-danger btn-delete' onclick='deleteReply(" + list[i].replyId + ")'>삭제</button> ";
                                    str += "<button type='button' class='btn btn-sm btn-success btn-save' style='display:none;' onclick='updateReply(this, " + list[i].replyId + ")'>저장</button> ";
                                    str += "<button type='button' class='btn btn-sm btn-secondary btn-cancel' style='display:none;' onclick='cancelEdit(this)'>취소</button>";
                                } else if (loginUserRole == 'S') {
                                    str += "<button type='button' class='btn btn-sm btn-danger btn-delete' onclick='deleteReply(" + list[i].replyId + ")'>관리자 삭제</button>";
                                }
                                str += "      </div>";
                                str += "    </div>";
                                str += "  </div>";
                                str += "</div>";
                            }
                            $("#replyList").html(str);
                        }
                    });
                }

                // 5. 수정/삭제/취소 기능 함수들
                function showEditForm(btn) {
                    const row = $(btn).closest('.reply-row');
                    row.find('.reply-content, .btn-edit, .btn-delete').hide();
                    row.find('.edit-content, .btn-save, .btn-cancel').show();
                }

                function cancelEdit(btn) {
                    const row = $(btn).closest('.reply-row');
                    row.find('.reply-content, .btn-edit, .btn-delete').show();
                    row.find('.edit-content, .btn-save, .btn-cancel').hide();
                    row.find('.edit-content').val(row.find('.reply-content').text());
                }

                function updateReply(btn, replyId) {
                    const row = $(btn).closest('.reply-row');
                    $.ajax({
                        url: "${pageContext.request.contextPath}/reply/update",
                        type: "post",
                        data: { replyId: replyId, content: row.find('.edit-content').val() },
                        success: function (res) { if (res == "SUCCESS" || res > 0) loadReplyList(); else alert("수정 실패"); }
                    });
                }

                function deleteReply(replyId) {
                    if (confirm("삭제하시겠습니까?")) {
                        $.ajax({
                            url: "${pageContext.request.contextPath}/reply/delete",
                            type: "post",
                            data: { replyId: replyId },
                            success: function (res) { if (res == "SUCCESS" || res > 0) loadReplyList(); else alert("삭제 실패"); }
                        });
                    }
                }





                $("#PostBtn").click(function () {
                    $("#DeptBtn").removeClass("btn-primary").addClass("btn-secondary");
                    $(this).removeClass("btn-secondary").addClass("btn-primary");
                });

                $("#DeptBtn").click(function () {
                    $("#PostBtn").removeClass("btn-primary").addClass("btn-secondary");
                    $(this).removeClass("btn-secondary").addClass("btn-primary");
                });

                $("#searchBtn").click(function () {

                    let positions = [];

                    $("input[name=position]:checked").each(function () {
                        positions.push($(this).val());
                    });

                    let departments = [];

                    $("input[name=department]:checked").each(function () {
                        departments.push($(this).val());
                    });

                    $.ajax({
                        url: "assignmentAverageFilter.ed",
                        type: "POST",
                        traditional: true,
                        data: {
                            positions: positions,
                            departments: departments
                        },
                        success: function (result) {
                            drawChart(result);
                        }
                    });

                });

                function onReady(fn) {
                    if (window.jQuery) {
                        window.jQuery(fn);
                        return;
                    }

                    if (document.readyState === "loading") {
                        document.addEventListener("DOMContentLoaded", fn);
                    } else {
                        fn();
                    }
                }

                const chartCanvas = document.getElementById('courseChart');
                if (chartCanvas && typeof Chart !== 'undefined') {
                    new Chart(chartCanvas, {
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
                }

                function chapterDelete() {
                    if (confirm("정말로 챕터를 삭제하시겠습니까?")) {
                        document.getElementById("deleteForm").submit();
                    }
                }

                function updateChapter() {
                    window.location.href = "updateChapterView?chapterId=${chapter.chapterId}";
                }

                function addAssignment() {
                    window.location.href = "/blueming/assignment/addView?chapterId=${chapter.chapterId}";
                }

                function updateAssignment(assignmentId) {
                    window.location.href = "/blueming/assignment/updateView?assignmentId=" + assignmentId;
                }

                onReady(function () {
                    // 초기 진도 바 너비 적용
                    const bar = document.getElementById("compRateBar");
                    if (bar) bar.style.width = (bar.dataset.rate || 0) + "%";

                    const totalCourseProgressBar = document.getElementById("totalCourseProgressBar");
                    if (totalCourseProgressBar) {
                        totalCourseProgressBar.style.width = (totalCourseProgressBar.dataset.rate || 0) + "%";
                    }

                    const totalAssignmentProgressBar = document.getElementById("totalAssignmentProgressBar");
                    if (totalAssignmentProgressBar) {
                        totalAssignmentProgressBar.style.width = (totalAssignmentProgressBar.dataset.rate || 0) + "%";
                    }

                    const playerShell = document.getElementById("chapterPlayerShell");
                    const btnPlayPause = document.getElementById("btnPlayPause");
                    const btnRewind = document.getElementById("btnRewind");
                    const btnForward = document.getElementById("btnForward");
                    const seekBar = document.getElementById("videoSeekBar");
                    const timeLabel = document.getElementById("videoTimeLabel");
                    const speedSelect = document.getElementById("speedSelect");
                    const btnMuteToggle = document.getElementById("btnMuteToggle");
                    const volumeSlider = document.getElementById("volumeSlider");
                    const btnFullscreen = document.getElementById("btnFullscreen");
                    const playerStatus = document.getElementById("playerStatus");

                    // ====== 영상 checkpoint 저장 ======
                    const video = document.getElementById("chapterVideo");
                    const enrollmentId = parseInt("${enrollmentId}") || 0;
                    const chapterId = parseInt("${chapter.chapterId}") || 0;

                    if (video) {
                        if (btnPlayPause && seekBar && timeLabel) {
                            video.removeAttribute("controls");

                            function formatTime(sec) {
                                const total = Math.max(0, Math.floor(sec || 0));
                                const min = Math.floor(total / 60);
                                const rem = total % 60;
                                return String(min).padStart(2, "0") + ":" + String(rem).padStart(2, "0");
                            }

                            function updateTimeline() {
                                const duration = Number.isFinite(video.duration) ? video.duration : 0;
                                const current = Number.isFinite(video.currentTime) ? video.currentTime : 0;

                                if (duration > 0) {
                                    seekBar.value = ((current / duration) * 100).toFixed(2);
                                } else {
                                    seekBar.value = 0;
                                }

                                timeLabel.textContent = formatTime(current) + " / " + formatTime(duration);
                            }

                            function updatePlayButton() {
                                btnPlayPause.innerHTML = video.paused
                                    ? '<i class="fi fi-sr-play"></i>'
                                    : '<i class="fi fi-sr-pause"></i>';

                                if (playerStatus) {
                                    playerStatus.textContent = video.paused
                                        ? "일시정지 · " + video.playbackRate.toFixed(2) + "x"
                                        : "재생 중 · " + video.playbackRate.toFixed(2) + "x";
                                }
                            }

                            function updateSpeedSelect() {
                                if (speedSelect) {
                                    speedSelect.value = String(video.playbackRate);
                                }
                            }

                            function updateVolumeUi() {
                                if (btnMuteToggle) {
                                    btnMuteToggle.innerHTML = (video.muted || video.volume === 0)
                                        ? '<i class="fi fi-rr-volume-mute"></i>'
                                        : '<i class="fi fi-rr-volume"></i>';
                                }

                                if (volumeSlider) {
                                    volumeSlider.value = String(video.volume);
                                }
                            }

                            btnPlayPause.addEventListener("click", function () {
                                if (video.paused) {
                                    video.play();
                                } else {
                                    video.pause();
                                }
                            });

                            if (btnRewind) {
                                btnRewind.addEventListener("click", function () {
                                    video.currentTime = Math.max(0, video.currentTime - 10);
                                });
                            }

                            if (btnForward) {
                                btnForward.addEventListener("click", function () {
                                    const duration = Number.isFinite(video.duration) ? video.duration : 0;
                                    const to = video.currentTime + 10;
                                    video.currentTime = duration > 0 ? Math.min(duration, to) : to;
                                });
                            }

                            seekBar.addEventListener("input", function () {
                                const duration = Number.isFinite(video.duration) ? video.duration : 0;
                                if (duration > 0) {
                                    video.currentTime = (parseFloat(seekBar.value) / 100) * duration;
                                }
                            });

                            if (speedSelect) {
                                speedSelect.addEventListener("change", function () {
                                    const rate = parseFloat(speedSelect.value) || 1;
                                    video.playbackRate = Math.min(rate, 2);
                                    updateSpeedSelect();
                                });
                            }

                            if (volumeSlider) {
                                volumeSlider.addEventListener("input", function () {
                                    const volume = Math.max(0, Math.min(1, parseFloat(volumeSlider.value) || 0));
                                    video.volume = volume;
                                    video.muted = volume === 0;
                                    updateVolumeUi();
                                });
                            }

                            if (btnMuteToggle) {
                                btnMuteToggle.addEventListener("click", function () {
                                    video.muted = !video.muted;
                                    if (!video.muted && video.volume === 0) {
                                        video.volume = 0.5;
                                    }
                                    updateVolumeUi();
                                });
                            }

                            if (btnFullscreen && playerShell) {
                                btnFullscreen.addEventListener("click", function () {
                                    const activeFullscreen = document.fullscreenElement || document.webkitFullscreenElement;

                                    if (activeFullscreen === video) {
                                        if (document.exitFullscreen) {
                                            document.exitFullscreen();
                                        } else if (document.webkitExitFullscreen) {
                                            document.webkitExitFullscreen();
                                        }
                                        return;
                                    }

                                    if (!activeFullscreen) {
                                        if (video.requestFullscreen) {
                                            video.requestFullscreen();
                                        } else if (video.webkitRequestFullscreen) {
                                            video.webkitRequestFullscreen();
                                        }
                                    }
                                });
                            }

                            if (playerShell) {
                                playerShell.addEventListener("keydown", function (e) {
                                    if (e.target && e.target.tagName === "INPUT") return;

                                    if (e.code === "Space") {
                                        e.preventDefault();
                                        btnPlayPause.click();
                                    } else if (e.code === "ArrowLeft") {
                                        e.preventDefault();
                                        if (btnRewind) btnRewind.click();
                                    } else if (e.code === "ArrowRight") {
                                        e.preventDefault();
                                        if (btnForward) btnForward.click();
                                    } else if (e.key && e.key.toLowerCase() === "f") {
                                        e.preventDefault();
                                        btnFullscreen.click();
                                    }
                                });
                                playerShell.tabIndex = 0;
                            }

                            video.addEventListener("timeupdate", updateTimeline);
                            video.addEventListener("loadedmetadata", updateTimeline);
                            video.addEventListener("play", updatePlayButton);
                            video.addEventListener("pause", updatePlayButton);
                            video.addEventListener("ratechange", function () {
                                updateSpeedSelect();
                                updatePlayButton();
                            });
                            video.addEventListener("volumechange", updateVolumeUi);
                            updateTimeline();
                            updateSpeedSelect();
                            updateVolumeUi();
                            updatePlayButton();
                        }

                        // 이전 시청 위치로 복원
                        const lastPos = parseFloat("${not empty existingProgress ? existingProgress.lastPositionSeconds : 0}") || 0;
                        if (lastPos > 1) {
                            video.addEventListener("loadedmetadata", function () {
                                video.currentTime = lastPos;
                            }, { once: true });
                        }

                        // 시청한 구간을 Set으로 추적 (1초 단위)
                        const watchedSet = new Set();
                        const savedWatchedSeconds = parseInt("${not empty existingProgress ? existingProgress.watchedSeconds : 0}") || 0;
                        let maxWatchedSeconds = Math.max(savedWatchedSeconds, Math.floor(lastPos));
                        let lastSentWatchedSeconds = savedWatchedSeconds;
                        let saveTimer = null;
                        let hasShownRateLimitNotice = false;

                        // 2배속 초과 재생은 인정하지 않으므로 즉시 제한
                        video.addEventListener("ratechange", function () {
                            if (video.playbackRate > 2) {
                                video.playbackRate = 2;
                                if (!hasShownRateLimitNotice) {
                                    alert("수강 인정은 최대 2배속까지 가능합니다.");
                                    hasShownRateLimitNotice = true;
                                }
                            }
                        });

                        // 본인이 시청한 범위를 넘어서는 점프 탐색은 차단
                        video.addEventListener("seeking", function () {
                            const allowedSeek = Math.min(maxWatchedSeconds + 1, Math.floor(video.duration) || 0);
                            if (video.currentTime > allowedSeek) {
                                video.currentTime = allowedSeek;
                            }
                        });

                        video.addEventListener("timeupdate", function () {
                            if (video.playbackRate > 2) {
                                return;
                            }

                            const cur = Math.floor(video.currentTime);
                            watchedSet.add(cur);

                            // 과거 구간으로 이동해도 누적 시청 시간은 감소하지 않도록 유지
                            maxWatchedSeconds = Math.max(maxWatchedSeconds, watchedSet.size);
                        });

                        // checkpoint 저장 주기 (부하를 줄이기 위해 10초)
                        saveTimer = window.setInterval(function () {
                            saveProgress(false);
                        }, 10000);

                        // 영상 종료 시 즉시 저장
                        video.addEventListener("ended", function () {
                            saveProgress(true);
                        });

                        // 페이지 떠날 때 저장
                        window.addEventListener("beforeunload", function () {
                            if (saveTimer) {
                                clearInterval(saveTimer);
                                saveTimer = null;
                            }
                            saveProgress(false);
                        });

                        function saveProgress(onEnded) {
                            const duration = Math.floor(video.duration) || 0;
                            const lastPos = Math.floor(video.currentTime);
                            const watched = onEnded ? duration : Math.max(maxWatchedSeconds, savedWatchedSeconds);

                            if (duration <= 0) return;
                            if (!onEnded && watched <= lastSentWatchedSeconds) return;

                            const prevSentWatchedSeconds = lastSentWatchedSeconds;
                            lastSentWatchedSeconds = watched;

                            $.ajax({
                                url: "${pageContext.request.contextPath}/course/saveProgress",
                                type: "POST",
                                data: {
                                    chapterId: chapterId,
                                    enrollmentId: enrollmentId,
                                    watchedSeconds: watched,
                                    lastPositionSeconds: lastPos,
                                    videoDuration: duration
                                },
                                success: function (res) {
                                    if (res.success) {
                                        const rate = parseFloat(res.chapCompRate).toFixed(2);
                                        $("#compRateDisplay").text(rate);
                                        $("#compRateBar").css("width", rate + "%");

                                        if (typeof res.watchedSeconds !== "undefined") {
                                            maxWatchedSeconds = Math.max(maxWatchedSeconds, parseInt(res.watchedSeconds) || 0);
                                            lastSentWatchedSeconds = Math.max(lastSentWatchedSeconds, maxWatchedSeconds);
                                        }
                                    } else if (res.message) {
                                        console.warn("progress save skipped:", res.message);
                                    }
                                },
                                error: function () {
                                    // 실패 시 재전송 기회를 위해 마지막 전송값 롤백
                                    lastSentWatchedSeconds = prevSentWatchedSeconds;
                                }
                            });
                        }
                    }
                    // ====== /영상 checkpoint 저장 ======

                    $("#assignment-area tbody").on("click", "tr.assignment-clickable", function () {
                        const title = $(this).data("assignment-title") || "";
                        const description = $(this).data("assignment-description") || "";
                        const startDate = $(this).data("assignment-start-date") || "";
                        const dueDate = $(this).data("assignment-due-date") || "";
                        const maxScore = $(this).data("assignment-max-score") || "";

                        $("#modalAssignmentTitle").text(title);
                        $("#modalAssignmentStartDate").text(startDate);
                        $("#modalAssignmentDueDate").text(dueDate);
                        $("#modalAssignmentMaxScore").text(maxScore);
                        $("#modalAssignmentDescription").text(description);

                        $("#assignmentDetailModal").modal("show");
                    });

                    $("#assignment-area tbody").on("click", ".assignment-actions button", function (e) {
                        e.stopPropagation();
                    });

                    $("#assignment-area tbody").on("click", ".assignment-actions form", function (e) {
                        e.stopPropagation();
                    });
                });

                // 1. 페이지 로드 시 댓글 목록 불러오기
                onReady(function () {
                    loadReplyList();
                });

                // 2. 댓글 목록 조회 및 동적 화면 구성 (수정/삭제 버튼 추가)
                // 댓글 목록 조회 및 동적 화면 구성 (관리자 권한 반영)
                function loadReplyList() {
                    $.ajax({
                        url: "${pageContext.request.contextPath}/reply/list",
                        type: "get",
                        data: {
                            chapterId: $("#chapterId").val()
                        },
                        success: function (list) {
                            let str = "";
                            const loginMemberId = "${sessionScope.loginUser.memberId}";
                            // 🌟 세션에서 로그인한 유저의 role 권한을 가져옵니다.
                            const loginUserRole = "${sessionScope.loginUser.role}";

                            for (let i = 0; i < list.length; i++) {
                                str += "<div class='card mb-2 reply-row' data-id='" + list[i].replyId + "'>";
                                str += "<div class='card-body'>";

                                // 작성자 정보
                                str += "<b>" + list[i].name + "</b>";
                                str += " (" + (list[i].deptName || '') + " " + (list[i].positionName || '') + ")<br>";

                                // [일반 모드] 댓글 내용
                                str += "<p class='reply-content' style='margin-top: 8px; margin-bottom: 8px;'>" + list[i].content + "</p>";

                                // [수정 모드] 텍스트 입력창 (처음에는 숨김)
                                str += "<textarea class='form-control edit-content' rows='2' style='display:none; margin-top: 8px; margin-bottom: 8px;'>" + list[i].content + "</textarea>";

                                // 작성일자 및 버튼 배치
                                str += "<div class='d-flex justify-content-between align-items-center' style='display: flex !important;'>";
                                str += "<small class='text-muted'>" + list[i].createdDate + "</small>";

                                str += "<div class='reply-btn-area'>";

                                // 🌟 권한 체크 분기 수정
                                if (loginMemberId == list[i].memberId) {
                                    // 1) 본인이 쓴 댓글일 때: 수정 / 삭제 모두 가능
                                    str += "<button type='button' class='btn btn-sm btn-outline-warning mr-1 btn-edit' onclick='showEditForm(this)'>수정</button>";
                                    str += "<button type='button' class='btn btn-sm btn-outline-danger btn-delete' onclick='deleteReply(" + list[i].replyId + ")'>삭제</button>";

                                    // 수정 모드 전용 버튼
                                    str += "<button type='button' class='btn btn-sm btn-success mr-1 btn-save' style='display:none;' onclick='updateReply(this, " + list[i].replyId + ")'>저장</button>";
                                    str += "<button type='button' class='btn btn-sm btn-secondary btn-cancel' style='display:none;' onclick='cancelEdit(this)'>취소</button>";
                                } else if (loginUserRole == 'S') {
                                    // 2) 본인 글은 아니지만, 로그인한 사람이 관리자('S')일 때: [삭제] 버튼만 노출
                                    str += "<button type='button' class='btn btn-sm btn-danger btn-delete' onclick='deleteReply(" + list[i].replyId + ")'>관리자 삭제</button>";
                                }

                                str += "</div>"; // reply-btn-area end
                                str += "</div>"; // d-flex end
                                str += "</div>"; // card-body end
                                str += "</div>"; // card end
                            }

                            $("#replyList").html(str);
                        }
                    });
                }

                // 3. [수정] 버튼 클릭 시 -> 입력 UI로 전환
                function showEditForm(btn) {
                    const row = $(btn).closest('.reply-row');
                    row.find('.reply-content').hide();        // 기존 텍스트 숨기기
                    row.find('.edit-content').show();         // 편집 창 보이기

                    row.find('.btn-edit, .btn-delete').hide(); // 기본 버튼 숨기기
                    row.find('.btn-save, .btn-cancel').show(); // 저장/취소 버튼 보이기
                }

                // 4. [취소] 버튼 클릭 시 -> 원상 복구
                function cancelEdit(btn) {
                    const row = $(btn).closest('.reply-row');
                    row.find('.reply-content').show();
                    row.find('.edit-content').hide();

                    row.find('.btn-edit, .btn-delete').show();
                    row.find('.btn-save, .btn-cancel').hide();

                    // 수정하던 텍스트는 다시 원래 내용으로 초기화
                    const originalContent = row.find('.reply-content').text();
                    row.find('.edit-content').val(originalContent);
                }

                // 5. [저장] 버튼 클릭 시 -> 수정(Update) Ajax 실행
                function updateReply(btn, replyId) {
                    const row = $(btn).closest('.reply-row');
                    const content = row.find('.edit-content').val();

                    if (!content.trim()) {
                        alert("수정할 내용을 입력해주세요.");
                        return;
                    }

                    $.ajax({
                        url: "${pageContext.request.contextPath}/reply/update",
                        type: "post",
                        data: {
                            replyId: replyId,
                            content: content
                        },
                        // 수정 Ajax의 success 부분도 똑같이 적용해 주세요
                        success: function (result) {
                            if (result == "SUCCESS" || result > 0 || result == "1") {
                                alert("댓글이 수정되었습니다.");
                                loadReplyList();
                            } else {
                                alert("댓글 수정 실패");
                            }
                        },
                        error: function () {
                            alert("댓글 수정 중 오류가 발생했습니다.");
                        }
                    });
                }

                // [삭제] 버튼 클릭 시 -> 삭제(Delete) Ajax 실행
                function deleteReply(replyId) {
                    if (confirm("정말로 이 댓글을 삭제하시겠습니까?")) {
                        $.ajax({
                            url: "${pageContext.request.contextPath}/reply/delete",
                            type: "post",
                            data: {
                                replyId: replyId
                            },
                            success: function (result) {
                                // 🌟 핵심 수정: result가 문자열 "SUCCESS" 이거나, 
                                // 숫자로 0보다 큰 값(성공 행의 개수 1)이 들어오면 모두 성공으로 인정합니다.
                                if (result == "SUCCESS" || result > 0 || result == "1") {
                                    alert("댓글이 삭제되었습니다.");
                                    loadReplyList(); // 새로고침 없이 비동기로 리스트를 다시 그려줍니다!
                                } else {
                                    alert("댓글 삭제 실패");
                                }
                            },
                            error: function () {
                                alert("댓글 삭제 중 오류가 발생했습니다.");
                            }
                        });
                    }
                }

                // 7. 기존 댓글 작성 기능 (성공 리턴값 매칭 수정 가능성 고려)
                $("#insertReplyBtn").click(function () {
                    const content = $("#replyContent").val();
                    if (!content.trim()) {
                        alert("댓글 내용을 입력해주세요.");
                        return;
                    }

                    $.ajax({
                        url: "${pageContext.request.contextPath}/reply/insert",
                        type: "post",
                        data: {
                            chapterId: $("#chapterId").val(),
                            content: content
                        },
                        success: function (result) {
                            // 기존 백엔드가 정수형(1) 혹은 "SUCCESS" 문자열을 주는지 확인하여 분기 처리
                            if (result == "SUCCESS" || result > 0) {
                                $("#replyContent").val("");
                                loadReplyList();
                            } else {
                                alert("댓글 등록 실패");
                            }
                        }
                    });
                });



            </script>
        </body>

        </html>