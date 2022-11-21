package com.bjpn.settings.controller;


import com.bjpn.settings.bean.User;
import com.bjpn.settings.service.UserService;
import com.bjpn.workbench.bean.Activity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author ${author}
 * @since 2022-11-10
 */
@Controller
@RequestMapping("/settings/user")
public class UserController {
    @Autowired
   UserService userService;
    @RequestMapping("/findAllUser.action")
    @ResponseBody
    public List<User> findAllUser(){
        return userService.findAllUser();
    }
    @RequestMapping("/findUserById.action")
    @ResponseBody
    public User findUserById(Integer userId){

        return userService.getById(userId);
    }
}

