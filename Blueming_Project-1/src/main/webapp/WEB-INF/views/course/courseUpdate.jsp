<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Insert title here</title>
            <style>
                .outer {
                    float: center;
                    margin: 20px;
                    margin-left: 270px;
                    width: 80%;
                }

                #courseTitle {
                    width: 80%;
                    margin: 10px;
                }

                #description {
                    width: 80%;
                    height: 300px;
                    resize: none;
                }

                input[type="date"] {
                    width: 80%;
                }

                #ruleTypeSelector,
                #deptSelector,
                #posSelector {
                    width: 80%;
                }

                #target-rule-area {
                    width: 80%;
                    margin: 0 auto;
                    text-align: left;
                }

                #target-rules-list {
                    margin-top: 10px;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    padding: 10px;
                    min-height: 56px;
                    background: #fafafa;
                }

                .target-rule-item {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 6px 8px;
                    margin-bottom: 6px;
                    background: #fff;
                    border: 1px solid #e5e5e5;
                    border-radius: 6px;
                }

                .target-rule-item:last-child {
                    margin-bottom: 0;
                }
            </style>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/courseStyle.css">
        </head>

        <body>

            <jsp:include page="../common/mainMenubar.jsp" />

            <div class="outer">
                <form id="courseUpdateForm" action="updateCourse" align="center" method="post" enctype="multipart/form-data"
                    onsubmit="return validateForm();">
                    <h1 class="page-title">강의 수정</h1>
                    <input type="hidden" name="memberId" value="${sessionScope.loginUser.memberId}">
                    <input type="hidden" name="courseId" value="${requestScope.c.courseId}">
                    <br>
                    <table class="table">
                        <tr>
                            <td>* 강의명</td>
                            <td><input type="text" name="courseTitle" id="courseTitle"
                                    value="${requestScope.c.courseTitle}" maxlength="30" required></td>
                        </tr>
                        <tr>
                            <td>* 강의 설명</td>
                            <td><textarea name="description" id="description" maxlength="666"
                                    required>${requestScope.c.description}</textarea></td>
                        </tr>
                        <tr>
                            <td>* 강의 시작 시간</td>
                            <td><input type="date" name="startDate" value="${requestScope.c.startDate}" required></td>
                        </tr>
                        <tr>
                            <td>* 강의 마감 시간</td>
                            <td><input type="date" name="endDate" value="${requestScope.c.endDate}" required></td>
                        </tr>
                        <tr>
                            <td>* 강좌 대상</td>
                            <td>
                                <div id="target-rule-area">
                                    <div style="display:flex; gap:8px; flex-wrap:wrap; align-items:center;">
                                        <select id="ruleTypeSelector" onchange="onRuleTypeChange();">
                                            <option value="ALL">전체 인원</option>
                                            <option value="DEPT">특정 부서</option>
                                            <option value="POS">특정 직급</option>
                                            <option value="DEPT_POS">특정 부서 + 특정 직급</option>
                                        </select>
                                        <select id="deptSelector" style="display:none;"></select>
                                        <select id="posSelector" style="display:none;"></select>
                                        <button type="button" class="btn btn-secondary" onclick="addTargetRule();">대상
                                            추가</button>
                                    </div>
                                    <div id="target-rules-list"></div>
                                    <input type="hidden" id="targetRulesJson" name="targetRulesJson">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>썸네일 이미지</td>
                            <td>
                                <input type="file" name="thumbnail" accept="image/*">
                                <c:if
                                    test="${not empty thumbnailAttachment and not empty thumbnailAttachment.originalName}">
                                    <div style="margin-top:6px; color:#555; font-size:13px;">
                                        기존 파일: ${thumbnailAttachment.originalName}
                                    </div>
                                </c:if>
                            </td>
                        </tr>
                    </table>
                    <div class="buttons" align="center">
                        <button type="submit" class="btn btn-primary">수정하기</button>
                        <button type="reset" class="btn btn-warning">초기화</button>
                        <a href="${pageContext.request.contextPath}/course/detail?courseId=${c.courseId}" class="btn btn-secondary">
                            목록으로
                        </a>
                    </div>
                </form>
            </div>

            <script>
                const deptOptionsRaw = [];
                <c:forEach var="d" items="${deptOptions}">
                    deptOptionsRaw.push(["${d.DEPARTMENT_ID}", "${d.DEPARTMENT_NAME}"]);
                </c:forEach>
                const deptOptions = deptOptionsRaw.map(function (row) {
                    return { id: row[0], name: row[1] };
                });

                const posOptionsRaw = [];
                <c:forEach var="p" items="${positionOptions}">
                    posOptionsRaw.push(["${p.POSITION_ID}", "${p.POSITION_NAME}"]);
                </c:forEach>
                const posOptions = posOptionsRaw.map(function (row) {
                    return { id: row[0], name: row[1] };
                });

                const targetRules = [];

                function normalizeType(rawType) {
                    if (!rawType) return "ALL";
                    const type = String(rawType).toUpperCase();
                    if (type === "전체" || type === "ALL") return "ALL";
                    if (type === "부서" || type === "DEPT" || type === "DEPARTMENT") return "DEPT";
                    if (type === "직급" || type === "POS" || type === "POSITION") return "POS";
                    if (type === "DEPT_POS") return "DEPT_POS";
                    return "ALL";
                }

                function populateSelect(selectId, options, placeholder) {
                    const select = document.getElementById(selectId);
                    let html = "<option value=''>" + placeholder + "</option>";
                    for (let i = 0; i < options.length; i++) {
                        html += "<option value='" + options[i].id + "'>" + options[i].name + "</option>";
                    }
                    select.innerHTML = html;
                }

                function getNameById(options, id) {
                    for (let i = 0; i < options.length; i++) {
                        if (options[i].id === id) return options[i].name;
                    }
                    return id || "";
                }

                function onRuleTypeChange() {
                    const type = document.getElementById("ruleTypeSelector").value;
                    const dept = document.getElementById("deptSelector");
                    const pos = document.getElementById("posSelector");

                    dept.style.display = (type === "DEPT" || type === "DEPT_POS") ? "inline-block" : "none";
                    pos.style.display = (type === "POS" || type === "DEPT_POS") ? "inline-block" : "none";
                }

                function buildRule(type, value) {
                    if (type === "ALL") return { targetType: "ALL", targetValue: null, label: "전체 인원" };
                    if (type === "DEPT") return { targetType: "DEPT", targetValue: value, label: "부서: " + getNameById(deptOptions, value) };
                    if (type === "POS") return { targetType: "POS", targetValue: value, label: "직급: " + getNameById(posOptions, value) };

                    const parts = (value || "").split("|");
                    return {
                        targetType: "DEPT_POS",
                        targetValue: value,
                        label: "부서+직급: " + getNameById(deptOptions, parts[0]) + " / " + getNameById(posOptions, parts[1])
                    };
                }

                function addTargetRule() {
                    const type = document.getElementById("ruleTypeSelector").value;
                    const deptId = document.getElementById("deptSelector").value;
                    const posId = document.getElementById("posSelector").value;
                    let value = null;

                    if (type === "DEPT" && !deptId) {
                        alert("부서를 선택해주세요.");
                        return;
                    }
                    if (type === "POS" && !posId) {
                        alert("직급을 선택해주세요.");
                        return;
                    }
                    if (type === "DEPT_POS") {
                        if (!deptId || !posId) {
                            alert("부서와 직급을 모두 선택해주세요.");
                            return;
                        }
                        value = deptId + "|" + posId;
                    }
                    if (type === "DEPT") value = deptId;
                    if (type === "POS") value = posId;

                    for (let i = 0; i < targetRules.length; i++) {
                        if (targetRules[i].targetType === type && (targetRules[i].targetValue || "") === (value || "")) {
                            return;
                        }
                    }

                    targetRules.push(buildRule(type, value));
                    renderTargetRules();
                }

                function removeTargetRule(index) {
                    targetRules.splice(index, 1);
                    renderTargetRules();
                }

                function renderTargetRules() {
                    const container = document.getElementById("target-rules-list");
                    if (targetRules.length === 0) {
                        container.innerHTML = "<div style='color:#666;'>추가된 대상이 없습니다.</div>";
                    } else {
                        let html = "";
                        for (let i = 0; i < targetRules.length; i++) {
                            html += "<div class='target-rule-item'>"
                                + "<span>" + targetRules[i].label + "</span>"
                                + "<button type='button' class='btn btn-sm btn-outline-danger' onclick='removeTargetRule(" + i + ")'>삭제</button>"
                                + "</div>";
                        }
                        container.innerHTML = html;
                    }

                    const payload = [];
                    for (let i = 0; i < targetRules.length; i++) {
                        payload.push({
                            targetType: targetRules[i].targetType,
                            targetValue: targetRules[i].targetValue
                        });
                    }
                    document.getElementById("targetRulesJson").value = JSON.stringify(payload);
                }

                function addInitialRule(rawType, rawValue) {
                    const type = normalizeType(rawType);
                    const value = rawValue == null ? null : String(rawValue);
                    targetRules.push(buildRule(type, value));
                }

                <c:choose>
                    <c:when test="${not empty targetRules}">
                        <c:forEach var="r" items="${targetRules}">
                            <c:set var="resolvedType" value="${r.targetType}" />
                            <c:if test="${empty resolvedType}">
                                <c:set var="resolvedType" value="${empty r.TARGETTYPE ? r.TARGET_TYPE : r.TARGETTYPE}" />
                            </c:if>

                            <c:set var="resolvedValue" value="${r.targetValue}" />
                            <c:if test="${empty resolvedValue}">
                                <c:set var="resolvedValue" value="${empty r.TARGETVALUE ? r.TARGET_VALUE : r.TARGETVALUE}" />
                            </c:if>

                            addInitialRule("${resolvedType}", "${resolvedValue}");
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        addInitialRule("${requestScope.c.targetType}", "${requestScope.c.targetValue}");
                    </c:otherwise>
                </c:choose>

                const initialTargetRules = targetRules.map(function (rule) {
                    return {
                        targetType: rule.targetType,
                        targetValue: rule.targetValue,
                        label: rule.label
                    };
                });

                function validateForm() {
                    const startDate = new Date(document.querySelector('input[name="startDate"]').value);
                    const endDate = new Date(document.querySelector('input[name="endDate"]').value);

                    if (startDate > endDate) {
                        alert("강의 시작 날짜는 마감 날짜보다 이전이어야 합니다.");
                        return false;
                    }

                    if (targetRules.length === 0) {
                        alert("최소 1개 이상의 강좌 대상을 추가해주세요.");
                        return false;
                    }
                    return true;
                }

                populateSelect("deptSelector", deptOptions, "부서 선택");
                populateSelect("posSelector", posOptions, "직급 선택");
                onRuleTypeChange();
                renderTargetRules();

                document.getElementById("courseUpdateForm").addEventListener("reset", function () {
                    window.setTimeout(function () {
                        targetRules.length = 0;
                        for (let i = 0; i < initialTargetRules.length; i++) {
                            targetRules.push({
                                targetType: initialTargetRules[i].targetType,
                                targetValue: initialTargetRules[i].targetValue,
                                label: initialTargetRules[i].label
                            });
                        }

                        document.getElementById("ruleTypeSelector").value = "ALL";
                        document.getElementById("deptSelector").value = "";
                        document.getElementById("posSelector").value = "";
                        onRuleTypeChange();
                        renderTargetRules();
                    }, 0);
                });
            </script>
        </body>

        </html>