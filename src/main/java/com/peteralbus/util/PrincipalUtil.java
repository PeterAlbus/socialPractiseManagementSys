package com.peteralbus.util;

import com.peteralbus.entity.Message;
import com.peteralbus.entity.User;
import com.peteralbus.service.MessageService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.PostConstruct;
import java.util.List;

/**
 * The type Principal util.
 * @author peteralbus
 */
@Component
public class PrincipalUtil
{
    /**
     * Gets basic model and view.
     *
     * @return the basic model and view
     */
    public static ModelAndView getBasicModelAndView()
    {
        ModelAndView modelAndView=new ModelAndView();
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        modelAndView.addObject("realName",user.getRealName());
        modelAndView.addObject("username",user.getUsername());
        modelAndView.addObject("avatarSrc",user.getAvatarSrc());
        modelAndView.addObject("userId",user.getUserId());
        return modelAndView;
    }
}
