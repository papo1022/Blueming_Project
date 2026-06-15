<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="/blueming/resources/css/course/reply.css">
<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/uicons-regular-rounded/css/uicons-regular-rounded.css">
<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/uicons-solid-rounded/css/uicons-solid-rounded.css">




<div class="reply-header-bg">
    <h3>댓글 (<span id="replyCount">0</span>)</h3>
</div>

<table class="reply-list-table">
    <tbody id="replyBody">
        </tbody>
</table>

<div class="area">
    <textarea id="mainReplyContent" rows="3" style="width:100%; resize:none; padding:10px;" placeholder="댓글을 입력하세요."></textarea>
    
    <div class="reply-controls">
        <div class="top-row">
            <label><input type="checkbox" id="mainIsPrivate"> 비밀글</label>
            <button type="button" onclick="addMainReply();" class="btn1">등록</button>
        </div>
        
        <div class="bottom-row">
            <button type="button" onclick="$('#mainReplyFile').click();" class="btn2">파일첨부</button>
            <input type="file" id="mainReplyFile" class="file" onchange="showFileName(this,'mainFileName')">
            <span id="mainFileName" class="file-name">선택된 파일 없음</span>
        </div>
    </div>
</div>

<script>
const loginMemberId = "${sessionScope.loginUser.memberId}";
const loginUserRole = "${sessionScope.loginUser.role}";

$(function(){ selectReplyList(); });

function showFileName(input, targetId){
    $("#" + targetId).text(input.files.length > 0 ? input.files[0].name : "선택된 파일 없음");
}

function selectReplyList(){
    $.ajax({
        url : "${pageContext.request.contextPath}/reply/list",
        type : "get",
        data : { chapterId : $("#chapterId").val() },
        success : function(list){
            $("#replyCount").text(list.length);
            
            // 대댓글 작성자 확인을 위한 맵 생성
            const replyMemberMap = {};
            $.each(list, function(i, r) { replyMemberMap[r.replyId] = r.memberId; });

            let html = list.length === 0 ? "<tr><td style='text-align:center;color:#999;'>등록된 댓글이 없습니다.</td></tr>" : "";

            $.each(list, function(index, r){
                let isChild = (r.parentReplyId != null && r.parentReplyId != 0);
                let rowClass = isChild ? "child-reply" : "";
                let prefix = isChild ? "└ " : "";
                let content = $("<div>").text(r.content || "").html();

                // 비밀글 로직: 본인, 관리자, 또는 원댓글 작성자인 경우 내용 표시
                if(r.isPrivate === "Y"){
                    let parentMemberId = (isChild) ? replyMemberMap[r.parentReplyId] : null;
                    if(loginMemberId == r.memberId || loginUserRole == "S" || (parentMemberId && loginMemberId == parentMemberId)){
                        content = "🔒 [비밀댓글] " + r.content;
                    } else {
                        content = "<span class='secret-text'>🔒 비밀 댓글입니다.</span>";
                    }
                }

                html += "<tr class='" + rowClass + "'><td><b>" + prefix + r.name + "</b>";
                if(r.positionName) html += " (" + r.positionName + ")";
                if(r.deptName) html += "<br><span style='font-size:11px;color:#888;'>" + r.deptName + "</span>";
                html += "</td><td><div id='contentArea_" + r.replyId + "'>" + content + "</div>";
                
                if(r.originalName && r.replyId) {
                    html += "<div style='margin-top:5px;font-size:12px;'>"
                         + "<a href='${pageContext.request.contextPath}/reply/download?replyId=" + r.replyId + "' style='color:#007bff;'>📎 " + r.originalName + "</a>"
                         + "</div>";
                }
                
                html += "<div style='margin-top:5px;font-size:11px;color:#999;'>" + r.createdDate;
                if(loginMemberId == r.memberId || loginUserRole == "S") html += "<span class='reply-btn' style='color:red;' onclick='deleteReply(" + r.replyId + ")'>삭제</span>";
                if(loginMemberId == r.memberId) html += "<span class='reply-btn' onclick='editReply(" + r.replyId + ")'>수정</span>";
                if(!isChild) html += "<span class='reply-btn' onclick='toggleReplyForm(" + r.replyId + ")'>답글달기</span>";
                html += "</div>";

                if(!isChild){
                    html += "<div id='reForm_" + r.replyId + "' class='re-input-area'>"
                         + "<textarea id='reContent_" + r.replyId + "' rows='2' style='width:100%;resize:none;' placeholder='답글을 입력하세요.' maxlength='1000'></textarea>"
                         + "<div style='margin-top:5px;'><input type='file' id='reFile_" + r.replyId + "' style='display:none;' onchange=\"showFileName(this,'reFileName_" + r.replyId + "')\">"
                         + "<button type='button' onclick=\"$('#reFile_" + r.replyId + "').click();\">파일첨부</button>"
                         + "<span id='reFileName_" + r.replyId + "' class='file-name'>선택된 파일 없음</span></div>"
                         + "<div style='margin-top:5px;'><label><input type='checkbox' id='rePrivate_" + r.replyId + "'> 비밀글</label>"
                         + "&nbsp;&nbsp;<button type='button' onclick='addChildReply(" + r.replyId + ")'>등록</button></div></div>";
                }
                html += "</td></tr>";
            });
            $("#replyBody").html(html);
        }
    });
}

// 등록/삭제/수정 함수들은 기존과 동일하게 FormData 사용하여 구현
function addMainReply(){
    let formData = new FormData();
    formData.append("chapterId", $("#chapterId").val());
    formData.append("content", $("#mainReplyContent").val());
    formData.append("isPrivate", $("#mainIsPrivate").is(":checked") ? "Y" : "N");
    if($("#mainReplyFile")[0].files[0]) formData.append("uploadFile", $("#mainReplyFile")[0].files[0]);

    $.ajax({
        url : "${pageContext.request.contextPath}/reply/insert",
        type : "post",
        data : formData,
        processData : false, contentType : false,
        success : function(result){ if(result === "SUCCESS") { $("#mainReplyContent").val(""); selectReplyList(); } }
    });
}

function addChildReply(parentReplyId){
    let formData = new FormData();
    formData.append("chapterId", $("#chapterId").val());
    formData.append("content", $("#reContent_" + parentReplyId).val());
    formData.append("parentReplyId", parentReplyId);
    formData.append("isPrivate", $("#rePrivate_" + parentReplyId).is(":checked") ? "Y" : "N");
    let file = $("#reFile_" + parentReplyId)[0].files[0];
    if(file) formData.append("uploadFile", file);

    $.ajax({
        url : "${pageContext.request.contextPath}/reply/insert",
        type : "post",
        data : formData,
        processData : false, contentType : false,
        success : function(result){ if(result === "SUCCESS") selectReplyList(); }
    });
}

function toggleReplyForm(id){ $("#reForm_" + id).slideToggle(200); }
function deleteReply(id){ if(confirm("삭제하시겠습니까?")) { $.post("${pageContext.request.contextPath}/reply/delete", {replyId: id}, function(){ selectReplyList(); }); } }
function editReply(id){
    let content = prompt("댓글 수정", $("#contentArea_" + id).text());
    if(content) $.post("${pageContext.request.contextPath}/reply/update", {replyId: id, content: content}, function(){ selectReplyList(); });
}
</script>