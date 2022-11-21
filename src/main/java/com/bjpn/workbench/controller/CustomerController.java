package com.bjpn.workbench.controller;


import com.bjpn.settings.bean.User;
import com.bjpn.util.MessageUtil;
import com.bjpn.util.ReturnObject;
import com.bjpn.workbench.bean.Activity;
import com.bjpn.workbench.bean.Customer;
import com.bjpn.workbench.bean.LikeActivity;
import com.bjpn.workbench.bean.LikeCustomer;
import com.bjpn.workbench.service.CustomerService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author ${author}
 * @since 2022-11-18
 */
@Controller
@RequestMapping("/workbench/customer")
public class CustomerController {
    @Autowired
    CustomerService customerService;

    @RequestMapping("/toCustomerIndex.action")
    public String toCustomerIndex() {
        return "workbench/customer/index";
    }

    @RequestMapping("/toAddCustomer.action")
    @ResponseBody
    public ReturnObject toAddCustomer(ReturnObject returnObject, HttpSession session, Customer customer) {
//缺少添加人和添加时间
        //添加时间
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String format = sdf.format(date);
//操作人  就是登陆的用户
        User user = (User) session.getAttribute("user");
        String userId = user.getUserId() + "";
        //页面没有这两个东西，要我们自己添加
        customer.setCreateTime(format);
        customer.setCreateBy(userId);
        boolean save = customerService.save(customer);
        String name = customer.getName();
        for (int i = 0; i < 50; i++) {
            customer.setId(0);
            customer.setName(name + i);
            customerService.save(customer);
        }
        if (save) {
            //成功
            returnObject.setMessageCode(MessageUtil.SUCCESS_CODE);
            returnObject.setMessageStr(MessageUtil.SUCCESS_STR);
        } else {
            //失败
            returnObject.setMessageCode(MessageUtil.FAIL_CODE);
            returnObject.setMessageStr(MessageUtil.FAIL_STR);
        }

        return returnObject;
    }

    //异步模糊查询带分页
    @RequestMapping("/findAllCustomerByLikePage.action")
    @ResponseBody
    public LikeCustomer findAllCustomerByLikePage(@RequestParam(defaultValue = "1") Integer pageNum, @RequestParam(defaultValue = "5") Integer pageSize, LikeCustomer likeCustomer) {
        List<Customer> customerList = customerService.findAllCustomerByLikePage(pageNum, pageSize, likeCustomer);
        PageInfo<Customer> pageInfo = new PageInfo<>(customerList);
        likeCustomer.setPageInfoLike(pageInfo);
        System.out.println("pageInfo.list = " + pageInfo.getList());
        return likeCustomer;
    }

    //异步修改回显
    @RequestMapping("/selectById.action")
    @ResponseBody
    public Customer selectById(Integer  customerId) {
        return customerService.getById(customerId);
    }

    //异步修改
    @RequestMapping("/updateById.action")
    @ResponseBody
    public ReturnObject updateById(ReturnObject returnObject, Customer customer, HttpSession session) {
        //得到修改时间和修改人
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String nowTime = sdf.format(date);
        User user = (User) session.getAttribute("user");
        String editBy = user.getUserId() + "";
        customer.setEditBy(editBy);
        customer.setEditTime(nowTime);
        boolean b = customerService.updateById(customer);
        if (b) {
            returnObject.setMessageCode(MessageUtil.SUCCESS_CODE);
            returnObject.setMessageStr(MessageUtil.SUCCESS_STR);
        } else {
            returnObject.setMessageCode(MessageUtil.FAIL_CODE);
            returnObject.setMessageStr(MessageUtil.FAIL_STR);
        }
        return returnObject;
    }
    //异步删除
    @RequestMapping("/removeById.action")
    @ResponseBody
    public ReturnObject removeById(ReturnObject returnObject, String ids) {
        String[] idsArr = ids.split(",");
        List<String> list = Arrays.asList(idsArr);
        boolean b = customerService.removeByIds(list);
        if (b) {
            returnObject.setMessageCode(MessageUtil.SUCCESS_CODE);
            returnObject.setMessageStr(MessageUtil.SUCCESS_STR);
        } else {
            returnObject.setMessageCode(MessageUtil.FAIL_CODE);
            returnObject.setMessageStr(MessageUtil.FAIL_STR);
        }
        return returnObject;
    }
}