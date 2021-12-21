<%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2021/12/16
  Time: 14:20
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/teacher/modifyActivity.css">
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
                    <el-dialog
                            v-model="dialogVisible"
                            title="选择老师"
                            width="50%"
                    >
                        <el-table :data="teacherListResultPagination" style="width: 100%">
                            <el-table-column prop="username" label="用户名"></el-table-column>
                            <el-table-column prop="realName" label="姓名"></el-table-column>
                            <el-table-column align="right">
                                <template #header>
                                    <el-input v-model="keyWord" size="mini" placeholder="搜索姓名/用户名"></el-input>
                                </template>
                                <template #default="scope">
                                    <el-button size="mini" @click="addTeacher(scope.row.userId)" type="primary">添加</el-button>
                                </template>
                            </el-table-column>
                        </el-table>
                        <el-pagination
                                background
                                layout="total, prev, pager, next"
                                :total="teacherListResult.length"
                                :page-size="5"
                                v-model:current-page="currentPage">
                        </el-pagination>
                    </el-dialog>
                    <el-page-header icon="el-icon-arrow-left" :content="title" @back="goBack"></el-page-header>
                    <br/>
                    <div class="container">
                        <el-divider content-position="left">编辑活动信息</el-divider>
                        <div class="modifyForm">
                            <el-form ref="form" :rules="rules" :model="activity" style="width: 100%" label-width="80px">
                                <el-form-item label="活动名称" prop="activityName">
                                    <el-input v-model="activity.activityName" autocomplete="off"></el-input>
                                </el-form-item>
                                <el-form-item label="活动类型" prop="activityType">
                                    <el-select
                                            v-model="activity.activityType"
                                            placeholder="选择活动类型"
                                    >
                                        <el-option label="阳光社区" value="阳光社区"></el-option>
                                        <el-option label="暖心公益" value="暖心公益"></el-option>
                                    </el-select>
                                </el-form-item>
                                <el-form-item label="负责老师">
                                    <span v-for="i in activity.teachers">{{i.realName}}&emsp;</span>
                                    <el-button @click="dialogVisible=true" size="small" type="primary">添加</el-button>
                                </el-form-item>
                                <el-form-item label="参加人数">
                                    <el-slider v-model="range" range :max="50" :min="1"> </el-slider>
                                </el-form-item>
                                <el-form-item label="活动介绍" prop="activityIntroduction">
                                    <el-input type="textarea" :rows="10" v-model="activity.activityIntroduction"></el-input>
                                </el-form-item>
                                <div class="button-group">
                                    <el-button type="primary" @click="submit('form')" :loading="loading">更改</el-button>
                                    <el-button type="danger" @click="deleteActivity">删除</el-button>
                                </div>
                            </el-form>
                        </div>
                        <el-divider content-position="left">参加活动的小组</el-divider>
                        <div>
                            <el-collapse>
                                <el-collapse-item :name="item.groupId" v-for="item in groupList" style="width:100%">
                                    <template #title>
                                        <div class="group-list-top">
                                            <div>
                                                {{item.groupName}}-组长:{{item.leaderName}}, 组员数量:{{item.memberCount}}<el-tag type="success" v-if="item.isFinished" size="small">已完成</el-tag>
                                            </div>
                                            <div>
                                                <el-button type="primary" size="mini" @click="manageGroup(item.groupId)">管理该小组</el-button>
                                            </div>
                                        </div>
                                    </template>
                                    <el-table :data="item.memberList" style="width: 100%" stripe>
                                        <el-table-column prop="username" label="用户名"></el-table-column>
                                        <el-table-column prop="realName" label="姓名"></el-table-column>
                                        <el-table-column align="right" label="加入状态">
                                            <template #default="scope">
                                                <el-tag type="success" v-if="scope.row.isAccept">已通过</el-tag>
                                                <el-tag type="info" v-if="!scope.row.isAccept">审核中</el-tag>
                                            </template>
                                        </el-table-column>
                                    </el-table>
                                </el-collapse-item>
                            </el-collapse>
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
                title:'管理社会实践活动',
                user:{
                    username:'',
                    realName:'',
                    avatarSrc: ''
                },
                range:[${activity.getMinPeople()},${activity.getMaxPeople()}],
                loading:false,
                dialogVisible:false,
                currentPage:1,
                keyWord:'',
                activity:{
                    activityId: '${activity.getActivityId()}',
                    activityName: '${activity.getActivityName()}',
                    activityType:'${activity.getActivityType()}',
                    activityIntroduction:'${activity.getActivityIntroduction()}',
                    minPeople:${activity.getMinPeople()},
                    maxPeople:${activity.getMaxPeople()},
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
                groupList: [
                    <c:forEach items="${groupList}" var="group">
                    {
                        groupId:'${group.getGroupId()}',
                        groupName:'${group.getGroupName()}',
                        leaderName:'${group.getLeaderName()}',
                        memberCount:'${group.getMemberCount()}',
                        isFinished:${group.getFinished()},
                        memberList:[
                            <c:forEach items="${group.getMemberList()}" var="member">
                            {
                                participateId:'${member.getParticipationId()}',
                                userId:'${member.getUserId()}',
                                username:'${member.getUsername()}',
                                realName:'${member.getRealName()}',
                                isAccept:${member.getAccept()}
                            },
                            </c:forEach>
                        ]
                    },
                    </c:forEach>
                ],
                teacherList:[
                    <c:forEach items="${teacherList}" var="teacher">
                    {
                        userId:'${teacher.getUserId()}',
                        username:'${teacher.getUsername()}',
                        realName:'${teacher.getRealName()}',
                    },
                    </c:forEach>
                ],
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
                activeIndex:'2'
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
        },
        computed:{
            teacherListResult:function (){
                let result=[];
                for(let i=0;i<this.teacherList.length;i++)
                {
                    let str=this.teacherList[i].realName
                    let str1=this.teacherList[i].username
                    if(str.search(this.keyWord)!==-1||str1.search(this.keyWord)!==-1)
                    {
                        result.push(this.teacherList[i]);
                    }
                }
                return result;
            },
            teacherListResultPagination:function (){
                return this.teacherListResult.slice((this.currentPage-1)*5,this.currentPage*5)
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
                        this.activity.minPeople=this.range[0]
                        this.activity.maxPeople=this.range[1]
                        axios({
                            method: "post",
                            url: "/teacher/updateActivity",
                            data: this.activity,
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
                                    this.$message.error('更改活动内容失败!')
                                }
                                else
                                {
                                    this.$message.success('更改成功!')
                                }
                            })
                    }
                })
            },
            manageGroup(id){
                location.href="/teacher/manageGroup?groupId="+id
            },
            addTeacher(id){
                this.$messageBox.confirm(
                    '确认要添加改老师为负责老师吗，该老师将拥有与你相同的权限？',
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
                            url: "/teacher/addTeacherToActivity?userId="+id+"&activityId="+this.activity.activityId,
                        }).then(res=>{
                            this.loading=false
                            if(res.data==="error")
                            {
                                this.$message.error('添加失败!')
                            }
                            else if(res.data==="exist")
                            {
                                this.$message.error('该老师已经是负责老师!')
                            }
                            else
                            {
                                location.reload()
                            }
                        })
                    })
            },
            deleteActivity(){
                this.$messageBox.confirm(
                    '确认要删除该活动吗，其下属的所有小组也将丢失！',
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
                            url: "/teacher/deleteActivity?activityId="+this.activity.activityId,
                        }).then(res=>{
                            this.loading=false
                            if(res.data==="error")
                            {
                                this.$message.error('删除失败!')
                            }
                            else
                            {
                                location.href="/teacher/activities"
                            }
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
