<%--
  Created by IntelliJ IDEA.
  User: peteralbus
  Date: 2021/12/21
  Time: 21:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>消息列表</title>
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
    <el-dialog
            v-model="dialogVisible"
            title="查看详情"
    >
        <div style="text-align:center">
            <el-descriptions
                    title="消息详情"
                    :column="1"
                    border
            >
                <template #extra>
                    <el-button type="primary" size="small" @click="read(showedMessage.messageId)" v-if="!showedMessage.isRead">设为已读</el-button>
                </template>
                <el-descriptions-item>
                    <template #label>
                        消息标题
                    </template>
                    {{showedMessage.messageTitle}}
                </el-descriptions-item>
                <el-descriptions-item>
                    <template #label>
                        发送者
                    </template>
                    {{showedMessage.messageSender}}
                </el-descriptions-item>
                <el-descriptions-item>
                    <template #label>
                        发送时间
                    </template>
                    {{showedMessage.gmtCreate}}
                </el-descriptions-item>
            </el-descriptions>
        </div>
        <div>
            <el-descriptions :column="1" border direction="vertical">
                <el-descriptions-item>
                    <template #label>
                        消息内容
                    </template>
                    {{showedMessage.messageContent}}
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
                        <el-empty description="暂无数据" v-if="currentPageMessageList.length==0"></el-empty>
                        <div v-for="(item,index) in currentPageMessageList" style="padding: 2px">
                            <el-badge value="new" style="width: 100%" :hidden="item.isRead">
                                <el-card shadow="hover">
                                    <template #header>
                                        <div class="flex-side">
                                            <span>{{item.messageTitle}}</span>
                                            <div>
                                                <el-button class="button" type="text" @click="read(item.messageId)" v-if="!item.isRead">设为已读</el-button>
                                                <el-button class="button" type="text" @click="showDetail(index)">查看详情</el-button>
                                            </div>
                                        </div>
                                    </template>
                                    <div>
                                        <p>{{item.messageContent}}</p>
                                    </div>
                                </el-card>
                            </el-badge>
                        </div>
                        <div style="text-align: center">
                            <el-pagination
                                    background
                                    layout="total, prev, pager, next"
                                    :total="messageList.length"
                                    :page-size="10"
                                    v-model:current-page="currentPage">
                            </el-pagination>
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
                title:'消息中心',
                user:{
                    username:'',
                    realName:'',
                    avatarSrc: ''
                },
                messageList:[
                    <c:forEach items="${messageList}" var="message">
                    {
                        messageId:'${message.getMessageId()}',
                        messageTitle:'${message.getMessageTitle()}',
                        messageReceiver:'${message.getMessageReceiver()}',
                        messageSender:'${message.getMessageSender()}',
                        messageContent:'${message.getMessageContent()}',
                        isRead:${message.getRead()},
                        gmtCreate:'${message.getFormattedCreateDate()}'
                    },
                    </c:forEach>
                ],
                activeIndex:'6',
                dialogVisible:false,
                currentPage:1,
                showedMessage:{

                }
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
            showDetail(index) {
                this.showedMessage=this.currentPageMessageList[index]
                this.dialogVisible=true
            },
            read(id){
                axios({
                    method: "get",
                    url: "/readMessage?messageId="+id,
                })
                    .then(res=>{
                        if(res.data==="error")
                        {
                            this.$message.error('失败!')
                        }
                        else
                        {
                            location.reload()
                        }
                    })
            }
        },
        computed:{
            currentPageMessageList:function (){
                return this.messageList.slice((this.currentPage-1)*10,this.currentPage*10)
            }
        }
    };
    const app = Vue.createApp(App);
    app.use(ElementPlus);
    app.mount("#app");
</script>
</body>
</html>