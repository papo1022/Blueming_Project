<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>blueming</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/courseStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/chapterOrder.css">
</head>

<body>

    <jsp:include page="../common/mainMenubar.jsp" />

    <div class="outer">
        <form id="content-card" action="orderChapter" method="post">
            <input type="hidden" name="courseId" value="${courseId}">
            <div class="chapter-order-shell">
                <div class="chapter-order-header">
                    <div>
                        <h2 class="page-title">챕터 목록 변경</h2>
                        <p>${course.courseTitle}</p>
                    </div>
                </div>

                <div class="chapter-order-guide">
                    드래그하거나 위/아래 버튼으로 챕터 순서를 조정할 수 있습니다. 저장 시 현재 목록 순서대로
                    CHAPTER_ORDER 값이 1부터 다시 반영됩니다.
                </div>

                <ul id="chapterOrderList" class="chapter-order-list">
                    <c:forEach var="ch" items="${chapterList}">
                        <li class="chapter-order-item" draggable="true" data-chapter-id="${ch.chapterId}">
                            <div class="chapter-order-badge"></div>
                            <div>
                                <div class="chapter-order-title">${ch.chapterTitle}</div>
                                <div class="chapter-progress-wrap">
                                    <div class="chapter-progress-track">
                                        <div class="chapter-progress-bar" data-progress="${ch.avgProgress}"></div>
                                    </div>
                                </div>
                                <p class="chapter-progress-rate">전체 수강생 이수율 ${String.format("%.2f", ch.avgProgress)}%</p>
                            </div>
                            <div class="chapter-order-actions">
                                <button type="button" class="move-up" aria-label="위로 이동">↑</button>
                                <button type="button" class="move-down" aria-label="아래로 이동">↓</button>
                            </div>
                        </li>
                    </c:forEach>
                </ul>

                <div id="chapterOrderFields"></div>

                <div class="buttons" align="center">
                    <button type="submit" class="btn btn-primary">변경사항 저장</button>
                    <a href="${pageContext.request.contextPath}/course/detail?courseId=${courseId}" class="btn btn-secondary">
                        목록으로
                    </a>
                </div>
            </div>
        </form>
    </div>

    <script>
        const list = document.getElementById("chapterOrderList");
        const hiddenFieldWrap = document.getElementById("chapterOrderFields");
        let draggingItem = null;

        function refreshChapterOrderList() {
            const items = Array.from(list.querySelectorAll(".chapter-order-item"));
            items.forEach((item, index) => {
                item.querySelector(".chapter-order-badge").textContent = index + 1;
                item.querySelector(".move-up").disabled = index === 0;
                item.querySelector(".move-down").disabled = index === items.length - 1;
                const bar = item.querySelector(".chapter-progress-bar");
                const rawProgress = parseFloat(bar.dataset.progress);
                const progress = Number.isFinite(rawProgress) ? Math.max(0, Math.min(100, rawProgress)) : 0;
                bar.style.width = progress.toFixed(2) + "%";
            });
        }

        function rebuildHiddenFields() {
            hiddenFieldWrap.innerHTML = "";
            Array.from(list.querySelectorAll(".chapter-order-item")).forEach((item, index) => {
                const chapterIdInput = document.createElement("input");
                chapterIdInput.type = "hidden";
                chapterIdInput.name = "chapterId";
                chapterIdInput.value = item.dataset.chapterId;

                const chapterOrderInput = document.createElement("input");
                chapterOrderInput.type = "hidden";
                chapterOrderInput.name = "chapterOrder";
                chapterOrderInput.value = index + 1;

                hiddenFieldWrap.appendChild(chapterIdInput);
                hiddenFieldWrap.appendChild(chapterOrderInput);
            });
        }

        function moveItem(item, direction) {
            const sibling = direction < 0 ? item.previousElementSibling : item.nextElementSibling;
            if (!sibling) {
                return;
            }
            if (direction < 0) {
                list.insertBefore(item, sibling);
            } else {
                list.insertBefore(sibling, item);
            }
            refreshChapterOrderList();
        }

        list.addEventListener("dragstart", function(event) {
            const item = event.target.closest(".chapter-order-item");
            if (!item) {
                return;
            }
            draggingItem = item;
            item.classList.add("dragging");
        });

        list.addEventListener("dragend", function(event) {
            const item = event.target.closest(".chapter-order-item");
            if (!item) {
                return;
            }
            item.classList.remove("dragging");
            draggingItem = null;
            refreshChapterOrderList();
        });

        list.addEventListener("dragover", function(event) {
            event.preventDefault();
            const target = event.target.closest(".chapter-order-item");
            if (!draggingItem || !target || target === draggingItem) {
                return;
            }

            const rect = target.getBoundingClientRect();
            const shouldInsertBefore = event.clientY < rect.top + rect.height / 2;
            if (shouldInsertBefore) {
                list.insertBefore(draggingItem, target);
            } else {
                list.insertBefore(draggingItem, target.nextElementSibling);
            }
        });

        list.addEventListener("click", function(event) {
            const button = event.target.closest("button");
            if (!button) {
                return;
            }
            const item = button.closest(".chapter-order-item");
            if (button.classList.contains("move-up")) {
                moveItem(item, -1);
            }
            if (button.classList.contains("move-down")) {
                moveItem(item, 1);
            }
        });

        document.getElementById("content-card").addEventListener("submit", function() {
            rebuildHiddenFields();
        });

        refreshChapterOrderList();
        rebuildHiddenFields();
    </script>
</body>

</html>
