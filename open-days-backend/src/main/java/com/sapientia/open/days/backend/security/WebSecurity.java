package com.sapientia.open.days.backend.security;

import com.sapientia.open.days.backend.io.repository.UserRepository;
import com.sapientia.open.days.backend.service.UserService;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@EnableWebSecurity
@EnableGlobalMethodSecurity(securedEnabled = true, prePostEnabled = true)
public class WebSecurity extends WebSecurityConfigurerAdapter {
	private final UserRepository userRepository;
	private final UserService userDetailsService;
	private final BCryptPasswordEncoder bCryptPasswordEncoder;

	public WebSecurity(UserRepository userRepository,
	                   UserService userDetailsService,
	                   BCryptPasswordEncoder bCryptPasswordEncoder) {

		this.userRepository = userRepository;
		this.userDetailsService = userDetailsService;
		this.bCryptPasswordEncoder = bCryptPasswordEncoder;
	}

	/*
	 * Needed to set some endpoints public and others protected.
	 * Makes Spring to not create sessions -> Our REST API is stateless.
	 * Prevents authorization headers to be cached.
	 */
	@Override
	protected void configure(HttpSecurity httpSecurity) throws Exception {
		httpSecurity
				.cors().and()
				.csrf().disable().authorizeHttpRequests()
				.antMatchers(HttpMethod.GET, SecurityConstants.GET_INSTITUTIONS)
				.permitAll()
				.antMatchers(HttpMethod.GET, SecurityConstants.GET_FUTURE_EVENTS_URL)
				.permitAll()
				.antMatchers(HttpMethod.POST, SecurityConstants.CREATE_USER_URL)
				.permitAll()
				.antMatchers(HttpMethod.PUT, SecurityConstants.VERIFY_EMAIL_BY_OTP_CODE_URL)
				.permitAll()
				.anyRequest().authenticated().and()
				.addFilter(getAuthenticationFilter())
				.addFilter(new AuthorizationFilter(authenticationManager(), userRepository))
				.sessionManagement()
				.sessionCreationPolicy(SessionCreationPolicy.STATELESS);
	}

	// An encryption method to protect password. Spring security framework.
	@Override
	public void configure(AuthenticationManagerBuilder authenticationManagerBuilder) throws Exception {
		authenticationManagerBuilder.userDetailsService(userDetailsService).passwordEncoder(bCryptPasswordEncoder);
	}

	// This function will change the endpoint name.
	public AuthenticationFilter getAuthenticationFilter() throws Exception {
		final AuthenticationFilter filter = new AuthenticationFilter(authenticationManager());
		filter.setFilterProcessesUrl("/user/login");
		return filter;
	}
}
