package com.sapientia.open.days.backend;

import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@SuppressWarnings("unused")
public class InitialSetup {

	@EventListener
	@Transactional
	public void onApplicationEvent(ApplicationReadyEvent event) {
	}
}