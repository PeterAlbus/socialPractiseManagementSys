<%--
  Created by IntelliJ IDEA.
  User: peteralbus
  Date: 2021/12/21
  Time: 18:13
  To change this template use File | Settings | File Templates.
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
                                :total="activityListResult.length"
                                :page-sizes="[5, 10, 20, 40]"
                                v-model:page-size="pageSize"
                                v-model:current-page="currentPage">
                        </el-pagination>
                    </div>
                    <div>
                        <el-table
                                :data="currentPageActivities"
                                style="width: 100%"
                        >
                            <el-table-column label="活动ID" fixed width="250">
                                <template #default="scope">
                                    {{scope.row.activityId}}
                                    <el-tag v-if="scope.row.isDelete=='1'" type="danger" size="mini">已删除</el-tag>
                                </template>
                            </el-table-column>
                            <el-table-column prop="activityName" label="活动名" width="250"></el-table-column>
                            <el-table-column prop="activityType" label="活动类型"></el-table-column>
                            <el-table-column label="活动介绍">
                                <template #default="scope">
                                    <el-popover effect="light" trigger="hover" placement="top">
                                        <template #default>
                                            <p>{{ scope.row.activityIntroduction }}</p>
                                        </template>
                                        <template #reference>
                                            <el-tag size="medium">悬浮查看</el-tag>
                                        </template>
                                    </el-popover>
                                </template>
                            </el-table-column>
                            <el-table-column prop="minPeople" label="最小人数"></el-table-column>
                            <el-table-column prop="maxPeople" label="最大人数"></el-table-column>
                            <el-table-column prop="version" label="版本"></el-table-column>
                            <el-table-column prop="gmtCreate" label="创建时间" width="250"></el-table-column>
                            <el-table-column prop="gmtModified" label="上次更改" width="250"></el-table-column>
                            <el-table-column prop="isDelete" label="是否删除"></el-table-column>
                            <el-table-column align="right" fixed="right" width="100">
                                <template #header>
                                    <el-input v-model="keyWord" size="mini" placeholder="搜索活动名"></el-input>
                                </template>
                                <template #default="scope">
                                    <el-button size="mini" @click="restore(scope.row.activityId)" v-if="scope.row.isDelete=='1'" type="success">恢复</el-button>
                                    <el-button size="mini" @click="deleteAct(scope.row.activityId)" v-if="scope.row.isDelete!='1'" type="danger">删除</el-button>
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
                title:'社会实践活动管理',
                user:{
                    username:'',
                    realName:'',
                    avatarSrc: ''
                },
                keyWord:'',
                currentPage:1,
                pageSize:10,
                activityList:[
                    <c:forEach items="${activityList}" var="activity">
                    {
                        activityId: '${activity.getActivityId()}',
                        activityName: '${activity.getActivityName()}',
                        activityType:'${activity.getActivityType()}',
                        activityIntroduction:'${activity.getActivityIntroduction()}',
                        minPeople:'${activity.getMinPeople()}',
                        maxPeople:'${activity.getMaxPeople()}',
                        version:'${activity.getVersion()}',
                        gmtCreate:'${activity.getFormattedCreateDate()}',
                        gmtModified:'${activity.getGmtModified()}',
                        isDelete:'${activity.getIsDelete()}'
                    },
                    </c:forEach>
                ],
                activeIndex:'4'
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
            restore(id){
                this.$messageBox.confirm(
                    '确认要恢复这个被删除的社会实践活动吗？',
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
                            url: "/admin/restoreActivity?activityId="+id,
                        }).then(res=>{
                            if(res.data==="error")
                            {
                                this.$message.error('恢复失败!')
                            }
                            else
                            {
                                location.reload()
                            }
                        })
                    })
            },
            deleteAct(id){
                this.$messageBox.confirm(
                    '确认要删除社会实践活动吗,请与老师联系确认！',
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
                            url: "/teacher/deleteActivity?activityId="+id,
                        }).then(res=>{
                            if(res.data==="error")
                            {
                                this.$message.error('删除失败!')
                            }
                            else
                            {
                                location.reload()
                            }
                        })
                    })
            }
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
                    let str_leader=this.activityList[i].activityIntroduction;
                    if(str.search(this.keyWord)!==-1||str_leader.search(this.keyWord)!==-1)
                    {
                        result.push(this.activityList[i]);
                    }
                }
                return result;
            },
            currentPageActivities:function (){
                return this.activityListResult.slice((this.currentPage-1)*this.pageSize,this.currentPage*this.pageSize)
            }
        }
    };
    const app = Vue.createApp(App);
    app.use(ElementPlus);
    app.mount("#app");
</script>
</body>
</html>
