<%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2021/12/8
  Time: 14:28
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <title>管理员界面</title>
    <!-- 引入Vue -->
    <script src="${pageContext.request.contextPath}/iview/vue.js"></script>
    <!-- 引入样式 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/iview/styles/iview.css">
    <!-- 引入组件库 -->
    <script src="${pageContext.request.contextPath}/iview/iview.js"></script>
</head>
<body>
<div id="app">
    <h1>
        <shiro:authenticated>已登录!<a href="${pageContext.request.contextPath}/logout">登出</a></shiro:authenticated>
    </h1>
</div>
<script>
    new Vue({
        el: '#app',
        data: {
            user:{
                username:'',
            }
        },
        mounted(){
            this.user.username='${user.username}'
        },
        methods: {
        }
    })
</script>
</body>
</html>
