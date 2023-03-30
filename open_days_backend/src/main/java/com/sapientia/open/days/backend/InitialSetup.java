package com.sapientia.open.days.backend;

import com.sapientia.open.days.backend.io.entity.*;
import com.sapientia.open.days.backend.io.repository.*;
import com.sapientia.open.days.backend.shared.Roles;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Component
@SuppressWarnings("unused")
public class InitialSetup {

	@Autowired
	UserRepository userRepository;

	@Autowired
	RoleRepository roleRepository;

	@Autowired
	EventRepository eventRepository;

	@Autowired
	ActivityRepository activityRepository;

	@Autowired
	InstitutionRepository institutionRepository;

	@Autowired
	BCryptPasswordEncoder bCryptPasswordEncoder;

	@EventListener
	@Transactional
	@SuppressWarnings("unused")
	public void onApplicationEvent(ApplicationReadyEvent event) {
		createAdminUser();
		createEvents();
	}

	@Transactional
	private void createAdminUser() {

		RoleEntity roleAdmin = roleRepository.findByName(Roles.ROLE_ADMIN.name());
		UserEntity adminUser = userRepository.findByEmail("admin@mailinator.com");

		if (adminUser == null && roleAdmin != null) {
			adminUser = new UserEntity();
			InstitutionEntity institution = institutionRepository.findByName("Marton Aron Fogimnazium");

			adminUser.setUsername("admin");
			adminUser.setLastName("Zsolt");
			adminUser.setFirstName("Gergely");
			adminUser.setInstitution(institution);
			adminUser.setEmail("admin@mailinator.com");
			adminUser.setEmailVerificationStatus(true);
			adminUser.setPublicId("qwertyuiopasdf1");
			adminUser.setEncryptedPassword(bCryptPasswordEncoder.encode("Pass1234"));
			adminUser.setRoles(new HashSet<>(List.of(roleAdmin)));
			userRepository.save(adminUser);
		}

		RoleEntity roleCreator = roleRepository.findByName(Roles.ROLE_ORGANIZER.name());
		UserEntity organizerUser = userRepository.findByEmail("organizer@mailinator.com");

		if (organizerUser == null && roleCreator != null) {
			organizerUser = new UserEntity();
			InstitutionEntity institution = institutionRepository.findByName("Marton Aron Fogimnazium");

			organizerUser.setUsername("organizer");
			organizerUser.setLastName("User");
			organizerUser.setFirstName("Organizer");
			organizerUser.setInstitution(institution);
			organizerUser.setEmail("organizer@mailinator.com");
			organizerUser.setEmailVerificationStatus(true);
			organizerUser.setPublicId("qwertyuiopasdf2");
			organizerUser.setEncryptedPassword(bCryptPasswordEncoder.encode("Pass1234"));
			organizerUser.setRoles(new HashSet<>(List.of(roleCreator)));
			userRepository.save(organizerUser);
		}

		RoleEntity roleUser = roleRepository.findByName(Roles.ROLE_USER.name());
		UserEntity userUser = userRepository.findByEmail("customer@mailinator.com");

		if (userUser == null && roleUser != null) {
			userUser = new UserEntity();
			InstitutionEntity institution = institutionRepository.findByName("Marton Aron Fogimnazium");

			userUser.setUsername("customer");
			userUser.setLastName("Customer");
			userUser.setFirstName("User");
			userUser.setInstitution(institution);
			userUser.setEmail("customer@mailinator.com");
			userUser.setEmailVerificationStatus(true);
			userUser.setPublicId("qwertyuiopasdf3");
			userUser.setEncryptedPassword(bCryptPasswordEncoder.encode("Pass1234"));
			userUser.setRoles(new HashSet<>(List.of(roleUser)));
			userRepository.save(userUser);
		}
	}

	@Transactional
	private void createEvents() {
		ActivityEntity activity1 = activityRepository.findByName("Kampusztura");
		ActivityEntity activity2 = activityRepository.findByName("Kerteszmernoki tanszek");
		ActivityEntity activity3 = activityRepository.findByName("Gepeszmernoki Tanszek bemutato");
		ActivityEntity activity4 = activityRepository.findByName("Villamosmernoki Tanszek bemutato");
		ActivityEntity activity5 = activityRepository.findByName("Matematika-Informatika Tanszek bemutato");
		ActivityEntity activity6 = activityRepository.findByName("Alkalmazott Nyelveszeti Tanszek bemutato");
		ActivityEntity activity7 = activityRepository.findByName("Alkalmazott Tarsadalomtudomanyok Tanszek bemutato");

		UserEntity organizer = userRepository.findByEmail("organizer@mailinator.com");

		ArrayList<EventEntity> events = new ArrayList<>();

		events.add(new EventEntity(false, "Aula",
				"2024-03-01 10:15", "event/placeholder.jpg", null, organizer, activity1));

		events.add(new EventEntity(false, "C epulet",
				"2024-03-01 10:20", "event/placeholder.jpg", null, organizer, activity2));

		events.add(new EventEntity(false, "Sportpalya",
				"2024-03-02 12:00", "event/placeholder.jpg", null, organizer, activity3));

		events.add(new EventEntity(false, "213-as terem",
				"2024-03-10 09:30", "event/placeholder.jpg", null, organizer, activity4));

		events.add(new EventEntity(false, "114-es terem",
				"2024-03-05 22:30", "event/placeholder.jpg", null, organizer, activity5));

		events.add(new EventEntity(false, "Aula",
				"2024-04-22 19:45", "event/placeholder.jpg", null, organizer, activity6));

		events.add(new EventEntity(false, "1. emelet",
				"2024-05-26 07:12", "event/placeholder.jpg", null, organizer, activity7));

		events.add(new EventEntity(true, "2. emelet",
				"2024-05-08 09:10", "event/placeholder.jpg", "https://meeting.com", organizer, activity1));

		for (EventEntity event : events) {
			if (eventRepository.findByLocation(event.getLocation()) == null) {
				eventRepository.save(event);
			}
		}
	}
}