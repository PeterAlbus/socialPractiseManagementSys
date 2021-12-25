# socialPractiseManagementSys
a course of SSM's homework

一份SSM课程的期末大作业
是一个学生信息管理系统

运行时需要自行将jdbcConfig.sample.properties重命名为jdbcConfig.properties

同时使用maven导入pom.xml中指定的包

自行修改其中连接数据库的账号和密码，并且使用sql文件夹中的sql语句创建数据库

项目使用Spring+SpringMVC+Mybatis-plus+shiro作为框架，前后端不分离，选择了原始的jsp，并在jsp中使用了vue.js以进行一部分mvvm架构的页面设计

德鲁伊后台的密码在web.xml中进行配置

前段样式基本采用element-ui