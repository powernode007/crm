package com.bjpn.settings.service;

import com.bjpn.settings.bean.User;
import com.baomidou.mybatisplus.extension.service.IService;
import com.bjpn.workbench.bean.Activity;

import java.util.List;

/**
 * <p>
 * 服务类
 * </p>
 *
 * @author ${author}
 * @since 2022-11-10
 */
public interface UserService extends IService<User> {
    User loginUser(String userCode, String userPwd) ;
    //查询所有用户
    List<User> findAllUser();
    //根据用户名获取用户id
    List<Integer>  findIdsByActivityOwner(String likeActivityOwner);
    //根据用户名获取用户id
    List<Integer>  findIdsByCustomerOwner(String likeOwner);
}
