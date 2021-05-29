package com.yfj.exception;

public class LoginException extends Exception {
    public LoginException(String msg){
        //相当于写了一个带参的构造函数，就没有无参的构造方法了
        super(msg);
    }
}
