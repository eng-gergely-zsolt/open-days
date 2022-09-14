package com.sapientia.open.days.backend.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

@Component
@SuppressWarnings("unused")
public class ApplicationProperties {

	@Autowired
	private Environment environment;

	public String getJwtSecretKey() {
		return environment.getProperty("jwtSecretKey");
	}
}
