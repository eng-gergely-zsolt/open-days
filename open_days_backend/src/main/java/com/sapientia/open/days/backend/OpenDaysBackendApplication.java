package com.sapientia.open.days.backend;

import com.sapientia.open.days.backend.security.ApplicationProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@SpringBootApplication
public class OpenDaysBackendApplication {

	public static void main(String[] args) {
		SpringApplication.run(OpenDaysBackendApplication.class, args);
	}

	@Bean
	public BCryptPasswordEncoder bCryptPasswordEncoder() { return new BCryptPasswordEncoder(); }

	@Bean
	public SpringApplicationContext springApplicationContext() { return new SpringApplicationContext(); }

	@Bean(name = "ApplicationProperties")
	public ApplicationProperties getApplicationProperties() {
		return new ApplicationProperties();
	}
}
