package com.bjpn.workbench.service;

import com.bjpn.workbench.bean.Activity;
import com.baomidou.mybatisplus.extension.service.IService;
import com.bjpn.workbench.bean.LikeActivity;

import java.util.List;

/**
 * <p>
 * 服务类
 * </p>
 *
 * @author ${author}
 * @since 2022-11-11
 */
public interface ActivityService extends IService<Activity> {
    //模糊查询带分页
    List<Activity> findAllActivityByLikePage(int pageNum, int pageSize, LikeActivity likeActivity);

    //查询所有市场活动信息  用于批量下载
    List<Activity> exportActivityAll();

    // 批量导入
    boolean importExcelByList(List<Activity> list);
//根据id修改
//boolean updatesById(Activity activity);
}
