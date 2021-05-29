package com.yfj.cdkey.dao;

import com.yfj.cdkey.domain.CDKey;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CDKeyDao {
    int addCDKey(CDKey cdKey);

    CDKey getCDKey(String cdkey);

    void activate(CDKey cdKey);

    void heartcheck(CDKey cdKey);

    List<CDKey> query();
}
