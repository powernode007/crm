package com.bjpn.workbench.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.bjpn.settings.mapper.UserMapper;
import com.bjpn.settings.service.UserService;
import com.bjpn.workbench.bean.Activity;
import com.bjpn.workbench.bean.LikeActivity;
import com.bjpn.workbench.mapper.ActivityMapper;
import com.bjpn.workbench.service.ActivityService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

import com.github.pagehelper.PageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author ${author}
 * @since 2022-11-11
 */
@Service
public class ActivityServiceImpl extends ServiceImpl<ActivityMapper, Activity> implements ActivityService {
    @Autowired(required = false)
    ActivityMapper activityMapper;
    @Autowired
    UserService userService;


    @Override
    public List<Activity> findAllActivityByLikePage(int pageNum, int pageSize, LikeActivity likeActivity) {
        QueryWrapper<Activity> wrapper = Wrappers.query();
        //拼装模糊查询条件
        if(likeActivity.getLikeActivityName()!=null && !"".equals(likeActivity.getLikeActivityName())){
            wrapper.like("activity_name", likeActivity.getLikeActivityName());
        }
        if(likeActivity.getLikeStartDate()!=null && !"".equals(likeActivity.getLikeStartDate())){
            wrapper.ge("activity_start_date", likeActivity.getLikeStartDate());
        }
        if(likeActivity.getLikeEndDate()!=null && !"".equals(likeActivity.getLikeEndDate())){
            wrapper.le("activity_end_date", likeActivity.getLikeEndDate());
        }
        //likeActivityOwner 如果不传值就是查询所有用户 或者用户信息无所谓
        if(likeActivity.getLikeActivityOwner()!=null && !"".equals(likeActivity.getLikeActivityOwner())){
            //如果传递用户信息  此时用户信息是一个用户名的一部分  武    武松  武二
            //从用户表中查询用户id  放入一个list集合
            //在Activity表中  用户的信息 是一个id
            List<Integer> userIds = userService.findIdsByActivityOwner(likeActivity.getLikeActivityOwner());
            wrapper.in("activity_owner", userIds);
        }

        //sql语句被调用之前 就是分页插件引入的位置
        PageHelper.startPage(pageNum, pageSize);
        //注意：分页信息必须在要分页的sql的上一行  他俩得紧挨着
        List<Activity> activityList = activityMapper.selectList(wrapper);

        return activityList;
    }

    @Override
    public List<Activity> exportActivityAll() {
        QueryWrapper<Activity> query = Wrappers.query();
        List<Activity> activityList = activityMapper.selectList(query);
        return activityList;
    }

    @Override
    public boolean importExcelByList(List<Activity> list) {

        return activityMapper.importActivityByList(list);
    }

//    @Override
//    public boolean updatesById(Activity activity) {
//        return activityMapper.updatesById(activity);
//    }


}

