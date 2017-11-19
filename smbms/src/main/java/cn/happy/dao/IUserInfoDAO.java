package cn.happy.dao;

import cn.happy.entity.UserInfo;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * Created by 13447 on 2017/11/9.
 */
public interface IUserInfoDAO {
         /*登陆*/
    public UserInfo Login(UserInfo info);

    /*分页查询*/
    public List<UserInfo> findOnePageData(Map<String, Object> map);
    /*获得总记录数*/
    public int getTotalRecords(Map<String, Object> map);

    public Boolean addUser(UserInfo info);

    public boolean delectUser(int id);

    public boolean updataUser(UserInfo info);

    public UserInfo getAllUserId(int id);
}
