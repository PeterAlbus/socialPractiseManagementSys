<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <title>主页</title>
    <!-- 引入Vue -->
    <script src="${pageContext.request.contextPath}/iview/vue.js"></script>
    <!-- 引入样式 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/iview/styles/iview.css">
    <!-- 引入组件库 -->
    <script src="${pageContext.request.contextPath}/iview/iview.js"></script>
</head>
<body>
<div id="app">
    跳转中...
</div>
<script>
    location.href="/toHomePage"
    new Vue({
        el: '#app',
        data: {
            visible: false
        },
        create:{

        },
        methods: {
            show: function () {
                this.visible = true;
            }
        }
    })
</script>
</body>
</html>
