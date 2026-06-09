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

    .video-section video {
        width: 100%;
        max-height: 480px;
        background: #000;
        border-radius: 4px;
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
                            
                            <video id="chapterVideo" controls preload="metadata"
                                src="${pageContext.request.contextPath}/${videoAttachment.filePath}${videoAttachment.changedName}">
                                브라우저가 video 태그를 지원하지 않습니다.
                            </video>
                            <c:if test="${enrollmentId > 0}">
                                <div class="progress-info">
                                    <span>수강률: <strong id="compRateDisplay">${not empty existingProgress ? existingProgress.chapCompRate : 0}</strong>%</span>
                                    <c:if test="${not empty existingProgress and existingProgress.isCompleted eq 'Y'}">
                                        <span class="label label-success" style="margin-left:8px;">이수 완료</span>
                                    </c:if>
                                </div>
                                <div class="progress-bar-wrap">
                                    <div class="progress-bar-fill" id="compRateBar"
                                        data-rate="${not empty existingProgress ? existingProgress.chapCompRate : 0}"></div>
                                </div>
                            </c:if>
                            <c:if test="${enrollmentId <= 0}">
                                <p class="text-muted" style="margin-top:6px;font-size:13px;">※ 수강 신청 후 진도가 저장됩니다.</p>
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
                                                    <button type="button" class="btn btn-sm btn-primary" onclick="">
                                                        채점
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-warning" onclick="updateAssignment(${assignment.assignmentId});">
                                                        수정
                                                    </button>
                                                    <form action="/blueming/assignment/delete" method="post">
                                                        <input type="hidden" name="assignmentId" value="${assignment.assignmentId}">
                                                        <input type="hidden" name="chapterId" value="${chapter.chapterId}">
                                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('정말로 과제를 삭제하시겠습니까?');">
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
                                    <td class="assignment-empty" colspan="${sessionScope.loginUser.role eq 'S' ? 3 : 2}">등록된 과제가 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
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
        
        
        <br><br><br><br>
        
       <br><br>

<h2 align="center">댓글</h2>

<input type="hidden"
       id="chapterId"
       value="${chapter.chapterId}">

<div id="replyList"></div>

<div style="margin-top:20px;">
    <textarea id="replyContent"
              class="form-control"
              rows="3"></textarea>

    <br>

    <button type="button"
            id="insertReplyBtn"
            class="btn btn-primary">
        댓글 등록
    </button>
</div>

<br><br>
        
        <br><br><br><br>
        

        <div class="card mt-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h2 align="center">통계</h2>   
            </div>
            <div class="card-body">
            
            </div>

    </div>
    
    
    

    <script>
        function chapterDelete(){
            if(confirm("정말로 챕터를 삭제하시겠습니까?")){
                document.getElementById("deleteForm").submit();
            }
        }

        function updateChapter(){
            window.location.href = "updateChapterView?chapterId=${chapter.chapterId}";
        }

        function addAssignment() {
            window.location.href = "/blueming/assignment/addView?chapterId=${chapter.chapterId}";
        }

        function updateAssignment(assignmentId) {
            window.location.href = "/blueming/assignment/updateView?assignmentId=" + assignmentId;
        }

        $(function() {
            // 초기 진도 바 너비 적용
            const bar = document.getElementById("compRateBar");
            if (bar) bar.style.width = (bar.dataset.rate || 0) + "%";

            // ====== 영상 checkpoint 저장 ======
            const video = document.getElementById("chapterVideo");
            const enrollmentId = parseInt("${enrollmentId}") || 0;
            const chapterId = parseInt("${chapter.chapterId}") || 0;

            if (video) {
                // 이전 시청 위치로 복원
                const lastPos = parseFloat("${not empty existingProgress ? existingProgress.lastPositionSeconds : 0}") || 0;
                if (lastPos > 1) {
                    video.addEventListener("loadedmetadata", function() {
                        video.currentTime = lastPos;
                    }, {once: true});
                }

                // 시청한 구간을 Set으로 추적 (1초 단위)
                const watchedSet = new Set();
                const savedWatchedSeconds = parseInt("${not empty existingProgress ? existingProgress.watchedSeconds : 0}") || 0;
                let maxWatchedSeconds = Math.max(savedWatchedSeconds, Math.floor(lastPos));
                let lastSentWatchedSeconds = savedWatchedSeconds;
                let saveTimer = null;
                let hasShownRateLimitNotice = false;

                // 2배속 초과 재생은 인정하지 않으므로 즉시 제한
                video.addEventListener("ratechange", function() {
                    if (video.playbackRate > 2) {
                        video.playbackRate = 2;
                        if (!hasShownRateLimitNotice) {
                            alert("수강 인정은 최대 2배속까지 가능합니다.");
                            hasShownRateLimitNotice = true;
                        }
                    }
                });

                // 본인이 시청한 범위를 넘어서는 점프 탐색은 차단
                video.addEventListener("seeking", function() {
                    const allowedSeek = Math.min(maxWatchedSeconds + 1, Math.floor(video.duration) || 0);
                    if (video.currentTime > allowedSeek) {
                        video.currentTime = allowedSeek;
                    }
                });

                video.addEventListener("timeupdate", function() {
                    if (video.playbackRate > 2) {
                        return;
                    }

                    const cur = Math.floor(video.currentTime);
                    watchedSet.add(cur);

                    // 과거 구간으로 이동해도 누적 시청 시간은 감소하지 않도록 유지
                    maxWatchedSeconds = Math.max(maxWatchedSeconds, watchedSet.size);
                });

                // checkpoint 저장 주기 (부하를 줄이기 위해 10초)
                saveTimer = window.setInterval(function() {
                    saveProgress(false);
                }, 10000);

                // 영상 종료 시 즉시 저장
                video.addEventListener("ended", function() {
                    saveProgress(true);
                });

                // 페이지 떠날 때 저장
                window.addEventListener("beforeunload", function() {
                    if (saveTimer) {
                        clearInterval(saveTimer);
                        saveTimer = null;
                    }
                    saveProgress(false);
                });

                function saveProgress(onEnded) {
                    const duration = Math.floor(video.duration) || 0;
                    const lastPos  = Math.floor(video.currentTime);
                    const watched  = onEnded ? duration : Math.max(maxWatchedSeconds, savedWatchedSeconds);

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
                        success: function(res) {
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
                        error: function() {
                            // 실패 시 재전송 기회를 위해 마지막 전송값 롤백
                            lastSentWatchedSeconds = prevSentWatchedSeconds;
                        }
                    });
                }
            }
            // ====== /영상 checkpoint 저장 ======

            $("#assignment-area tbody").on("click", "tr.assignment-clickable", function() {
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

            $("#assignment-area tbody").on("click", ".assignment-actions button", function(e) {
                e.stopPropagation();
            });

            $("#assignment-area tbody").on("click", ".assignment-actions form", function(e) {
                e.stopPropagation();
            });
        });
        
        // 댓글 추가기능
        
        $(function(){

            loadReplyList();

        });
        
        
        function loadReplyList(){

            $.ajax({

                url : "${pageContext.request.contextPath}/reply/list",

                type : "get",

                data : {
                    chapterId : $("#chapterId").val()
                },

                success : function(list){

                    let str = "";

                    for(let i=0; i<list.length; i++){

                        str += "<div class='card mb-2'>";
                        str += "<div class='card-body'>";

                        str += "<b>" + list[i].name + "</b>";

                        str += " (" +
                               (list[i].deptName || '') +
                               " " +
                               (list[i].positionName || '') +
                               ")<br>";

                        str += list[i].content + "<br>";

                        str += "<small>"
                            + list[i].createdDate
                            + "</small>";

                        str += "</div>";
                        str += "</div>";
                    }

                    $("#replyList").html(str);

                }

            });

        }
        
        
        $("#insertReplyBtn").click(function(){

            $.ajax({

                url : "${pageContext.request.contextPath}/reply/insert",

                type : "post",

                data : {

                    chapterId : $("#chapterId").val(),

                    content : $("#replyContent").val()

                },

                success : function(result){

                    if(result == "SUCCESS"){

                        $("#replyContent").val("");

                        loadReplyList();

                    }else{

                        alert("댓글 등록 실패");

                    }

                }

            });

        });
        
        
        
    </script>
</body>
</html>