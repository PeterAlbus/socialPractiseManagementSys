package com.peteralbus.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.peteralbus.dao.UserDao;
import com.peteralbus.entity.User;
import com.peteralbus.util.Md5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * The type User service.
 *
 * @author PeterAlbus
 */
@Service
public class UserService
{
    @Autowired
    private UserDao userDao;

    /**
     * Insert user int.
     *
     * @param user the user
     * @return the int
     */
    public int insertUser(User user)
    {
        String originalPassword=user.getPassword();
        String salt=Md5Util.getSalt(6);
        user.setPassword(Md5Util.md5Hash(originalPassword,salt));
        user.setUserSalt(salt);
        return userDao.insert(user);
    }

    public int updateUser(User user)
    {
        return userDao.updateById(user);
    }
    /**
     * Query by username user.
     *
     * @param username the username
     * @return the user
     */
    public User queryByUsername(String username)
    {
        QueryWrapper<User> userQueryWrapper=new QueryWrapper<>();
        userQueryWrapper.eq("username",username);
        return userDao.selectOne(userQueryWrapper);
    }

    /**
     * Update user password int.
     *
     * @param user the user
     * @return the int
     */
    public int updateUserPassword(User user)
    {
        String originalPassword=user.getPassword();
        String salt=user.getUserSalt();
        user.setPassword(Md5Util.md5Hash(originalPassword,salt));
        return userDao.updateById(user);
    }

    /**
     * Delete user int.
     *
     * @param user the user
     * @return the int
     */
    public int deleteUser(User user)
    {
        return userDao.deleteById(user);
    }

    public List<User> getTeacherList()
    {
        QueryWrapper<User> queryWrapper=new QueryWrapper<>();
        queryWrapper.eq("user_class",2);
        return userDao.selectList(queryWrapper);
    }

    public List<User> getUserList()
    {
        return userDao.selectList(null);
    }

    public User queryById(Long userId)
    {
        return userDao.selectById(userId);
    }
}
