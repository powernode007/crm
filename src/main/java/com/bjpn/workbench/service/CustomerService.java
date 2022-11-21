package com.bjpn.workbench.service;

import com.bjpn.workbench.bean.Activity;
import com.bjpn.workbench.bean.Customer;
import com.baomidou.mybatisplus.extension.service.IService;
import com.bjpn.workbench.bean.LikeCustomer;

import java.util.List;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author ${author}
 * @since 2022-11-18
 */
public interface CustomerService extends IService<Customer> {
    //模糊查询带分页
    List<Customer> findAllCustomerByLikePage(int pageNum, int pageSize, LikeCustomer likeCustomer);
}
