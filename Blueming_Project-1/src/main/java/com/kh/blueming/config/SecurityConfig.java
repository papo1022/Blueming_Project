package com.kh.blueming.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {
	// Spring Security 디펜던시에서 로그인 화면이 뜨는걸 막는 코드입니다.
	
	@Bean
	public BCryptPasswordEncoder bCryptPasswordEncoder() {
		return new BCryptPasswordEncoder();
	}
	
	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {

	http.authorizeHttpRequests(auth -> auth.anyRequest().permitAll());

	http.csrf(csrf -> csrf.disable());
	
	http.headers(headers ->
		headers.frameOptions(frame ->
		frame.sameOrigin()
		)
	);

	return http.build();
}

}



