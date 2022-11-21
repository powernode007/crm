package com.bjpn.workbench.mapper;

import com.bjpn.workbench.bean.Activity;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author ${author}
 * @since 2022-11-11
 */
public interface ActivityMapper extends BaseMapper<Activity> {
//批量添加
boolean importActivityByList(List<Activity> activityList);
//根据id修改
boolean updatesById(Activity activity);
}
