<%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2021/12/5
  Time: 20:26
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>注册页面</title>
    <!-- 引入Vue -->
    <script src="${pageContext.request.contextPath}/iview/vue.js"></script>
    <!-- 引入样式 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/iview/styles/iview.css">
    <!-- 引入组件库 -->
    <script src="${pageContext.request.contextPath}/iview/iview.js"></script>
    <script src="${pageContext.request.contextPath}/vue/axios/axios.js"></script>
    <script src="${pageContext.request.contextPath}/vue/qs.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>
<div id="app">
    <Row class="login-box">
        <i-col span="12">
            <img src="${pageContext.request.contextPath}/img/1.jpeg" alt="" class="login-img"/>
        </i-col>
        <i-col span="12">
            <i-form ref="form" :model="form" :rules="rule" :label-width="80" class="login-form">
                <h1 class="login-title">用户注册</h1>
                <Alert type="error" show-icon v-if="info!==''">{{info}}</Alert>
                <Form-item prop="avatarSrc" label="头像">
                    <Avatar :src="form.avatarSrc" size="large"></Avatar>
                </Form-item>
                <Form-item>
                    <Upload action="#" on-success="uploadSuccess">
                        <i-button type="primary" icon="ios-cloud-upload-outline">上传头像</i-button>
                    </Upload>
                </Form-item>
                <Alert show-icon closable>用户名注册后不可修改 将作为您的登录凭证</Alert>
                <Form-item prop="username" label="用户名">
                    <i-input type="text" v-model="form.username" placeholder="Username">
                        <Icon type="ios-person-outline" slot="prepend"></Icon>
                    </i-input>
                </Form-item>
                <Form-item prop="realName" label="姓名">
                    <i-input type="text" v-model="form.realName" placeholder="name">
                        <Icon type="ios-person-outline" slot="prepend"></Icon>
                    </i-input>
                </Form-item>
                <Form-item prop="password" label="密码">
                    <i-input type="password" v-model="form.password" placeholder="Password">
                        <Icon type="ios-lock-outline" slot="prepend"></Icon>
                    </i-input>
                </Form-item>
                <Form-item prop="confirmPassword" label="确认密码">
                    <i-input type="password" v-model="form.confirmPassword" placeholder="Confirm password">
                        <Icon type="ios-lock-outline" slot="prepend"></Icon>
                    </i-input>
                </Form-item>
                <Form-item prop="userPhone" label="手机号">
                    <i-input type="text" v-model="form.userPhone" placeholder="phone number">
                        <Icon type="ios-phone-portrait" slot="prepend"></Icon>
                    </i-input>
                </Form-item>
                <Form-item prop="userClass" label="用户身份">
                    <i-select v-model="form.userClass" >
                        <i-option :value="1">学生</i-option>
                        <i-option :value="2">教师</i-option>
                    </i-select>
                </Form-item>
                <Form-item>
                    <Checkbox v-model="canRegister">我同意本站的许可条款</Checkbox>
                </Form-item>
                <Form-item>
                    <i-button type="primary" @click="handleSubmit('form')" size="large" shape="circle" :loading="loading" :disabled="!canRegister">注册</i-button>
                    <i-button onclick="location.href='/login'" size="large" shape="circle">登录</i-button>
                </Form-item>
            </i-form>
        </i-col>
    </Row>
</div>
<script>
    new Vue({
        el: '#app',
        data(){
            const validatePass2 = (rule, value, callback) => {
                if (value === '') {
                    callback(new Error('请再次输入密码'));
                } else if (value !== this.form.password) {
                    callback(new Error('两次输入密码不一致!'));
                } else {
                    callback();
                }
            };
            return {
                canRegister:false,
                loading:false,
                info:'',
                form: {
                    username: '',
                    password: '',
                    confirmPassword: '',
                    realName:'',
                    avatarSrc:'https://www.peteralbus.com:8440/assets/social/avatar.jpg',
                    userClass:1,
                    userPhone: '',
                },
                rule: {
                    username: [
                        { required: true, message: '请填写用户名', trigger: 'blur' }
                    ],
                    password: [
                        { required: true, message: '请填写密码', trigger: 'blur' },
                        { type: 'string', min: 6, message: '密码长度不能小于6位', trigger: 'blur' }
                    ],
                    confirmPassword:[
                        { required: true, message: '请填写密码', trigger: 'blur' },
                        { validator: validatePass2, trigger: 'blur' }
                    ],
                    userPhone: [
                        { required: true, message: '请填写手机号', trigger: 'blur' },
                        { len: 11, message: '请输入正确格式手机号', trigger: 'blur' }
                    ],
                    avatarSrc: [
                        { required: true, message: '请上传头像', trigger: 'blur' }
                    ],
                    realName: [
                        { required: true, message: '请输入真实姓名', trigger: 'blur' }
                    ]
                }
            }
        },
        mounted(){
        },
        methods: {
            show: function () {
                this.visible = true;
            },
            handleSubmit(name) {
                this.$refs[name].validate((valid) => {
                    if (valid) {
                        this.loading=true
                        axios({
                            method: "post",
                            url: "/user/register",
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
                                if(res.data==="success")
                                {
                                    this.$Modal.success({
                                        title:'注册成功',
                                        content:'您已注册成功，点击确认前往登录',
                                        onOk:()=>{location.href="/login"}
                                    })
                                }
                                else
                                {
                                    this.info=res.data;
                                }
                            })
                    } else {
                        this.$Message.error('表单验证失败!');
                    }
                })
            },
            handleSuccess (res, file) {
                console.log(res.data)
            },
        }
    })
</script>
</body>
</html>

