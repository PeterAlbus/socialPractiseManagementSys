<%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2021/12/4
  Time: 15:08
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>主页</title>
    <!-- 导入 Vue 3 -->
    <script src="${pageContext.request.contextPath}/vue/vue@next/vue.global.js"></script>
    <!-- 导入组件库 -->
    <script src="${pageContext.request.contextPath}/vue/element/index.full.js"></script>
    <script src="${pageContext.request.contextPath}/vue/axios/axios.js"></script>
    <script src="${pageContext.request.contextPath}/vue/qs.min.js"></script>
    <!-- 引入样式 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/vue/font-awesome/css/font-awesome.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/teacher/activity.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="//unpkg.com/element-plus@1.1.0-beta.9/dist/index.css"/>
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
                        <el-row>
                            <el-col :span="12">
                                <div style="margin: 5px;">
                                    <el-card class="box-card" shadow="hover">
                                        <template #header>
                                            <div class="card-header" style="padding: 5px">
                                                <span>我的活动</span>
                                                <el-button class="button" type="text" @click="toActivities">查看全部</el-button>
                                            </div>
                                        </template>
                                        <div>
                                            <el-empty description="暂无数据" v-if="activityList.length==0"></el-empty>
                                            <div v-for="item in activityList.slice(0,4)" class="card-header" style="padding: 5px">
                                                <div>
                                                    {{item.activityName}}<el-tag size="mini">{{item.activityType}}</el-tag><br>
                                                    {{item.minPeople}}-{{item.maxPeople}}人
                                                </div>
                                                <el-button @click="toDetail(item.activityId)" type="primary" size="mini">查看详情</el-button>
                                            </div>
                                        </div>
                                    </el-card>
                                </div>
                                <div style="margin: 5px;">
                                    <el-card class="box-card" shadow="hover">
                                        <template #header>
                                            <div class="card-header">
                                                <span>活动推荐</span>
                                                <el-button class="button" type="text" @click="getRandomActivities">换一批</el-button>
                                            </div>
                                        </template>
                                        <div>
                                            <el-empty description="暂无数据" v-if="randomActivities.length==0"></el-empty>
                                            <div v-for="item in randomActivities.slice(0,6)" class="card-header" style="padding: 5px">
                                                <div>
                                                    {{item.activityName}}<el-tag size="mini">{{item.activityType}}</el-tag><br>
                                                    {{item.minPeople}}-{{item.maxPeople}}人
                                                </div>
                                                <el-button @click="toNotPartDetail(item.activityId)" type="primary" size="mini">查看详情</el-button>
                                            </div>
                                        </div>
                                    </el-card>
                                </div>
                            </el-col>
                            <el-col :span="12">
                                <div style="margin: 5px;">
                                    <el-card class="box-card" shadow="hover">
                                        <template #header>
                                            <div class="card-header">
                                                <span>新消息</span>
                                                <el-button class="button" type="text" onclick="location.href='/messageList'">查看详情</el-button>
                                            </div>
                                        </template>
                                        <div>
                                            <el-empty description="暂无新消息" v-if="newMessageList.length==0"></el-empty>
                                            <div v-for="item in newMessageList.slice(0,6)" style="padding: 5px">{{item.sender}}:{{item.title}}</div>
                                        </div>
                                    </el-card>
                                </div>
                                <div style="margin: 5px;">
                                    <el-card class="box-card" shadow="hover">
                                        <template #header>
                                            <div class="card-header">
                                                <span>一言</span>
                                                <el-button class="button" type="text" @click="getQuotes">换一句</el-button>
                                            </div>
                                        </template>
                                        <div>
                                            <div>「 {{famousQuotes.hitokoto}} 」</div>
                                            <div>————《{{famousQuotes.from}}》 {{famousQuotes.from_who}}</div>
                                        </div>
                                    </el-card>
                                </div>
                            </el-col>
                        </el-row>
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
            return {
                title: '主页',
                user: {
                    username: '',
                    realName: '',
                    avatarSrc: ''
                },
                famousQuotes: {
                    id: 0,
                    uuid: "",
                    hitokoto: "",
                    type: "",
                    from: "",
                    from_who: null,
                    creator: "",
                    creator_uid: 0,
                    reviewer: 0,
                    commit_from: "",
                    created_at: "",
                    length: 0
                },
                activityList:[],
                allActivities:[],
                randomActivities:[],
                newMessageList:[],
                activeIndex: '1'
            }
        },
        mounted() {
            this.getQuotes()
            this.user.realName = '${realName}'
            this.user.username = '${username}'
            this.user.avatarSrc = '${avatarSrc}'
            this.user.userClass = '${userClass}'
            <c:if test="${newMessageList.size()!=0}">
            this.$notify.info({
                title: '有新消息:${newMessageList.get(0).getMessageTitle()}',
                message: '${newMessageList.get(0).getMessageContent()}',
                offset: 100,
            })
            </c:if>
            <c:forEach items="${newMessageList}" var="message">
            this.newMessageList.push({
                title: '${message.getMessageTitle()}',
                message: '${message.getMessageContent()}',
                sender: '${message.getMessageSender()}',
            })
            </c:forEach>
            <c:forEach items="${activityList}" var="activity">
            this.activityList.push({
                activityId: '${activity.getActivityId()}',
                activityName: '${activity.getActivityName()}',
                activityType:'${activity.getActivityType()}',
                activityIntroduction:'${activity.getActivityIntroduction()}',
                minPeople:'${activity.getMinPeople()}',
                maxPeople:'${activity.getMaxPeople()}',
                gmtCreate:'${activity.getFormattedCreateDate()}',
            })
            </c:forEach>
            <c:forEach items="${allActivities}" var="activity">
            this.allActivities.push({
                activityId: '${activity.getActivityId()}',
                activityName: '${activity.getActivityName()}',
                activityType:'${activity.getActivityType()}',
                activityIntroduction:'${activity.getActivityIntroduction()}',
                minPeople:'${activity.getMinPeople()}',
                maxPeople:'${activity.getMaxPeople()}',
                gmtCreate:'${activity.getFormattedCreateDate()}',
            })
            </c:forEach>
            this.getRandomActivities()
        },
        methods: {
            goBack() {
                window.history.go(-1);
            },
            getQuotes(){
                axios({
                    method: "get",
                    url: "https://v1.hitokoto.cn/?c=c&c=b&c=a&encode=json",
                })
                    .then(res=>{
                        this.famousQuotes=res.data
                    })
            },
            getRandomActivities(){
                let indexList=[]
                this.randomActivities=[]
                let random=0
                while (1)
                {
                    if(indexList.length>=this.allActivities.length||indexList.length>=6){
                        break
                    }
                    random=Math.floor(Math.random()*this.allActivities.length)
                    if(indexList.indexOf(random)<=-1)
                    {
                        indexList.push(random)
                    }
                }
                for(let i of indexList)
                {
                    this.randomActivities.push(this.allActivities[i])
                }
            },
            toNotPartDetail(id) {
                if(this.user.userClass==='1')
                {
                    location.href='/student/applyActivity?activityId='+id
                }
                if(this.user.userClass==='2'||this.user.userClass==='0')
                {
                    location.href='/teacher/activityDetail?activityId='+id
                }
            },
            toDetail(id) {
                if(this.user.userClass==='1')
                {
                    location.href='/student/manageActivity?activityId='+id
                }
                if(this.user.userClass==='2')
                {
                    location.href='/teacher/modifyActivity?activityId='+id
                }
            },
            toActivities() {
                if(this.user.userClass==='0')
                {
                    location.href='/teacher/activities'
                }
                if(this.user.userClass==='1')
                {
                    location.href='/student/activities'
                }
                if(this.user.userClass==='2')
                {
                    location.href='/teacher/activities'
                }
            }
        }
    };
    const app = Vue.createApp(App);
    app.use(ElementPlus);
    app.mount("#app");
</script>
</body>
</html>
