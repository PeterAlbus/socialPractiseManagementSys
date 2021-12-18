<%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2021/12/4
  Time: 18:49
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录页面</title>
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
                <h1 class="login-title"><Icon type="person-stalker"></Icon>学生社会实践管理系统</h1>
                <h2 class="login-title">用户登录</h2>
                <Alert type="success" show-icon v-if="info!==''">{{info}}</Alert>
                <Form-item prop="username" label="用户名">
                    <i-input type="text" v-model="form.username" placeholder="Username">
                        <Icon type="ios-person-outline" slot="prepend"></Icon>
                    </i-input>
                </Form-item>
                <Form-item prop="password" label="密码">
                    <i-input type="password" v-model="form.password" placeholder="Password">
                        <Icon type="ios-lock-outline" slot="prepend"></Icon>
                    </i-input>
                </Form-item>
                <Form-item>
                    <Checkbox v-model="form.rememberMe">记住我</Checkbox>
                </Form-item>
                <Form-item>
                    <i-button type="success" @click="handleSubmit('form')" size="large" shape="circle" :loading="loading">登录</i-button>
                </Form-item>
                <Divider>提示</Divider>
                <Alert show-icon>
                    还没有账号?
                    <template slot="desc">点击<a href="${pageContext.request.contextPath}/register">此处</a>进行注册</template>
                </Alert>
            </i-form>
        </i-col>
    </Row>
</div>
<script>
    new Vue({
        el: '#app',
        data: {
            info: '${info}',
            loading: false,
            visible: false,
            form: {
                username: '',
                password: '',
                rememberMe: false,
            },
            rule: {
                username: [
                    { required: true, message: '请填写用户名', trigger: 'blur' }
                ],
                password: [
                    { required: true, message: '请填写密码', trigger: 'blur' },
                    { type: 'string', min: 6, message: '密码长度不能小于6位', trigger: 'blur' }
                ]
            }
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
                            url: "/user/login",
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
                                    title:'登录成功',
                                    content:'您已登录成功，点击确认跳转到主页面',
                                    onOk:()=>{location.href="/"}
                                })
                            }
                            else
                            {
                                this.$Message.error(res.data);
                            }
                        })
                    } else {
                        this.$Message.error('表单验证失败!');
                    }
                })
            }
        }
    })
</script>
</body>
</html>
