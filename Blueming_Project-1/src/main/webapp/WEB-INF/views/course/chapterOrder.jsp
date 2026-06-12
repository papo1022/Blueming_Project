<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>blueming</title>
            <style>
                .outer {
                    float: center;
                    margin: 20px;
                    margin-left: 270px;
                    width: 80%;
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

                input[type="number"] {
                    min-width: 70px;
                    text-align: center;
                }

                input[type=number]::-webkit-inner-spin-button,
                input[type=number]::-webkit-outer-spin-button {
                    -webkit-appearance: none;
                    margin: 0;
                }
            </style>
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/courseStyle.css">
        </head>

        <body>

            <jsp:include page="../common/mainMenubar.jsp" />

            <div class="outer">
                <form id="content-card" action="orderChapter" onsubmit="return validateOrder();" align="center" method="post" enctype="multipart/form-data">
                    <h2 class="page-title">챕터 순서 수정</h2>
                    <input type="hidden" name="courseId" value="${courseId}">
                    <br>
                    <table id="chapter-area" class="table">
                        <thead>
                            <tr>
                                <th width="10%">챕터</th>
                                <th width="40%">제목</th>
                                <th width="50%">모든 수강생 이수율</th>
                            </tr>
                        </thead>
                        <tbody>
                            <div class="alert alert-warning">챕터 번호가 1~${chapterList.size()}인 정수여야 하고, 값이 중복되어선 안됩니다.</div>
                            <c:forEach var="ch" items="${chapterList}">
                                <input type="hidden" name="chapterId" value="${ch.chapterId}">
                                <tr>
                                    <td>
                                        <input type=number name="chapterOrder" value="${ch.chapterOrder}"
                                            class="chapterOrder" min="1" step="1" required>
                                        </td>
                                    <td>
                                        ${ch.chapterTitle}
                                    </td>
                                    <td>
                                        <div class="progress" style="height: 20px;">
                                            <div class="progress-bar progress-bar-striped bg-info progress-bar-animated rounded-pill"
                                                role="progressbar"
                                                style="width: ${String.format('%.2f', ch.avgProgress)}%;">
                                                <span align="center" class="text-small">${String.format("%.2f",
                                                    ch.avgProgress)}%</span>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div class="buttons" align="center">
                        <button type="submit" class="btn btn-primary">수정하기</button>
                        <button type="reset" class="btn btn-warning">초기화</button>
                        <a href="${pageContext.request.contextPath}/course/detail?courseId=${courseId}"
                            class="btn btn-secondary">
                            목록으로
                        </a>
                    </div>
                </form>
            </div>

            <script>
                function validateOrder() {
                    let isPass = true;
                    const order = [];
                    const max = $("input[name='chapterOrder']").length;

                    $("input[name='chapterOrder']").each(function() {
                        
                        const val = Number($(this).val());
                        
                        if(!Number.isInteger(val)) {
                            alert("자연수만 입력해주세요.");
                            isPass = false;
                            return false;
                        }

                        else if(val < 1) {
                            alert("1 이상의 값만 입력해주세요.");
                            isPass = false;
                            return false;
                        }

                        else if(val > max) {
                            alert("현재 입력 가능한 최대 숫자는 " + max + " 입니다.");
                            isPass = false;
                            return false;
                        }

                        else if(order.includes(val)) {
                            alert("중복된 번호 " + val + " 을 수정해주세요.");
                            isPass = false;
                            return false;
                        }

                        order.push(val);
                    });

                    return isPass;
                }
            </script>
        </body>

        </html>