package com.bjpn.settings.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.bjpn.settings.bean.User;
import com.bjpn.settings.mapper.UserMapper;
import com.bjpn.settings.service.UserService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bjpn.workbench.bean.Activity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author ${author}
 * @since 2022-11-10
 */
@Service
@Transactional
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {
@Autowired(required = false)
UserMapper userMapper;
    @Override
    public User loginUser(String userCode, String userPwd) {
        QueryWrapper<User> query = Wrappers.query();
        query.eq("user_code", userCode).eq("user_pwd", userPwd);
        return userMapper.selectOne(query);
    }

    @Override
    public List<User> findAllUser() {
        QueryWrapper<User> query = Wrappers.query();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String format = sdf.format(date);
        query.eq("user_lock_state","1");
        query.gt("user_expire_time",format );
        return userMapper.selectList(query);
    }

    @Override
    public List<Integer> findIdsByActivityOwner(String likeActivityOwner) {
        return userMapper.findIdsByOwner(likeActivityOwner);
    }

    @Override
    public List<Integer> findIdsByCustomerOwner(String likeOwner) {
        return userMapper.findIdsByCustomerOwner(likeOwner);
    }
}
