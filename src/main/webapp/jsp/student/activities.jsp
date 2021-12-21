<%--
  Created by IntelliJ IDEA.
  User: peteralbus
  Date: 2021/12/18
  Time: 12:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>社会实践活动列表</title>
    <!-- 导入 Vue 3 -->
    <script src="${pageContext.request.contextPath}/vue/vue@next/vue.global.js"></script>
    <!-- 导入组件库 -->
    <script src="${pageContext.request.contextPath}/vue/element/index.full.js"></script>
    <!-- 引入样式 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/vue/font-awesome/css/font-awesome.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/teacher/activity.css">
    <link rel="stylesheet" href="//unpkg.com/element-plus@1.1.0-beta.9/dist/index.css" />
</head>
<body>
<div id="app">
    <el-dialog
            v-model="dialogVisible"
            title="查看详情"
    >
        <div style="text-align:center">
            <el-descriptions
                    title="活动情况"
                    :column="1"
                    border
            >
                <template #extra>
                    <el-button type="primary" size="small" @click="toApply(showedActivity.activityId)">申请参与活动</el-button>
                </template>
                <el-descriptions-item>
                    <template #label>
                        活动名称
                    </template>
                    {{showedActivity.activityName}}
                </el-descriptions-item>
                <el-descriptions-item>
                    <template #label>
                        活动类别
                    </template>
                    {{showedActivity.activityType}}
                </el-descriptions-item>
                <el-descriptions-item>
                    <template #label>
                        活动人数
                    </template>
                    {{showedActivity.minPeople}}-{{showedActivity.maxPeople}}人
                </el-descriptions-item>
                <el-descriptions-item>
                    <template #label>
                        创建日期
                    </template>
                    {{showedActivity.gmtCreate}}
                </el-descriptions-item>
            </el-descriptions>
        </div>
        <br/>
        <div>
            <el-descriptions :column="1" border direction="vertical">
                <el-descriptions-item>
                    <template #label>
                        简介
                    </template>
                    {{showedActivity.activityIntroduction}}
                </el-descriptions-item>
            </el-descriptions>
        </div>
    </el-dialog>
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
                        <div class="activity-list">
                            <div class="activity-list-top">
                                <el-input v-model="keyWord" prefix-icon="el-icon-search" placeholder="请输入活动名搜索" style="width: 50%"></el-input>
                                <el-switch
                                        v-model="showFinished"
                                        active-text="显示已完成"
                                        inactive-text="不显示已完成">
                                </el-switch>
                            </div>
                            <el-divider content-position="left">参加的活动</el-divider>
                            <div class="activity-list-card" v-for="item in activityListResult">
                                <el-card class="box-card" shadow="hover">
                                    <div class="card-header">
                                        <span>{{item.activityName}}<el-tag size="mini">{{item.activityType}}</el-tag><el-tag effect="dark" type="success" size="mini" v-if="item.isFinished">已完成</el-tag></span>
                                        <el-button class="button" type="text" @click="toManage(item.activityId)">管理</el-button>
                                    </div>
                                </el-card>
                            </div>
                            <div class="activity-list-top">
                                <el-input v-model="keyWord1" prefix-icon="el-icon-search" placeholder="请输入活动名搜索" style="width: 50%"></el-input>
                            </div>
                            <el-divider content-position="left">所有活动</el-divider>
                            <div style="text-align: center">
                                <el-pagination
                                        background
                                        layout="total, sizes ,prev, pager, next, jumper"
                                        :total="allActivitiesResult.length"
                                        :page-sizes="[5, 10, 20, 40]"
                                        v-model:page-size="pageSize"
                                        v-model:current-page="currentPage">
                                </el-pagination>
                            </div>
                            <div class="activity-list-card" v-for="(item,index) in currentPageAllActivities">
                                <el-card class="box-card" shadow="hover">
                                    <template #header>
                                        <div class="card-header">
                                            <span>{{item.activityName}}<el-tag size="mini">{{item.activityType}}</el-tag></span>
                                            <el-button class="button" type="text" @click="showDetail(index)">查看详情</el-button>
                                        </div>
                                    </template>
                                    <div>
                                        <h5>负责老师:<span v-for="i in item.teachers">{{i.realName}}&emsp;</span></h5>
                                        <p>要求人数:{{item.minPeople}}-{{item.maxPeople}}人</p>
                                    </div>
                                </el-card>
                            </div>
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
                title:'社会实践活动列表',
                keyWord:'',
                keyWord1: '',
                showFinished:true,
                user:{
                    username:'',
                    realName:'',
                    avatarSrc: ''
                },
                activityList:[],
                allActivities:[],
                showedActivity:{
                    activityId: '',
                    activityName: '',
                    activityType:'',
                    activityIntroduction:''
                },
                dialogVisible:false,
                currentPage:1,
                pageSize:5,
                activeIndex:'3'
            }
        },
        mounted(){
            this.user.realName='${realName}'
            this.user.username='${username}'
            this.user.avatarSrc='${avatarSrc}'
            <c:if test="${newMessageList.size()!=0}">
            this.$notify.info({
                title: '有新消息:${newMessageList.get(0).getMessageTitle()}',
                message: '${newMessageList.get(0).getMessageContent()}',
                offset: 100,
            })
            </c:if>
            let teachers
            <c:forEach items="${activityList}" var="activity">
            teachers=[]
            <c:forEach items="${activity.getTeacherList()}" var="teacher">
            teachers.push({
                userId:'${teacher.getUserId()}',
                username:'${teacher.getUsername()}',
                realName:'${teacher.getRealName()}',
                userPhone:'${teacher.getUserPhone()}',
                avatarSrc:'${teacher.getAvatarSrc()}'
            })
            </c:forEach>
            this.activityList.push({
                activityId: '${activity.getActivityId()}',
                activityName: '${activity.getActivityName()}',
                activityType:'${activity.getActivityType()}',
                activityIntroduction:'${activity.getActivityIntroduction()}',
                minPeople:'${activity.getMinPeople()}',
                maxPeople:'${activity.getMaxPeople()}',
                gmtCreate:'${activity.getFormattedCreateDate()}',
                isFinished:${activity.getFinished()},
                teachers:teachers
            })
            </c:forEach>
            <c:forEach items="${allActivities}" var="activity">
            teachers=[]
            <c:forEach items="${activity.getTeacherList()}" var="teacher">
            teachers.push({
                userId:'${teacher.getUserId()}',
                username:'${teacher.getUsername()}',
                realName:'${teacher.getRealName()}',
                userPhone:'${teacher.getUserPhone()}',
                avatarSrc:'${teacher.getAvatarSrc()}'
            })
            </c:forEach>
            this.allActivities.push({
                activityId: '${activity.getActivityId()}',
                activityName: '${activity.getActivityName()}',
                activityType:'${activity.getActivityType()}',
                activityIntroduction:'${activity.getActivityIntroduction()}',
                minPeople:'${activity.getMinPeople()}',
                maxPeople:'${activity.getMaxPeople()}',
                gmtCreate:'${activity.getFormattedCreateDate()}',
                teachers:teachers
            })
            </c:forEach>
        },
        computed:{
            activityListResult:function (){
                let result=[];
                for(let i=0;i<this.activityList.length;i++)
                {
                    let str=this.activityList[i].activityName;
                    if(str.search(this.keyWord)!==-1&&(!this.activityList[i].isFinished||this.showFinished))
                    {
                        result.push(this.activityList[i]);
                    }
                }
                return result;
            },
            allActivitiesResult:function (){
                let result=[];
                if(this.keyWord1==='')
                {
                    return this.allActivities;
                }
                for(let i=0;i<this.allActivities.length;i++)
                {
                    let str=this.allActivities[i].activityName;
                    if(str.search(this.keyWord1)!==-1)
                    {
                        result.push(this.allActivities[i]);
                    }
                }
                return result;
            },
            currentPageAllActivities:function (){
                return this.allActivitiesResult.slice((this.currentPage-1)*this.pageSize,this.currentPage*this.pageSize)
            }
        },
        methods: {
            goBack(){
                window.history.go(-1);
            },
            showDetail(index){
                this.showedActivity=this.currentPageAllActivities[index];
                this.dialogVisible=true
            },
            toApply(id){
                location.href="/student/applyActivity?activityId="+id
            },
            toManage(id){
                location.href="/student/manageActivity?activityId="+id
            }
        }
    };
    const app = Vue.createApp(App);
    app.use(ElementPlus);
    app.mount("#app");
</script>
</body>
</html>
