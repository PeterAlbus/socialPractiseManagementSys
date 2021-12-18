<%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2021/12/16
  Time: 14:20
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
                    <el-page-header icon="el-icon-arrow-left" :content="title" @back="goBack"></el-page-header>
                    <br/>
                    <div class="container modifyForm">
                        <el-form ref="activity" :rules="rules" :model="form" style="width: 100%">
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
                            <el-form-item label="活动介绍" prop="activityIntroduction">
                                <el-input type="textarea" :rows="10" v-model="activity.activityIntroduction"></el-input>
                            </el-form-item>
                            <div class="button-group">
                                <el-button type="primary" @click="submit('form')" :loading="loading">更改</el-button>
                                <el-button type="danger">删除</el-button>
                            </div>
                        </el-form>
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
                activity:{
                    activityId: '${activity.getActivityId()}',
                    activityName: '${activity.getActivityName()}',
                    activityType:'${activity.getActivityType()}',
                    activityIntroduction:'${activity.getActivityIntroduction()}',
                    gmtCreate:'${activity.getFormattedCreateDate()}'
                },
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
        },
        methods: {
            goBack(){
                window.history.go(-1);
            },
            submit(name) {
                this.$refs[name].validate((valid) => {
                    if (valid) {
                        this.loading=true
                        axios({
                            method: "post",
                            url: "/teacher/modifyActivity",
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
        }
    };
    const app = Vue.createApp(App);
    app.use(ElementPlus);
    app.mount("#app");
</script>
</body>
</html>
