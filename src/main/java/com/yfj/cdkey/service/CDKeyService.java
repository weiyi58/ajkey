package com.yfj.cdkey.service;

import com.yfj.cdkey.domain.CDKey;
import com.yfj.exception.LoginException;

import java.util.List;

public interface CDKeyService {
    CDKey addCDKey(String type);

    CDKey getCDKey(String cdkey);

    CDKey login(String cdkey) throws LoginException;

    void heartcheck(CDKey cdKey);

    List<CDKey> query();
}
