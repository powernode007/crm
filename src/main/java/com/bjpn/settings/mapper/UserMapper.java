package com.bjpn.settings.mapper;

import com.bjpn.settings.bean.User;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import java.util.List;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author ${author}
 * @since 2022-11-10
 */
public interface UserMapper extends BaseMapper<User> {
List<Integer> findIdsByOwner(String likeActivityOwner);
List<Integer> findIdsByCustomerOwner(String likeOwner);
}
