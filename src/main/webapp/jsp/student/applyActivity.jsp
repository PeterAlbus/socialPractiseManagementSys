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
    <script src="${pageContext.request.contextPath}/vue/axios/axios.js"></script>
    <script src="${pageContext.request.contextPath}/vue/qs.min.js"></script>
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
                                            <el-input v-model="form.group.groupName"></el-input>
                                        </el-form-item>
                                    </el-col>
                                </el-row>
                                <div class="button-group" v-if="form.isNewGroup">
                                    <el-button type="primary" @click="newGroup">创建小组并参加活动</el-button>
                                </div>
                                <div class="group-list" v-if="!form.isNewGroup">
                                    <el-table :data="groupListResult" style="width: 100%">
                                        <el-table-column prop="groupName" label="小组名"></el-table-column>
                                        <el-table-column prop="gmtCreate" label="创建日期"></el-table-column>
                                        <el-table-column prop="leaderName" label="组长姓名"></el-table-column>
                                        <el-table-column align="right">
                                            <template #header>
                                                <el-input v-model="keyWord" size="mini" placeholder="搜索姓名/组名"></el-input>
                                            </template>
                                            <template #default="scope">
                                                <el-button size="mini" @click="joinGroup(scope.row.groupId)" v-if="!scope.row.isFinished">加入</el-button>
                                                <el-tag type="success" v-if="scope.row.isFinished" size="small">该小组已完成</el-tag>
                                            </template>
                                        </el-table-column>
                                    </el-table>
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
                    group:{
                        groupName:'',
                        activityId:'${activity.getActivityId()}'
                    }
                },
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
                groupList:[
                    <c:forEach items="${groupList}" var="group">
                    {
                        groupId:'${group.getGroupId()}',
                        groupName:'${group.getGroupName()}',
                        leaderId:'${group.getLeaderId()}',
                        leaderName:'${group.getLeaderName()}',
                        isFinished:${group.getFinished()},
                        gmtCreate:'${group.getFormattedCreateDate()}'
                    },
                    </c:forEach>
                ],
                keyWord:'',
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
            },
            newGroup(){
                this.$messageBox.confirm(
                    '参与社会实践活动后不可更改小组，不可退出，确认申请？',
                    '警告',
                    {
                        confirmButtonText: '确认',
                        cancelButtonText: '取消',
                        type: 'warning',
                    }
                )
                    .then(() => {
                        axios({
                            method: "post",
                            url: "/student/participateWithNewGroup",
                            data: this.form.group,
                            transformRequest: [ function(data){
                                return Qs.stringify(data)  //使用Qs将请求参数序列化
                            }],
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded'  //必须设置传输方式
                            }
                        }).then(res=>{
                            this.loading=false
                            if(res.data==="error")
                            {
                                this.$message.error('创建小组失败!')
                            }
                            else
                            {
                                location.href="/student/manageActivity?activityId="+this.activity.activityId
                            }
                        })
                    })
            },
            joinGroup(id){
                this.$messageBox.confirm(
                    '参与社会实践活动后不可更改小组，不可退出，确认申请？',
                    '警告',
                    {
                        confirmButtonText: '确认',
                        cancelButtonText: '取消',
                        type: 'warning',
                    }
                )
                    .then(() => {
                        axios({
                            method: "post",
                            url: "/student/participateWithOldGroup",
                            data: {
                                groupId:id
                            },
                            transformRequest: [ function(data){
                                return Qs.stringify(data)  //使用Qs将请求参数序列化
                            }],
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded'  //必须设置传输方式
                            }
                        }).then(res=>{
                            this.loading=false
                            if(res.data==="error")
                            {
                                this.$message.error('创建小组失败!')
                            }
                            else
                            {
                                location.href="/student/manageActivity?activityId="+this.activity.activityId
                            }
                        })
                    })
            }
        },
        computed:{
            groupListResult:function (){
                let result=[];
                if(this.keyWord==='')
                {
                    return this.groupList;
                }
                for(let i=0;i<this.groupList.length;i++)
                {
                    let str=this.groupList[i].groupName;
                    let str_leader=this.groupList[i].leaderName;
                    if(str.search(this.keyWord)!==-1||str_leader.search(this.keyWord)!==-1)
                    {
                        result.push(this.groupList[i]);
                    }
                }
                return result;
            },
        }
    };
    const app = Vue.createApp(App);
    app.use(ElementPlus);
    app.mount("#app");
</script>
</body>
</html>

