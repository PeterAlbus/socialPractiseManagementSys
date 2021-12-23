<%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2021/12/4
  Time: 18:50
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <title>主页</title>
    <!-- 导入 Vue 3 -->
    <script src="${pageContext.request.contextPath}/vue/vue@next/vue.global.js"></script>
    <!-- 导入组件库 -->
    <script src="${pageContext.request.contextPath}/vue/element/index.full.js"></script>
    <!-- 引入样式 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/vue/font-awesome/css/font-awesome.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="//unpkg.com/element-plus@1.1.0-beta.9/dist/index.css" />
</head>
<body>
<div id="app">
    <header>
        <link rel="stylesheet" href="/css/header.css">
        <el-affix>
            <div class="navbar">
                <div class="hamburger-container"><i class="el-icon-s-grid"></i> 社会实践活动管理系统-{{title}}</div>
                <div class="right-menu">
                    <el-avatar :src="user.avatarSrc" size="small" onclick="location.href='/userCenter'"></el-avatar>&emsp;
                    <shiro:hasRole name="student">欢迎学生:{{user.realName}}!</shiro:hasRole>
                    <shiro:hasRole name="teacher">欢迎老师:{{user.realName}}!</shiro:hasRole>
                    <shiro:hasRole name="admin">欢迎管理员:{{user.realName}}!</shiro:hasRole>
                    <shiro:hasRole name="admin"><el-link type="primary" href="/druid/index.html">数据库监控</el-link></shiro:hasRole>
                    <shiro:authenticated>
                        <el-link href="${pageContext.request.contextPath}/logout">登出 <i class="fa fa-sign-out"></i></el-link>
                    </shiro:authenticated>
                </div>
            </div>
        </el-affix>
        <div class="container">
            <img src="${pageContext.request.contextPath}/img/banner.jpg" class="banner" alt="">
        </div>
    </header>
    <div class="main">
        <div class="container">
            <el-container>
                <el-aside width="80px">
                    <%@ include file="/jsp/aside.html" %>
                </el-aside>
                <el-main>
                    <el-page-header icon="el-icon-arrow-left" :content="title" @back="goBack"></el-page-header>
                    <el-result
                            icon="error"
                            title="权限异常"
                            sub-title="您没有权限访问此页面"
                    >
                        <template #extra>
                            <el-button type="primary" size="medium" onclick="window.history.go(-1);">返回</el-button>
                        </template>
                    </el-result>
                </el-main>
            </el-container>
        </div>
    </div>
    <footer>
        <%@ include file="/jsp/foot.html" %>
    </footer>
</div>
<script>
    const App = {
        data() {
            return{
                user:{
                    username:'',
                    realName:'',
                    avatarSrc: ''
                },
                activeIndex:'999',
                title:'异常'
            }
        },
        mounted(){
            this.user.realName='${realName}'
            this.user.username='${username}'
            this.user.avatarSrc='${avatarSrc}'
        },
        methods: {
            goBack(){
                window.history.go(-1);
            }
        }
    };
    const app = Vue.createApp(App);
    app.use(ElementPlus);
    app.mount("#app");
</script>
</body>
</html>

