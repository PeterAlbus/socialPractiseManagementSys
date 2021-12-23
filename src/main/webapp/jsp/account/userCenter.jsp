<%--
  Created by IntelliJ IDEA.
  User: peteralbus
  Date: 2021/12/22
  Time: 20:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>用户中心</title>
    <!-- 导入 Vue 3 -->
    <script src="${pageContext.request.contextPath}/vue/vue@next/vue.global.js"></script>
    <!-- 导入组件库 -->
    <script src="${pageContext.request.contextPath}/vue/element/index.full.js"></script>
    <script src="${pageContext.request.contextPath}/vue/axios/axios.js"></script>
    <script src="${pageContext.request.contextPath}/vue/qs.min.js"></script>
    <!-- 引入样式 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/vue/font-awesome/css/font-awesome.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/avatarUploader.css">
    <link rel="stylesheet" href="//unpkg.com/element-plus@1.1.0-beta.9/dist/index.css"/>
</head>
<body>
<div id="app">
    <el-dialog v-model="dialogVisible" title="修改密码">
        <el-form action="/user/changePassword" label-width="80px">
            <el-form-item label="原密码">
                <el-input v-model="oldPassword" type="password"></el-input>
            </el-form-item>
            <el-form-item label="新密码">
                <el-input v-model="newPassword" type="password"></el-input>
            </el-form-item>
        </el-form>
        <template #footer>
      <span class="dialog-footer">
        <el-button @click="dialogVisible = false">Cancel</el-button>
        <el-button type="primary" @click="changePass">修改</el-button>
      </span>
        </template>
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
                        <el-alert :title="info" type="error" show-icon v-if="info!==''"></el-alert>
                        <el-form ref="form" :model="user" :rules="rule" :label-width="80" class="login-form">
                            <el-form-item label="头像">
                                <el-upload
                                        class="avatar-uploader"
                                        action="https://www.peteralbus.com:8089/photo/customUpload/"
                                        :show-file-list="false"
                                        :data="upData"
                                        :on-success="handleAvatarSuccess"
                                <%--                        :before-upload="beforeAvatarUpload"--%>
                                >
                                    <img v-if="user.avatarSrc" :src="user.avatarSrc" class="avatar"/>
                                    <i class="el-icon-plus avatar-uploader-icon" v-else></i>
                                </el-upload>
                            </el-form-item>
                            <el-form-item prop="username" label="用户名">
                                <el-input type="text" v-model="user.username" placeholder="用户名"></el-input>
                            </el-form-item>
                            <el-form-item prop="realName" label="姓名">
                                <el-input type="text" v-model="user.realName" placeholder="name"></el-input>
                            </el-form-item>
                            <el-form-item prop="password" label="密码">
                                <el-button type="danger" @click="dialogVisible=true" size="small" round>修改密码</el-button>
                            </el-form-item>
                            <el-form-item prop="userPhone" label="手机号">
                                <el-input type="text" v-model="user.userPhone" placeholder="phone number"></el-input>
                            </el-form-item>
                            <el-form-item>
                                <el-button type="primary" @click="handleSubmit('form')" size="large" :loading="loading">
                                    保存
                                </el-button>
                            </el-form-item>
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
            return {
                info: '${info}',
                title: '用户中心',
                user: {
                    userId: '',
                    username: '',
                    realName: '',
                    userPhone: '',
                    avatarSrc: '',
                },
                rule: {
                    username: [
                        {required: true, message: '请填写用户名', trigger: 'blur'}
                    ],
                    userPhone: [
                        {required: true, message: '请填写手机号', trigger: 'blur'},
                        {len: 11, message: '请输入正确格式手机号', trigger: 'blur'}
                    ],
                    realName: [
                        {required: true, message: '请输入真实姓名', trigger: 'blur'}
                    ]
                },
                dialogVisible: false,
                newPassword: '',
                oldPassword: '',
                loading: false,
                activeIndex: '8'
            }
        },
        mounted() {
            this.user.userId = '${userId}'
            this.user.realName = '${realName}'
            this.user.username = '${username}'
            this.user.avatarSrc = '${avatarSrc}'
            this.user.userPhone = '${userPhone}'
        },
        methods: {
            handleAvatarSuccess(res, file) {
                console.log(res)
                this.user.avatarSrc = res;
                this.$message.success('上传头像成功！点击保存进行保存')
            },
            goBack() {
                window.history.go(-1);
            },
            handleSubmit(name) {
                this.$refs[name].validate((valid) => {
                    if (valid) {
                        this.loading = true
                        axios({
                            method: "post",
                            url: "/user/updateUser",
                            data: this.user,
                            transformRequest: [function (data) {
                                return Qs.stringify(data)  //使用Qs将请求参数序列化
                            }],
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded'  //必须设置传输方式
                            }
                        })
                            .then(res => {
                                this.loading = false
                                if (res.data === "success") {
                                    location.reload()
                                } else {
                                    this.info = '修改失败！';
                                }
                            })
                    }
                })
            },
            changePass() {
                location.href = '/user/changePassword?oldPassword=' + this.oldPassword + '&newPassword=' + this.newPassword
            },
            uuid() {
                var s = [];
                var hexDigits = "0123456789abcdef";
                for (var i = 0; i < 36; i++) {
                    s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
                }
                s[14] = "4"; // bits 12-15 of the time_hi_and_version field to 0010
                s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1); // bits 6-7 of the clock_seq_hi_and_reserved to 01
                s[8] = s[13] = s[18] = s[23] = "-";

                var uuid = s.join("");
                return uuid;
            }
        },
        computed: {
            upData: function () {
                let uuid = this.uuid();
                return {
                    path: 'social/',
                    saveName: uuid
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
