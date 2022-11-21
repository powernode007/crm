package com.bjpn.workbench.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.bjpn.settings.service.UserService;
import com.bjpn.workbench.bean.Activity;
import com.bjpn.workbench.bean.Customer;
import com.bjpn.workbench.bean.LikeCustomer;
import com.bjpn.workbench.mapper.ActivityMapper;
import com.bjpn.workbench.mapper.CustomerMapper;
import com.bjpn.workbench.service.CustomerService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.github.pagehelper.PageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author ${author}
 * @since 2022-11-18
 */
@Service
public class CustomerServiceImpl extends ServiceImpl<CustomerMapper, Customer> implements CustomerService {
    @Autowired(required = false)
    CustomerMapper customerMapper;
    @Autowired
    UserService userService;
    @Override
    public List<Customer> findAllCustomerByLikePage(int pageNum, int pageSize, LikeCustomer likeCustomer) {
        QueryWrapper<Customer> wrapper = Wrappers.query();
        //拼装模糊查询条件
        if(likeCustomer.getLikeName()!=null && !"".equals(likeCustomer.getLikeName())){
            wrapper.like("name", likeCustomer.getLikeName());
        }
        if(likeCustomer.getLikeWebsite()!=null && !"".equals(likeCustomer.getLikeWebsite())){
            wrapper.like("website", likeCustomer.getLikeWebsite());
        }
        if(likeCustomer.getLikePhone()!=null && !"".equals(likeCustomer.getLikePhone())){
            wrapper.like("phone", likeCustomer.getLikePhone());
        }
        //likeActivityOwner 如果不传值就是查询所有用户 或者用户信息无所谓
        if(likeCustomer.getLikeOwner()!=null && !"".equals(likeCustomer.getLikeOwner())){
            //如果传递用户信息  此时用户信息是一个用户名的一部分  武    武松  武二
            //从用户表中查询用户id  放入一个list集合
            //在Activity表中  用户的信息 是一个id
            List<Integer> userIds = userService.findIdsByCustomerOwner(likeCustomer.getLikeOwner());
            wrapper.in("owner", userIds);
        }

        //sql语句被调用之前 就是分页插件引入的位置
        PageHelper.startPage(pageNum, pageSize);
        //注意：分页信息必须在要分页的sql的上一行  他俩得紧挨着
        List<Customer> customerList = customerMapper.selectList(wrapper);

        return customerList;
    }
}
