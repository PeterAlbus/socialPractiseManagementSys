<%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2021/12/14
  Time: 15:37
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/teacher/activity.css">
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
                        <div class="activity-list">
                            <div class="activity-list-top">
                                <el-input v-model="keyWord" prefix-icon="el-icon-search" placeholder="请输入活动名搜索" style="width: 50%"></el-input>
                                <div>
                                    <el-button type="primary" @click="showAddActivityForm=true">添加活动<i class="el-icon-document-add el-icon--right"></i></el-button>
                                    <el-drawer
                                            v-model="showAddActivityForm"
                                            title="添加社会实践活动"
                                            direction="rtl"
                                    >
                                        <div class="drawer-box">
                                            <el-form ref="form" :rules="rules" :model="form" style="width: 80%" label-width="80px">
                                                <el-form-item label="活动名称" prop="activityName">
                                                    <el-input v-model="form.activityName" autocomplete="off"></el-input>
                                                </el-form-item>
                                                <el-form-item label="活动类型" prop="activityType">
                                                    <el-select
                                                            v-model="form.activityType"
                                                            placeholder="选择活动类型"
                                                    >
                                                        <el-option label="阳光社区" value="阳光社区"></el-option>
                                                        <el-option label="暖心公益" value="暖心公益"></el-option>
                                                    </el-select>
                                                </el-form-item>
                                                <el-form-item label="活动介绍" prop="activityIntroduction">
                                                    <el-input type="textarea" :rows="10" v-model="form.activityIntroduction"></el-input>
                                                </el-form-item>
                                                <el-form-item label="参加人数">
                                                    <el-slider v-model="range" range :max="50" :min="1"> </el-slider>
                                                </el-form-item>
                                                <el-form-item label="" label-width="80px">
                                                    <el-button type="primary" @click="submit('form')" :loading="loading">提交</el-button>
                                                    <el-button>取消</el-button>
                                                </el-form-item>
                                            </el-form>
                                        </div>
                                    </el-drawer>
                                </div>
                            </div>
                            <el-divider content-position="left">负责的活动</el-divider>
                            <div class="activity-list-card" v-for="item in activityListResult">
                                <el-card class="box-card" shadow="hover">
                                    <div class="card-header">
                                        <span>{{item.activityName}}<el-tag size="mini">{{item.activityType}}</el-tag></span>
                                        <el-button class="button" type="text" @click="toModify(item.activityId)">管理</el-button>
                                    </div>
                                </el-card>
                            </div>
                            <div class="activity-list-top">
                                <el-input v-model="keyWord1" prefix-icon="el-icon-search" placeholder="请输入活动名搜索" style="width: 50%"></el-input>
                                <div>
                                    <el-button type="primary" @click="showAddActivityForm=true">添加活动<i class="el-icon-document-add el-icon--right"></i></el-button>
                                </div>
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
                            <div class="activity-list-card" v-for="item in currentPageAllActivities">
                                <el-card class="box-card" shadow="hover">
                                    <template #header>
                                        <div class="card-header">
                                            <span>{{item.activityName}}<el-tag size="mini">{{item.activityType}}</el-tag></span>
                                            <el-button class="button" type="text" @click="toDetail(item.activityId)">查看详情</el-button>
                                        </div>
                                    </template>
                                    <div>
                                        <h5>负责老师:<span v-for="i in item.teachers">{{i.realName}}&emsp;</span></h5>
                                        <p>要求人数:{{item.minPeople}}-{{item.maxPeople}}人</p>
                                        <p>{{item.activityIntroduction}}</p>
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
                title:'社会实践列表',
                user:{
                    username:'',
                    realName:'',
                    avatarSrc: ''
                },
                form: {
                    activityName: '',
                    activityType: '',
                    activityIntroduction: '',
                    minPeople:1,
                    maxPeople:12
                },
                range:[1,12],
                rules: {
                    activityName: [
                        { required: true, message: '请填写活动名称', trigger: 'blur' }
                    ],
                    activityType: [
                        { required: true, message: '请选择活动类型', trigger: 'blur' }
                    ],
                    activityIntroduction: [
                        { required: true, message: '请填写活动简介', trigger: 'blur' }
                    ],
                },
                activeIndex:'2',
                keyWord:'',
                keyWord1:'',
                activityList:[],
                allActivities:[],
                currentPage:1,
                pageSize:5,
                loading:false,
                showAddActivityForm:false
            }
        },
        mounted(){
            this.user.realName='${realName}'
            this.user.username='${username}'
            this.user.avatarSrc='${avatarSrc}'
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
                if(this.keyWord==='')
                {
                    return this.activityList;
                }
                for(let i=0;i<this.activityList.length;i++)
                {
                    let str=this.activityList[i].activityName;
                    if(str.search(this.keyWord)!==-1)
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
            submit(name) {
                this.$refs[name].validate((valid) => {
                    if (valid) {
                        this.loading=true
                        this.form.minPeople=this.range[0]
                        this.form.maxPeople=this.range[1]
                        axios({
                            method: "post",
                            url: "/teacher/addActivity",
                            data: this.form,
                            transformRequest: [ function(data){
                                return Qs.stringify(data)  //使用Qs将请求参数序列化
                            }],
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded'  //必须设置传输方式
                            }
                        })
                            .then(res=>{
                                this.loading=false
                                if(res.data==="error")
                                {
                                    this.$message.error('创建活动失败!')
                                }
                                else
                                {
                                    this.$messageBox.confirm(
                                        '创建活动成功，查看详情?',
                                        '成功',
                                        {
                                            confirmButtonText: '确认',
                                            cancelButtonText: '留在此页',
                                            type: 'success',
                                        }
                                    )
                                        .then(() => {

                                        })
                                        .catch(() => {
                                            location.href="/teacher/activities"
                                        })
                                }
                            })
                    }
                })
            },
            toDetail(id){
                location.href="/teacher/activityDetail?activityId="+id
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
