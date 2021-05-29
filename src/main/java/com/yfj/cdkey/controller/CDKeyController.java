package com.yfj.cdkey.controller;
import com.yfj.cdkey.domain.CDKey;
import com.yfj.cdkey.service.CDKeyService;
import com.yfj.exception.LoginException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.List;

@Controller
@RequestMapping("/cdkey")
public class CDKeyController {
    @Resource
    private CDKeyService cdKeyService;

    //注册学生
    @RequestMapping("/getAll.do")
    public ModelAndView getAll(){
        ModelAndView mv = new ModelAndView();
//        String tips = "注册失败";
//        List<CDKey> list = cdKeyService.query();
//        mv.addObject("keylist",list);
        //指定结果页面
        mv.setViewName("index");
        return mv;

    }
    //注册学生
    @RequestMapping("/query.do")
    public List<CDKey> query(){
        ModelAndView mv = new ModelAndView();
        String tips = "注册失败";
        List<CDKey> list = cdKeyService.query();
        return list;

    }

    //注册
    @RequestMapping("/addcdkey.do")
    @ResponseBody
    public String addCDKey(CDKey cdKey){
        String msg = "";
        String type = cdKey.getType();
        //参数检查， 简单的数据处理
        CDKey recdKey =  cdKeyService.addCDKey(type);
        msg += recdKey.getState()+"|"+recdKey.getCdkey()+"|"+recdKey.getDescription();
        return msg;
    }
    //心跳检测
    @RequestMapping("/heartcheck.do")
    @ResponseBody
    public void heartcheck(CDKey cdKey){
        cdKeyService.heartcheck(cdKey);
    }
    //登录校验
    @RequestMapping("/login.do")
    @ResponseBody
    public CDKey login(String cdkey){
        String msg = "";
        //1.根据卡密获取相关信息

        CDKey recdKey = new CDKey();
        try {
            recdKey =  cdKeyService.login(cdkey);
        } catch (LoginException e) {
            e.printStackTrace();
            msg +="0";
            msg +=e.getMessage();
            System.out.println("---------有异常");
            recdKey.setDescription(e.getMessage());
            return recdKey;
        }
        return recdKey;
    }
    @RequestMapping("/querycdkey.do")
    @ResponseBody
    public void querycdkey(){

    }
}
