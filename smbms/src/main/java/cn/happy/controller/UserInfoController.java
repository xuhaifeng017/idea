package cn.happy.controller;

import cn.happy.entity.UserInfo;
import cn.happy.service.IUserInfoService;
import cn.happy.util.AgeByBirthday;
import cn.happy.util.PageUtil;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by 13447 on 2017/11/9.
 */
@Controller
public class UserInfoController {

    @Resource(name = "userService")
    IUserInfoService userInfoService;


    //修改用户信息

    @ResponseBody
    @RequestMapping("/updateUser/{id}")
    public Object updateUser(@PathVariable int id,UserInfo user,HttpSession session) throws ParseException {
        System.out.println(id);
        user.setId(id);
        System.out.println(user.getId());
        /*String date=user.getData();
        System.out.println(date);
        SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd");
        Date parse = format.parse(date);
        System.out.println(parse);
        user.setBirthday(parse);*/
        System.out.println(user.getUserType());
        boolean updateCount = userInfoService.updataUser(user);
        return updateCount;

    }
/*    @ResponseBody
    @RequestMapping("/UpdateUser/{id}")
    public Object show(@PathVariable int id,UserInfo userInfo) throws ParseException {
        System.out.println("================="+userInfo.getId());
        System.out.println("id-------->"+id);
        return 1;
    }*/
    //根据id查询用户信息
    @RequestMapping("/getInfoById/{id}")
    public String getInfoById(@PathVariable int id, HttpSession session){
        UserInfo user = userInfoService.getAllUserId(id);
        session.setAttribute("info",user);
        return "/userView.jsp";
    }


    /*用户删除（可批量）*/
    @RequestMapping("/delUser")
    @ResponseBody
    public Object  delectUser(@RequestParam(value="ids") String ids,HttpSession session) throws Exception {
        String[] idstr = ids.split(",");
        boolean delectUser=true;
        for (String id:idstr) {
            delectUser = userInfoService.delectUser(Integer.parseInt(id));
        }
        return delectUser;
    }


    /*用户添加*/
    @RequestMapping("/addUsers")
    @ResponseBody
    public Object addUser(UserInfo info,HttpSession session) {
        System.out.println(info.getPhone());
        boolean aBoolean = userInfoService.addUser(info);
        System.out.println(aBoolean);
        return aBoolean;
    }
     /*后台用户模糊查询分页*/
    @RequestMapping("/userList")
    @ResponseBody
    public Object getUserView(Model model, @RequestParam(defaultValue = "1",required = false , value = "page") int pageIndex, @RequestParam(defaultValue = "2",required = false ,value = "rows")int pageSize,@RequestParam(required = false) String userName){

        PageUtil<UserInfo> page = userInfoService.findOnePageData(pageIndex,pageSize,userName);
        System.out.println(userName);
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("total",page.getTotalRecords());
        map.put("rows",page.getList());
        return map;
    }
   /*用户登陆*/
    @RequestMapping("/login")
    public  String isLogin(UserInfo info,HttpSession session){
        UserInfo userInfo = userInfoService.Login(info);
        if(userInfo!=null){
            session.setAttribute("UserInfo",userInfo);
            return "/jsp/welcome.jsp";
        }else {
            return "/jsp/login.jsp";
        }

    }

    //转换年龄
    public void convertAge(PageUtil<UserInfo> page){
        for (UserInfo u:page.getList()) {
            Date date=u.getBirthday();
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String format = dateFormat.format(date);
            try {
                int getagee = AgeByBirthday.getagee(format);
                u.setAge(getagee);
            } catch (Exception e) {
            }
        }
    }

}
