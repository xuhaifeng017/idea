package cn.happy.service.Impl;

import cn.happy.dao.IUserInfoDAO;
import cn.happy.entity.UserInfo;
import cn.happy.service.IUserInfoService;
import cn.happy.util.PageUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by 13447 on 2017/11/9.
 */
/*@Service用于标注业务层组件*/
@Service("userService")
public class UserInfoServiceImpl implements IUserInfoService {
    /*@Resource默认安照名称进行装配*/
    @Resource(name = "IUserInfoDAO")
   private IUserInfoDAO userInfoDAO;
    /*登陆*/
    public UserInfo Login(UserInfo info) {
        return userInfoDAO.Login(info);
    }
    /*用户模糊查询分页*/
    public PageUtil<UserInfo> findOnePageData(int pageindex, int pagesize,String userName) {
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("pageIndex",(pageindex-1)*pagesize);
        map.put("pageSize",pagesize);
        map.put("userName", userName);
        PageUtil<UserInfo> page=new PageUtil<UserInfo>();
        page.setPageIndex(pageindex);
        page.setPageSize(pagesize);
        int totalRecords = userInfoDAO.getTotalRecords(map);
        page.setTotalRecords(totalRecords);
        page.setTotalPages(page.getTotalRecords()%page.getPageSize()==0?page.getTotalRecords()/page.getPageSize():page.getTotalRecords()/page.getPageSize()+1);
        page.setList(userInfoDAO.findOnePageData(map));

        return page;
    }
     /*添加用户*/
    public Boolean addUser(UserInfo info) {
        return userInfoDAO.addUser(info);

    }

    public boolean delectUser(int id) {
        return userInfoDAO.delectUser(id);
    }

    public boolean updataUser(UserInfo info) {
        return userInfoDAO.updataUser(info);
    }

    public UserInfo getAllUserId(int id) {
        return userInfoDAO.getAllUserId(id);
    }


}
