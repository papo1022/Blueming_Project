<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>blueming</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/courseStyle.css">
    <style>
        .outer {
            margin: 20px;
            margin-left: 270px;
            width: calc(100% - 320px);
            max-width: 1080px;
        }

        .chapter-order-shell {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .chapter-order-header {
            display: flex;
            justify-content: space-between;
            gap: 16px;
            align-items: flex-start;
            text-align: left;
        }

        .chapter-order-header p,
        .chapter-order-guide,
        .chapter-progress-rate {
            margin: 0;
            color: #6b7280;
        }

        .chapter-order-guide {
            padding: 16px 18px;
            border-radius: 12px;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            line-height: 1.6;
        }

        .chapter-order-list {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .chapter-order-item {
            display: grid;
            grid-template-columns: auto 1fr auto;
            gap: 18px;
            align-items: center;
            padding: 18px 22px;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            background: #fff;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.06);
            cursor: grab;
        }

        .chapter-order-item.dragging {
            opacity: 0.6;
            border-color: #60a5fa;
            background: #eff6ff;
        }

        .chapter-order-badge {
            width: 48px;
            height: 48px;
            border-radius: 999px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: #1d4ed8;
            background: #dbeafe;
        }

        .chapter-order-title {
            font-size: 18px;
            font-weight: 700;
            color: #111827;
        }

        .chapter-progress-wrap {
            margin-top: 10px;
        }

        .chapter-progress-track {
            overflow: hidden;
            height: 12px;
            border-radius: 999px;
            background: #e5e7eb;
        }

        .chapter-progress-bar {
            height: 100%;
            border-radius: 999px;
            background: linear-gradient(90deg, #38bdf8, #2563eb);
        }

        .chapter-order-actions {
            display: flex;
            gap: 8px;
        }

        .chapter-order-actions button {
            min-width: 44px;
            border: 1px solid #d1d5db;
            background: #fff;
            border-radius: 10px;
            padding: 10px 0;
            font-weight: 700;
        }

        .chapter-order-actions button:disabled {
            opacity: 0.45;
            cursor: not-allowed;
        }

        .buttons {
            display: flex;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
        }
    </style>
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
                                        <div class="chapter-progress-bar" style="width: ${String.format('%.2f', ch.avgProgress)}%;"></div>
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

        function clampRate(rate) {
            return Math.max(0, Math.min(100, rate || 0));
        }

        function refreshChapterOrderList() {
            const items = Array.from(list.querySelectorAll(".chapter-order-item"));
            items.forEach((item, index) => {
                item.querySelector(".chapter-order-badge").textContent = index + 1;
                item.querySelector(".move-up").disabled = index === 0;
                item.querySelector(".move-down").disabled = index === items.length - 1;
                const bar = item.querySelector(".chapter-progress-bar");
                const width = clampRate(parseFloat(bar.style.width));
                bar.style.width = width.toFixed(2) + "%";
            });
        }

        function rebuildHiddenFields() {
            hiddenFieldWrap.innerHTML = "";
            Array.from(list.querySelectorAll(".chapter-order-item")).forEach((item, index) => {
                hiddenFieldWrap.insertAdjacentHTML("beforeend",
                    '<input type="hidden" name="chapterId" value="' + item.dataset.chapterId + '">' +
                    '<input type="hidden" name="chapterOrder" value="' + (index + 1) + '">');
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
