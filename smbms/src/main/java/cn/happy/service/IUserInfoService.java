package cn.happy.service;

import cn.happy.entity.UserInfo;
import cn.happy.util.PageUtil;

import java.io.Serializable;
import java.util.Map;

/**
 * Created by 13447 on 2017/11/9.
 */
public interface IUserInfoService {

    public UserInfo Login(UserInfo info);

    //2.查询单页用户数据的方法
    public PageUtil<UserInfo> findOnePageData(int pageindex, int pagesize,String userName);

    public Boolean addUser(UserInfo info);

    public boolean delectUser(int id);

    public boolean updataUser(UserInfo info);

    public UserInfo getAllUserId(int id);
}
