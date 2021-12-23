<%--
  Created by IntelliJ IDEA.
  User: peteralbus
  Date: 2021/12/22
  Time: 22:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>用户统计</title>
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
            <el-form ref="form" :model="user1" :label-width="250">
              <el-form-item label="头像">
                <img v-if="user1.avatarSrc" :src="user1.avatarSrc" class="avatar" />
              </el-form-item>
              <el-form-item prop="username" label="用户名">
                {{user1.username}}
              </el-form-item>
              <el-form-item prop="realName" label="姓名">
                {{user1.realName}}
              </el-form-item>
              <el-form-item prop="userPhone" label="手机号">
                {{user1.userPhone}}
              </el-form-item>
              <el-form-item label="参加/管理的活动数">
                {{stat.activityCount}}
              </el-form-item>
              <el-form-item label="担任组长次数">
                {{stat.groupCount}}
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
      return{
        title:'用户统计',
        user:{
          userId:'',
          username:'',
          realName:'',
          userPhone:'',
          avatarSrc: '',
        },
        user1:{
          userId:'',
          username:'',
          realName:'',
          userPhone:'',
          avatarSrc: '',
        },
        stat:{
          activityCount:${stat.get("activityCount")},
          groupCount:${stat.get("groupCount")}
        },
        activeIndex:'7'
      }
    },
    mounted(){
      this.user.userId='${userId}'
      this.user.realName='${realName}'
      this.user.username='${username}'
      this.user.avatarSrc='${avatarSrc}'
      this.user.userPhone='${userPhone}'
      this.user1.userId='${userInfo.userId}'
      this.user1.realName='${userInfo.realName}'
      this.user1.username='${userInfo.username}'
      this.user1.avatarSrc='${userInfo.avatarSrc}'
      this.user1.userPhone='${userInfo.userPhone}'
    },
    methods: {
      goBack(){
        window.history.go(-1);
      }
    }
  };
  const app = Vue.createApp(App);
  app.use(ElementPlus);
  app.mount("#app");
</script>
</body>
</html>
