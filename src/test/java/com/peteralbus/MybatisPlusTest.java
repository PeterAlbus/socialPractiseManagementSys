package com.peteralbus;

import com.peteralbus.dao.UserDao;
import com.peteralbus.entity.User;
import com.peteralbus.service.UserService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class) // SpringJUnit支持，由此引入Spring-Test框架支持！
@ContextConfiguration(locations = {"classpath:mybatis-config.xml","classpath:applicationContext.xml"})//用于加载bean
public class MybatisPlusTest
{
    @Autowired
    UserDao userDao;
    @Autowired
    UserService userService;
    @Test
    public void test()
    {
        User user=userService.queryByUsername("PeterAlbus");
        user.setUserPhone("17317792001");
        userDao.updateById(user);
    }
}
