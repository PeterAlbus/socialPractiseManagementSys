<%--
  Created by IntelliJ IDEA.
  User: peteralbus
  Date: 2021/12/21
  Time: 20:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>用户管理</title>
    <!-- 导入 Vue 3 -->
    <script src="${pageContext.request.contextPath}/vue/vue@next/vue.global.js"></script>
    <!-- 导入组件库 -->
    <script src="${pageContext.request.contextPath}/vue/element/index.full.js"></script>
    <script src="${pageContext.request.contextPath}/vue/axios/axios.js"></script>
    <script src="${pageContext.request.contextPath}/vue/qs.min.js"></script>
    <!-- 引入样式 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/vue/font-awesome/css/font-awesome.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
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
                    <div style="text-align: center">
                        <el-pagination
                                background
                                layout="total, sizes ,prev, pager, next, jumper"
                                :total="userListResult.length"
                                :page-sizes="[5, 10, 20, 40]"
                                v-model:page-size="pageSize"
                                v-model:current-page="currentPage">
                        </el-pagination>
                    </div>
                    <div>
                        <el-table
                                :data="currentPageUsers"
                                style="width: 100%"
                        >
                            <el-table-column prop="userId" label="用户ID" fixed width="250"></el-table-column>
                            <el-table-column prop="username" label="用户名" width="200"></el-table-column>
                            <el-table-column prop="realName" label="姓名" width="200"></el-table-column>
                            <el-table-column label="头像">
                                <template #default="scope">
                                    <el-popover effect="light" trigger="hover" placement="top">
                                        <template #default>
                                            <img :src="scope.row.avatarSrc" alt="" style="width: 150px;height: 150px"/>
                                        </template>
                                        <template #reference>
                                            <el-tag size="medium">悬浮查看</el-tag>
                                        </template>
                                    </el-popover>
                                </template>
                            </el-table-column>
                            <el-table-column prop="userPhone" label="手机号" width="200"></el-table-column>
                            <el-table-column prop="userClass" label="用户类别"></el-table-column>
                            <el-table-column prop="userSalt" label="加密盐值"></el-table-column>
                            <el-table-column prop="version" label="版本"></el-table-column>
                            <el-table-column prop="gmtCreate" label="创建时间" width="250"></el-table-column>
                            <el-table-column prop="gmtModified" label="上次更改" width="250"></el-table-column>
                            <el-table-column width="120">
                                <template #header>
                                    给与权限
                                </template>
                                <template #default="scope">
                                    <el-button size="mini" @click="setAdmin(scope.row.userId)" type="danger" v-if="scope.row.userClass!=='0'">设为管理员</el-button>
                                </template>
                            </el-table-column>
                            <el-table-column align="right" fixed="right" width="100">
                                <template #header>
                                    <el-input v-model="keyWord" size="mini" placeholder="搜索用户"></el-input>
                                </template>
                                <template #default="scope">
                                    <el-button size="mini" @click="resetPassword(scope.row.userId)" type="danger">重置密码</el-button>
                                </template>
                            </el-table-column>
                        </el-table>
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
                title:'用户',
                user:{
                    username:'',
                    realName:'',
                    avatarSrc: ''
                },
                keyWord:'',
                currentPage:1,
                pageSize:10,
                userList:[
                    <c:forEach items="${userList}" var="user">
                    {
                        userId: '${user.getUserId()}',
                        username: '${user.getUsername()}',
                        password:'${user.getPassword()}',
                        realName:'${user.getRealName()}',
                        userPhone:'${user.getUserPhone()}',
                        avatarSrc:'${user.getAvatarSrc()}',
                        userClass: '${user.getUserClass()}',
                        userSalt:'${user.getUserSalt()}',
                        version:'${user.getVersion()}',
                        gmtCreate:'${user.getGmtCreate()}',
                        gmtModified:'${user.getGmtModified()}',
                        isDelete:'${user.getIsDelete()}'
                    },
                    </c:forEach>
                ],
                activeIndex:'5'
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
        methods: {
            goBack(){
                window.history.go(-1);
            },
            resetPassword(id){
                this.$messageBox.confirm(
                    '确认要重置用户密码为123456吗？',
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
                            url: "/admin/resetPassword?userId="+id,
                        }).then(res=>{
                            if(res.data==="error")
                            {
                                this.$message.error('重置失败!')
                            }
                            else
                            {
                                this.$message.success('重置成功!')
                            }
                        })
                    })
            },
            setAdmin(id){
                this.$messageBox.confirm(
                    '确认要将该用户设置为管理员吗？',
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
                            url: "/admin/setAdmin?userId="+id,
                        }).then(res=>{
                            if(res.data==="error")
                            {
                                this.$message.error('设置失败!')
                            }
                            else
                            {
                                this.$message.success('设置成功!')
                            }
                        })
                    })
            }
        },
        computed:{
            userListResult:function (){
                let result=[];
                if(this.keyWord==='')
                {
                    return this.userList;
                }
                for(let i=0;i<this.userList.length;i++)
                {
                    let str=this.userList[i].realName;
                    let str_leader=this.userList[i].username;
                    if(str.search(this.keyWord)!==-1||str_leader.search(this.keyWord)!==-1)
                    {
                        result.push(this.userList[i]);
                    }
                }
                return result;
            },
            currentPageUsers:function (){
                return this.userListResult.slice((this.currentPage-1)*this.pageSize,this.currentPage*this.pageSize)
            }
        }
    };
    const app = Vue.createApp(App);
    app.use(ElementPlus);
    app.mount("#app");
</script>
</body>
</html>
