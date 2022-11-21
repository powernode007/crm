package com.bjpn.settings.controller;

import com.bjpn.settings.bean.User;
import com.bjpn.settings.service.UserService;
import com.bjpn.util.MessageUtil;
import com.bjpn.util.ReturnObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@Controller
@RequestMapping("/login")
public class LoginController {
    @Autowired
    UserService userService;

    @RequestMapping("/toLogin.action")
    public String toLogin() {
        return "settings/qx/user/login";
    }

    @RequestMapping("/LoginUser.action")
    @ResponseBody
    public ReturnObject LoginUser(ReturnObject returnObject, HttpSession session, HttpServletResponse response, HttpServletRequest request, String userCode, String userPwd,
                                  Boolean loginCheck) throws ParseException {
        User user = userService.loginUser(userCode, userPwd);
        if (user != null) { //数据库查到了
            //先判断账号是否锁定
            if ("0".equals(user.getUserLockState())) {
                returnObject.setMessageCode(MessageUtil.LOCK_ERROR_CODE);
                returnObject.setMessageStr(MessageUtil.LOCK_ERROR_STR);
                return returnObject;
            }

            //得到当前时间的时间戳
            long now = System.currentTimeMillis();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date parse = sdf.parse(user.getUserExpireTime());
            long time = parse.getTime();
            //判断用户是否超时
            if (time < now) {
                returnObject.setMessageCode(MessageUtil.TIME_OUT_CODE);
                returnObject.setMessageStr(MessageUtil.TIME_OUT_STR);
                return  returnObject;
            }
            //这里已经登录成功
            if (loginCheck) {
                //记住密码
                Cookie cookieCode = new Cookie("loginCode", userCode);//loginCode跟前端id没关系
                Cookie cookiePwd = new Cookie("loginPwd", userPwd);
                //根路径下所有的应用都可用这个cookie
                cookieCode.setPath("/");
                cookiePwd.setPath("/");
                cookieCode.setMaxAge(60 * 60 * 24 * 10);
                cookiePwd.setMaxAge(60 * 60 * 24 * 10);
                response.addCookie(cookieCode);
                response.addCookie(cookiePwd);
            } else {
                Cookie cookieCode = new Cookie("loginCode", userCode);
                Cookie cookiePwd = new Cookie("loginPwd", userPwd);
                //根路径下所有的应用都可用这个cookie
                cookieCode.setPath("/");
                cookiePwd.setPath("/");
                cookieCode.setMaxAge(0);
                cookiePwd.setMaxAge(0);
                response.addCookie(cookieCode);
                response.addCookie(cookiePwd);
            }
            session.setAttribute("user", user);
            returnObject.setMessageCode(MessageUtil.LOGIN_SUCCESS_CODE);
            returnObject.setMessageStr(MessageUtil.LOGIN_SUCCESS_STR);
            return returnObject;

        }
        returnObject.setMessageCode(MessageUtil.LOGIN_FAIL_CODE);
        returnObject.setMessageStr(MessageUtil.LOGIN_FAIL_STR);
        return returnObject;
    }

}
