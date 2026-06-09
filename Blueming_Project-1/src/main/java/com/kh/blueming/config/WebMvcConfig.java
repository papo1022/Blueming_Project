package com.kh.blueming.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.kh.blueming.common.interceptor.LoginInterceptor;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private LoginInterceptor loginInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/",
                        "/member/login",
                        "/member/enrollForm1",
                        "/member/enrollForm2",
                        "/member/sendCodeForId",
                        "/member/findId",
                        "/member/findPwd",
                        "/member/findPwdResult",
                        "/member/resetPwd",
                        "/member/resetPwdResult",
                        "/member/logout",
                        "/resources/**",
                        "/error",
                        "/error/**"
                );
    }
}
