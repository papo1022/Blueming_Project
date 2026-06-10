<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    .reply-wrap { width: 100%; margin: 30px auto; font-family: sans-serif; }
    .reply-list-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    .reply-list-table tr { border-bottom: 1px solid #eee; }
    .reply-list-table td { padding: 12px 8px; vertical-align: top; }
    .child-reply { background-color: #f9f9f9; padding-left: 30px !important; } 
    .re-input-area { background-color: #f4f6f9; padding: 10px; display: none; margin-top: 5px; } 
    .secret-text { color: #aaa; font-style: italic; }
    .reply-btn { font-size: 11px; color: #007bff; cursor: pointer; margin-left: 10px; text-decoration: underline; }
</style>

<div class="reply-wrap">
    <h3>질문 / 댓글 (<span id="replyCount">0</span>)</h3>
    
    <table style="width: 100%;">
        <tr>
            <td>
                <textarea id="mainReplyContent" rows="3" style="width: 100%; resize: none;" placeholder="댓글을 입력하세요."></textarea>
            </td>
            <td style="width: 90px; text-align: right;">
                <label><input type="checkbox" id="mainIsPrivate" value="Y"> 비밀글</label><br>
                <button type="button" onclick="addMainReply();" style="width: 80px; height: 40px; margin-top: 5px;">등록</button>
            </td>
        </tr>
    </table>

    <table class="reply-list-table">
        <tbody id="replyBody">
            </tbody>
    </table>
</div>

<script>
    // 컨트롤러가 대피시켜둔 변수나 세션 정보는 Include된 JSP에서도 그대로 인식합니다.
    const loginMemberId = "${loginUser.memberId}"; 
    const loginUserRole = "${loginUser.role}"; 
    const currentChapterId = "${chapter.chapterId}"; // 💡 본인 프로젝트의 챕터ID 변수명 확인

    $(function() {
        if(currentChapterId) {
            selectReplyList();
        }
    });

    // 1. 댓글 리스트 조회
    function selectReplyList() {
        $.ajax({
            url: "${pageContext.request.contextPath}/reply/list",
            type: "post",
            data: { chapterId: currentChapterId },
            success: function(list) {
                $("#replyCount").text(list.length);
                let html = "";

                if(list.length === 0) {
                    html = "<tr><td colspan='2' style='text-align:center; color:#999;'>등록된 댓글이 없습니다.</td></tr>";
                } else {
                    for(let i in list) {
                        let r = list[i];
                        let isChild = (r.parentReplyId !== 0 && r.parentReplyId !== null);
                        let rowClass = isChild ? "child-reply" : "";
                        let prefix = isChild ? "└ Re: " : "";

                        let displayContent = r.content;
                        if(r.isPrivate === 'Y') {
                            if(loginMemberId == r.memberId || loginUserRole === 'R') {
                                displayContent = "🔒 [비밀 댓글] " + r.content;
                            } else {
                                displayContent = "<span class='secret-text'>🔒 비밀 댓글입니다. 작성자와 관리자만 볼 수 있습니다.</span>";
                            }
                        }

                        html += "<tr class='" + rowClass + "'>"
                              + "   <td style='width: 150px;'><strong>" + prefix + r.name + "</strong> <span style='font-size:11px; color:#888;'>(" + r.deptName + ")</span></td>"
                              + "   <td>"
                              + "       <div>" + displayContent + "</div>"
                              + "       <div style='font-size: 11px; color: #999; margin-top: 5px;'>" + r.createdDate;
                        
                        if(loginMemberId == r.memberId || loginUserRole === 'R') {
                            html += "       <span class='reply-btn' style='color:red;' onclick='deleteReply(" + r.replyId + ")'>삭제</span>";
                        }
                        if(!isChild) {
                            html += "       <span class='reply-btn' onclick='toggleReplyForm(" + r.replyId + ")'>답글달기</span>";
                        }
                        html += "       </div>";

                        if(!isChild) {
                            html += "   <div id='reForm_" + r.replyId + "' class='re-input-area'>"
                                  + "       <table style='width:100%;'>"
                                  + "           <tr>"
                                  + "               <td><textarea id='reContent_" + r.replyId + "' rows='2' style='width:100%; resize:none;' placeholder='답글을 입력하세요.'></textarea></td>"
                                  + "               <td style='width:80px; text-align:right; font-size:12px;'>"
                                  + "                   <label><input type='checkbox' id='rePrivate_" + r.replyId + "' value='Y'> 비밀글</label><br>"
                                  + "                   <button type='button' onclick='addChildReply(" + r.replyId + ");' style='margin-top:5px;'>등록</button>"
                                  + "               </td>"
                                  + "           </tr>"
                                  + "       </table>"
                                  + "   </div>";
                        }
                        html += "   </td>"
                              + "</tr>";
                    }
                }
                $("#replyBody").html(html);
            }
        });
    }

 // 2. 부모 댓글 등록
    function addMainReply() {
        let content = $("#mainReplyContent").val();
        let isPrivate = $("#mainIsPrivate").is(":checked") ? "Y" : "N";
        
        // 💡 로그로 확인!
        console.log("보낼 내용 확인:", content); 

        if(!content || content.trim().length === 0) { 
            alert("내용을 입력해주세요."); 
            return; 
        }

        $.ajax({
            url: "${pageContext.request.contextPath}/reply/insert",
            type: "post",
            data: { 
                chapterId: currentChapterId, 
                content: content,      // 🌟 여기에 값이 들어가는지 확인
                isPrivate: isPrivate 
            },
            success: function(result) {
                if(result === "SUCCESS") {
                    $("#mainReplyContent").val("");
                    $("#mainIsPrivate").prop("checked", false);
                    selectReplyList();
                } else { alert("댓글 등록 실패"); }
            }
        });
    }

    function toggleReplyForm(replyId) { $("#reForm_" + replyId).slideToggle(200); }

    // 3. 대댓글 등록
    function addChildReply(parentReplyId) {
        let content = $("#reContent_" + parentReplyId).val();
        let isPrivate = $("#rePrivate_" + parentReplyId).is(":checked") ? "Y" : "N";
        if(content.trim().length === 0) { alert("답글을 입력해주세요."); return; }

        $.ajax({
            url: "${pageContext.request.contextPath}/reply/insert",
            type: "post",
            data: { chapterId: currentChapterId, content: content, isPrivate: isPrivate, parentReplyId: parentReplyId },
            success: function(result) {
                if(result === "SUCCESS") { selectReplyList(); }
            }
        });
    }


    // 4. 댓글 삭제 (문법 오류 수정 완료)
    function deleteReply(replyId) {
        if(confirm("정말 삭제하시겠습니까?")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/reply/delete",
                type: "post",
                data: { replyId: replyId },
                success: function(result) {
                    if(result === "SUCCESS" || result > 0 || result == "1") { 
                        selectReplyList(); 
                    } else {
                        alert("댓글 삭제 실패");
                    }
                }, // <--- success 닫는 중괄호와 콤마가 누락되었던 곳입니다.
                error: function(xhr, status, error) {
                    alert("Ajax 통신 에러 발생! 에러코드: " + xhr.status);
                }
            }); // <--- ajax 끝
        } // <--- confirm 끝
    } // <--- function 끝
</script>