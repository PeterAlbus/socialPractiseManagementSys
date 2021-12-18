<%--
  Created by IntelliJ IDEA.
  User: peteralbus
  Date: 2021/12/18
  Time: 16:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>申请参加活动</title>
    <!-- 导入 Vue 3 -->
    <script src="${pageContext.request.contextPath}/vue/vue@next/vue.global.js"></script>
    <!-- 导入组件库 -->
    <script src="${pageContext.request.contextPath}/vue/element/index.full.js"></script>
    <!-- 引入样式 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/vue/font-awesome/css/font-awesome.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/student/applyActivity.css">
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
                    <div class="container">
                        <el-steps :active="0" finish-status="success" simple>
                            <el-step title="申请参加" icon="el-icon-edit"></el-step>
                            <el-step title="小组形成" icon="el-icon-s-custom"></el-step>
                            <el-step title="上传日志" icon="el-icon-upload"></el-step>
                            <el-step title="教师评分" icon="el-icon-picture"></el-step>
                        </el-steps>
                        <el-divider content-position="left">社会实践活动信息</el-divider>
                        <div class="activity-info">
                            <el-descriptions
                                    title="活动情况"
                                    :column="1"
                                    border
                            >
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
                                        负责老师
                                    </template>
                                    <span v-for="i in activity.teachers">{{i.realName}}&emsp;</span>
                                </el-descriptions-item>
                                <el-descriptions-item>
                                    <template #label>
                                        创建日期
                                    </template>
                                    {{activity.gmtCreate}}
                                </el-descriptions-item>
                            </el-descriptions>
                            <el-descriptions :column="1" border direction="vertical">
                                <el-descriptions-item>
                                    <template #label>
                                        简介
                                    </template>
                                    {{activity.activityIntroduction}}
                                </el-descriptions-item>
                            </el-descriptions>
                        </div>
                        <el-divider content-position="left">申请参加</el-divider>
                        <div>
                            <el-form ref="apply" :model="form">
                                <el-form-item label="参加方式">
                                    <el-radio-group v-model="form.isNewGroup">
                                        <el-radio :label="true">作为小组长创建小组</el-radio>
                                        <el-radio :label="false">加入已创建的小组</el-radio>
                                    </el-radio-group>
                                </el-form-item>
                                <el-row v-if="form.isNewGroup">
                                    <el-col :span="12">
                                        <el-form-item label="小组名称" >
                                            <el-input v-model="form.groupName"></el-input>
                                        </el-form-item>
                                    </el-col>
                                </el-row>
                                <div class="button-group">
                                    <el-button type="primary">创建小组并参加活动</el-button>
                                </div>
                            </el-form>
                        </div>
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
                title:'申请参加活动',
                user:{
                    username:'',
                    realName:'',
                    avatarSrc: ''
                },
                form:{
                    isNewGroup:true,
                    group:{},
                    groupId:0
                },
                activity:{
                    activityId: '${activity.getActivityId()}',
                    activityName: '${activity.getActivityName()}',
                    activityType:'${activity.getActivityType()}',
                    activityIntroduction:'${activity.getActivityIntroduction()}',
                    gmtCreate:'${activity.getFormattedCreateDate()}',
                    teachers:[
                        <c:forEach items="${activity.getTeacherList()}" var="teacher">
                        {
                            userId:'${teacher.getUserId()}',
                            username:'${teacher.getUsername()}',
                            realName:'${teacher.getRealName()}',
                            userPhone:'${teacher.getUserPhone()}',
                            avatarSrc:'${teacher.getAvatarSrc()}'
                        },
                        </c:forEach>
                    ]
                },
                activeIndex:'3'
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

