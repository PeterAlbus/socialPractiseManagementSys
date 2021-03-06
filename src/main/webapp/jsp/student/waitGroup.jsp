<%--
  Created by IntelliJ IDEA.
  User: peteralbus
  Date: 2021/12/19
  Time: 22:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>小组正在形成</title>
    <!-- 导入 Vue 3 -->
    <script src="${pageContext.request.contextPath}/vue/vue@next/vue.global.js"></script>
    <!-- 导入组件库 -->
    <script src="${pageContext.request.contextPath}/vue/element/index.full.js"></script>
    <script src="${pageContext.request.contextPath}/vue/axios/axios.js"></script>
    <script src="${pageContext.request.contextPath}/vue/qs.min.js"></script>
    <!-- 引入样式 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/vue/font-awesome/css/font-awesome.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
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
                        <el-steps :active="1" finish-status="success" simple>
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
                                <template #extra>
                                    <el-link type="primary" @click="deleteParticipate">退出小组</el-link>&emsp;
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
                                        活动人数
                                    </template>
                                    {{activity.minPeople}}-{{activity.maxPeople}}人
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
                        <el-divider content-position="left">当前状态</el-divider>
                        <el-result
                                icon="info"
                                title="您已成功提交申请"
                                :sub-title="currentStatus"
                        >
                        </el-result>
                        <div>
                            <el-descriptions title="小组信息" border>
                                <el-descriptions-item label="小组名">{{group.groupName}}</el-descriptions-item>
                                <el-descriptions-item label="组长姓名">{{group.leaderName}}</el-descriptions-item>
                                <el-descriptions-item label="已加入组员数">{{group.memberCount}}</el-descriptions-item>
                            </el-descriptions>
                            <h4>成员信息</h4>
                            <el-table :data="memberList" style="width: 100%" stripe>
                                <el-table-column prop="username" label="用户名"></el-table-column>
                                <el-table-column prop="realName" label="姓名">
                                    <template #default="scope">
                                        <el-link type="primary" :href="'/user?userId='+scope.row.userId">{{scope.row.realName}}</el-link>
                                    </template>
                                </el-table-column>
                                <el-table-column align="right" label="加入状态">
                                    <template #default="scope">
                                        <el-button size="mini" @click="accept(scope.row.participateId)" v-if="(!scope.row.isAccept)&&user.userId==group.leaderId">通过</el-button>
                                        <el-button size="mini" @click="refuse(scope.row.participateId)" v-if="(!scope.row.isAccept)&&user.userId==group.leaderId" type="danger">拒绝</el-button>
                                        <el-tag type="success" v-if="scope.row.isAccept">已通过</el-tag>
                                        <el-tag type="info" v-if="(!scope.row.isAccept)&&user.userId!=group.leaderId">审核中</el-tag>
                                    </template>
                                </el-table-column>
                            </el-table>
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
                title:'小组正在形成',
                user:{
                    username:'',
                    realName:'',
                    avatarSrc: '',
                    userId:''
                },
                participationId:'${participationId}',
                currentStatus:'${currentStatus}',
                activity:{
                    activityId: '${activity.getActivityId()}',
                    activityName: '${activity.getActivityName()}',
                    activityType:'${activity.getActivityType()}',
                    activityIntroduction:'${activity.getActivityIntroduction()}',
                    minPeople:'${activity.getMinPeople()}',
                    maxPeople:'${activity.getMaxPeople()}',
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
                group:{
                    groupId:'${group.getGroupId()}',
                    groupName:'${group.getGroupName()}',
                    leaderId:'${group.getLeaderId()}',
                    leaderName: '${group.getLeaderName()}',
                    memberCount: '${group.getMemberCount()}'
                },
                memberList:[
                    <c:forEach items="${memberList}" var="member">
                    {
                        participateId:'${member.getParticipationId()}',
                        userId:'${member.getUserId()}',
                        username:'${member.getUsername()}',
                        realName:'${member.getRealName()}',
                        isAccept:${member.getAccept()}
                    },
                    </c:forEach>
                ],
                activeIndex:'3'
            }
        },
        mounted(){
            this.user.realName='${realName}'
            this.user.username='${username}'
            this.user.avatarSrc='${avatarSrc}'
            this.user.userId='${userId}'
            <c:if test="${newMessageList.size()!=0}">
            this.$notify.info({
                title: '有新消息:${newMessageList.get(0).getMessageTitle()}',
                message: '${newMessageList.get(0).getMessageContent()}',
                offset: 100,
            })
            </c:if>
        },
        methods: {
            goBack(){
                window.history.go(-1);
            },
            accept(id){
                this.$messageBox.confirm(
                    '小组成员加入后，不可再抛弃了哦，确认通过申请？',
                    '警告',
                    {
                        confirmButtonText: '确认',
                        cancelButtonText: '取消',
                        type: 'warning',
                    }
                )
                    .then(() => {
                        axios({
                            method: "get",
                            url: "/student/acceptJoin?participateId="+id,
                            })
                            .then(res => {
                                if(res.data==="success")
                                {
                                    location.reload();
                                }
                                else
                                {
                                    this.$message.error("出现异常，通过失败")
                                }
                            })
                            .catch(res=>{
                                this.$message.error("出现异常，通过失败")
                            })
                    })
            },
            refuse(id){
                this.$messageBox.confirm(
                    '确认要拒绝该同学的申请吗？',
                    '警告',
                    {
                        confirmButtonText: '确认',
                        cancelButtonText: '取消',
                        type: 'warning',
                    }
                )
                    .then(() => {
                        axios({
                            method: "get",
                            url: "/student/refuseJoin?participateId="+id,
                        })
                            .then(res => {
                                if(res.data==="success")
                                {
                                    location.reload();
                                }
                                else
                                {
                                    this.$message.error("出现异常，拒绝失败")
                                }
                            })
                            .catch(res=>{
                                this.$message.error("出现异常，拒绝失败")
                            })
                    })
            },
            deleteParticipate(){
                this.$messageBox.confirm(
                    '确认退出吗？你填写的活动记录将消失！',
                    '警告',
                    {
                        confirmButtonText: '确认',
                        cancelButtonText: '取消',
                        type: 'warning',
                    }
                )
                    .then(() => {
                        axios({
                            method: "get",
                            url: "/student/deleteParticipate?participationId="+this.participationId,
                        })
                            .then(res => {
                                if(res.data==="success")
                                {
                                    location.href="/student/activities";
                                }
                                else
                                {
                                    this.$message.error("组长在组员没有退出时，不能退出社会实践活动！")
                                }
                            })
                            .catch(res=>{
                                this.$message.error("出现异常，提交失败")
                            })
                    })
            }
        }
    };
    const app = Vue.createApp(App);
    app.use(ElementPlus);
    app.mount("#app");
</script>
</body>
</html>
