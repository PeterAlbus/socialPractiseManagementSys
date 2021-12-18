<%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2021/12/16
  Time: 13:12
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/teacher/activityDetail.css">
    <link rel="stylesheet" href="//unpkg.com/element-plus@1.1.0-beta.9/dist/index.css" />
</head>
<body>
<div id="app">
    <header>
        <%@ include file="/jsp/header.html" %>
    </header>
    <div class="main">
        <div class="container">
            <el-container>
                <el-aside width="80px">
                    <%@ include file="/jsp/aside.html" %>
                </el-aside>
                <el-main>
                    <el-page-header icon="el-icon-arrow-left" :content="title" @back="goBack"></el-page-header>
                    <br/>
                    <div class="container activity-detail-box">
                        <el-card style="width:600px">
                            <div style="text-align:center">
                                <el-descriptions
                                        title="活动情况"
                                        :column="1"
                                        border
                                >
                                    <template #extra>
                                        <el-button type="primary" size="small" @click="toModify(activity.activityId)">编辑</el-button>
                                    </template>
                                    <el-descriptions-item>
                                        <template #label>
                                            活动名称
                                        </template>
                                        {{activity.activityName}}
                                    </el-descriptions-item>
                                    <el-descriptions-item>
                                        <template #label>
                                            活动类别
                                        </template>
                                        {{activity.activityType}}
                                    </el-descriptions-item>
                                    <el-descriptions-item>
                                        <template #label>
                                            创建日期
                                        </template>
                                        {{activity.gmtCreate}}
                                    </el-descriptions-item>
                                </el-descriptions>
                            </div>
                            <br/>
                            <div>
                                <el-descriptions :column="1" border>
                                    <el-descriptions-item>
                                        <template #label>
                                            简介
                                        </template>
                                        {{activity.activityIntroduction}}
                                    </el-descriptions-item>
                                </el-descriptions>
                            </div>
                        </el-card>
                    </div>
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
                title:'活动详情',
                user:{
                    username:'',
                    realName:'',
                    avatarSrc: ''
                },
                activity:{
                    activityId: '${activity.getActivityId()}',
                    activityName: '${activity.getActivityName()}',
                    activityType:'${activity.getActivityType()}',
                    activityIntroduction:'${activity.getActivityIntroduction()}',
                    gmtCreate:'${activity.getFormattedCreateDate()}'
                },
                activeIndex:'2'
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
            },
            toModify(id){
                location.href="/teacher/modifyActivity?activityId="+id
            }
        }
    };
    const app = Vue.createApp(App);
    app.use(ElementPlus);
    app.mount("#app");
</script>
</body>
</html>
