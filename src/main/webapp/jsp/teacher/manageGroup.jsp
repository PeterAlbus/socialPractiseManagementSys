<%--
  Created by IntelliJ IDEA.
  User: peteralbus
  Date: 2021/12/21
  Time: 12:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>社会实践小组完成情况管理</title>
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
          title="评分"
          width="30%"
  >
    <div class="drawer-box">
      <div>小组评分：<el-rate v-model="scoreGroup.scoreValue" allow-half></el-rate></div>
      <div v-for="item in scoreStu">{{item.realName}}：<el-rate v-model="item.scoreValue" allow-half></el-rate></div>
      <br/>
      <el-button type="primary" @click="rateScore" size="small">提交</el-button>
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
            <el-divider content-position="left">社会实践活动信息</el-divider>
            <div class="activity-info">
              <el-descriptions
                      title="活动情况"
                      :column="1"
                      border
              >
                <template #extra>
                  <el-button type="success" size="mini" @click="dialogVisible=true" v-if="!isScored">评分</el-button>
                  <el-tag type="success" v-if="isFinished">该小组已完成社会实践</el-tag>
                  <el-tag type="danger" v-if="activity.minPeople>group.memberCount">该小组人数尚未达标</el-tag>
                  <el-link href="#record" type="primary">日志管理<i class="el-icon-arrow-down"></i></el-link>&emsp;
                  <el-link href="#groupMember" type="primary">小组成员<i class="el-icon-arrow-down"></i></el-link>
                </template>
                <el-descriptions-item>
                  <template #label>
                    活动名称
                  </template>
                  {{activity.activityName}}
                </el-descriptions-item>
                <el-descriptions-item>
                  <template #label>
                    活动类别
                  </template>
                  {{activity.activityType}}
                </el-descriptions-item>
                <el-descriptions-item>
                  <template #label>
                    活动人数
                  </template>
                  {{activity.minPeople}}-{{activity.maxPeople}}人
                </el-descriptions-item>
                <el-descriptions-item>
                  <template #label>
                    负责老师
                  </template>
                  <span v-for="i in activity.teachers">{{i.realName}}&emsp;</span>
                </el-descriptions-item>
                <el-descriptions-item>
                  <template #label>
                    创建日期
                  </template>
                  {{activity.gmtCreate}}
                </el-descriptions-item>
              </el-descriptions>
              <el-descriptions :column="1" border direction="vertical">
                <el-descriptions-item>
                  <template #label>
                    简介
                  </template>
                  {{activity.activityIntroduction}}
                </el-descriptions-item>
              </el-descriptions>
            </div>
            <el-divider content-position="left" id="score" v-if="isScored">分数</el-divider>
            <div v-for="item in score" class="drawer-box" v-if="isScored">
              {{item.key}}
              <el-rate
                      v-model="item.value"
                      disabled
                      show-score
                      text-color="#ff9900"
                      score-template="{value} 分"
              >
              </el-rate>
            </div>
            <el-divider content-position="left" id="record">日志查看</el-divider>
            <el-timeline>
              <el-timeline-item :timestamp="item.gmtCreate" placement="top" v-for="item in recordList">
                <el-badge value="new" style="width: 100%" :hidden="item.isRead">
                  <el-card>
                    <h4>{{item.recordTitle}}-{{item.authorName}}</h4>
                    <p>{{item.recordContent}}</p>
                    <el-link v-if="!item.isRead" type="primary" @click="setRead(item.recordId)">设为已读</el-link>
                  </el-card>
                </el-badge>
              </el-timeline-item>
            </el-timeline>
            <el-divider content-position="left" id="groupMember">小组</el-divider>
            <div>
              <el-descriptions title="小组信息" border>
                <el-descriptions-item label="小组名">{{group.groupName}}</el-descriptions-item>
                <el-descriptions-item label="组长姓名">{{group.leaderName}}</el-descriptions-item>
                <el-descriptions-item label="已加入组员数">{{group.memberCount}}</el-descriptions-item>
              </el-descriptions>
              <h4>成员信息</h4>
              <el-table :data="memberList" style="width: 100%" stripe>
                <el-table-column prop="username" label="用户名"></el-table-column>
                <el-table-column prop="realName" label="姓名"></el-table-column>
                <el-table-column align="right" label="加入状态">
                  <template #default="scope">
                    <el-tag type="success" v-if="scope.row.isAccept">已通过</el-tag>
                    <el-tag type="info" v-if="!scope.row.isAccept">审核中</el-tag>
                  </template>
                </el-table-column>
              </el-table>
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
        title:'社会实践小组',
        dialogVisible:false,
        user:{
          username:'',
          realName:'',
          avatarSrc: '',
          userId:''
        },
        scoreGroup:{
          groupId:'${group.getGroupId()}',
          teacherId:'${userId}',
          scoreValue:5
        },
        scoreStu:[
          <c:forEach items="${memberList}" var="member">
          {
            participationId:'${member.getParticipationId()}',
            realName:'${member.getRealName()}',
            teacherId: '${userId}',
            scoreValue: 5
          },
          </c:forEach>
        ],
        score:[
          <c:forEach items="${score}" var="item">
          {
            key:'${item.key}',
            value:${item.value},
          },
          </c:forEach>
        ],
        recordList:[
          <c:forEach items="${recordList}" var="record">
          {
            recordId:'${record.getRecordId()}',
            recordTitle:'${record.getRecordTitle()}',
            recordContent:'${record.getRecordContent()}',
            isRead:${record.getRead()},
            authorName:'${record.getAuthorName()}',
            gmtCreate:'${record.getFormattedCreateDate()}'
          },
          </c:forEach>
        ],
        activity:{
          activityId: '${activity.getActivityId()}',
          activityName: '${activity.getActivityName()}',
          activityType:'${activity.getActivityType()}',
          activityIntroduction:'${activity.getActivityIntroduction()}',
          minPeople:'${activity.getMinPeople()}',
          maxPeople:'${activity.getMaxPeople()}',
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
        group:{
          groupId:'${group.getGroupId()}',
          groupName:'${group.getGroupName()}',
          leaderId:'${group.getLeaderId()}',
          leaderName: '${group.getLeaderName()}',
          memberCount: '${group.getMemberCount()}'
        },
        isFinished: ${isFinished},
        isScored:${isScored},
        memberList:[
          <c:forEach items="${memberList}" var="member">
          {
            participateId:'${member.getParticipationId()}',
            userId:'${member.getUserId()}',
            username:'${member.getUsername()}',
            realName:'${member.getRealName()}',
            isAccept:${member.getAccept()}
          },
          </c:forEach>
        ],
        activeIndex:'2'
      }
    },
    mounted(){
      this.user.realName='${realName}'
      this.user.username='${username}'
      this.user.avatarSrc='${avatarSrc}'
      this.user.userId='${userId}'
    },
    methods: {
      goBack(){
        window.history.go(-1);
      },
      setRead(id){
        axios({
          method: "get",
          url: "/teacher/setRead?recordId="+id,
        }).then(res=>{
          if(res.data==="error")
          {
            this.$message.error('设置失败!')
          }
          else
          {
            location.reload()
          }
        })
      },
      rateScore(){
        let count=0
        let that=this
        this.$messageBox.confirm(
                '确认提交评分？学生的社会实践活动将结束，评分不可修改',
                '信息',
                {
                  confirmButtonText: '确认',
                  cancelButtonText: '取消',
                  type: 'info',
                }
        )
                .then(() => {
                  axios({
                    method: "post",
                    url: "/teacher/scoreGroup",
                    data: this.scoreGroup,
                    transformRequest: [ function(data){
                      return Qs.stringify(data)  //使用Qs将请求参数序列化
                    }],
                    headers: {
                      'Content-Type': 'application/x-www-form-urlencoded'  //必须设置传输方式
                    }
                  })
                          .then(res => {
                            if(res.data==="success")
                            {
                              for(let i of that.scoreStu)
                              {
                                axios({
                                  method: "post",
                                  url: "/teacher/scoreStu",
                                  data: i,
                                  transformRequest: [ function(data){
                                    return Qs.stringify(data)  //使用Qs将请求参数序列化
                                  }],
                                  headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded'  //必须设置传输方式
                                  }
                                })
                                .then(res=>{
                                  count++
                                  if(count>=this.scoreStu.length)
                                  {
                                    location.reload();
                                  }
                                })
                              }
                            }
                            else
                            {
                              this.$message.error("已经进行过评分")
                            }
                          })
                          .catch(res=>{
                            this.$message.error("出现异常，提交失败")
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
