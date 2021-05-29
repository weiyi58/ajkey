package com.yfj.cdkey.service.impl;

import com.yfj.cdkey.dao.CDKeyDao;
import com.yfj.cdkey.domain.CDKey;
import com.yfj.cdkey.service.CDKeyService;
import com.yfj.exception.LoginException;
import com.yfj.service.StudentService;
import com.yfj.untils.DateTimeUtil;
import com.yfj.untils.RandomStr;
import com.yfj.untils.UUIDUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Service
public class CDKeyServiceimpl implements CDKeyService {
    @Autowired
    private CDKeyDao cdKeyDao;

    @Override
    public CDKey addCDKey(String type) {
        Boolean flag = true;
        CDKey cdKey = new CDKey();

        //处理时间
        //0,日卡；1，周卡；2，月卡；3，季卡；4，半年卡；5，年卡

        cdKey.setState("0");
        cdKey.setCdkey(RandomStr.getRandomStr(12));
        cdKey.setRegisterTime(DateTimeUtil.getSysTime());
        cdKey.setType(type);
        int count = cdKeyDao.addCDKey(cdKey);
        if (count<1){
           cdKey.setState("2");
        }
        return cdKey;
    }

    @Override
    public CDKey getCDKey(String cdkey) {

        return cdKeyDao.getCDKey(cdkey);
    }

    @Override
    public CDKey login(String cdkey) throws LoginException {

        if (cdkey == null){
            throw new LoginException("卡密不存在");
        }
        CDKey cdKey = cdKeyDao.getCDKey(cdkey);
        //1.校验卡密是否存在

            if (cdKey == null){
                throw new LoginException("卡密不存在");
            }
            //2.检测卡密状态
            if ("0".equals(cdKey.getState())){
                //开始激活，根据类型，更改卡密状态和到期时间
                //获取失效时间
                String type = cdKey.getType();
                Calendar cal = Calendar.getInstance();
                if("0".equals(type)){
                    cal.add(Calendar.DATE, 1);
                }else if ("1".equals(type)){
                    cal.add(Calendar.WEEK_OF_YEAR, 1);
                }else if ("2".equals(type)){
                    cal.add(Calendar.MONTH, 1);
                }else if ("3".equals(type)){
                    cal.add(Calendar.MONTH, 3);
                }else if ("4".equals(type)){
                    cal.add(Calendar.MONTH, 6);
                }else if ("5".equals(type)){
                    cal.add(Calendar.MONTH, 12);
                }else{
                    throw new LoginException("卡密类型异常");
                }
                Date d = cal.getTime();
                SimpleDateFormat sp = new SimpleDateFormat("yyyy-MM-dd");
                String date = sp.format(d);
                cdKey.setExpireTime(date);

                String currentTime = DateTimeUtil.getSysTime();
                cdKey.setActivationTime(currentTime);
                long currentTimeMillis = System.currentTimeMillis();
                cdKey.setPantTime(String.valueOf(currentTimeMillis));
                cdKey.setDescription("首次登录，激活卡密");
                //获取激活时间
                cdKeyDao.activate(cdKey);
            }else if ("1".equals(cdKey.getState())){

            }else{
                throw new LoginException("卡密状态异常");
            }
            //2.校验是否过期
            String currentTime = DateTimeUtil.getSysTime();
            String expireTime = cdKey.getExpireTime();
            if (expireTime.compareTo(currentTime)<0){
                throw new LoginException("账号已失效");
            }
            // 3.校验是否多端登录/设备号
            long sysTime = System.currentTimeMillis();
            String pantTime = cdKey.getPantTime();
            if (pantTime==null || "".equals(pantTime)){
                throw new LoginException("心跳时间异常，请稍后再试");
            }
            long lpantTime = Long.parseLong(pantTime);
        System.out.println(lpantTime);
            if (sysTime < lpantTime-7){
                throw new LoginException("禁止设备多端登陆");
            }
        return cdKey;

    }

    @Override
    public void heartcheck(CDKey cdKey) {
        long currentTimeMillis = System.currentTimeMillis();
        cdKey.setPantTime(String.valueOf(currentTimeMillis));
        cdKeyDao.heartcheck(cdKey);
    }

    @Override
    public List<CDKey> query() {
        return cdKeyDao.query();
    }
}
