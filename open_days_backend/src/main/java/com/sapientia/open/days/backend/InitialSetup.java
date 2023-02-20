package com.sapientia.open.days.backend;

import com.sapientia.open.days.backend.io.entity.*;
import com.sapientia.open.days.backend.io.repository.*;
import com.sapientia.open.days.backend.shared.Authorities;
import com.sapientia.open.days.backend.shared.Roles;
import com.sapientia.open.days.backend.shared.Utils;
import com.sapientia.open.days.backend.ui.model.resource.InstitutionModel;
import com.sapientia.open.days.backend.ui.model.resource.SettlementModel;
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
	Utils utils;

	@Autowired
	UserRepository userRepository;

	@Autowired
	RoleRepository roleRepository;

	@Autowired
	EventRepository eventRepository;

	@Autowired
	CountyRepository countyRepository;

	@Autowired
	ActivityRepository activityRepository;

	@Autowired
	AuthorityRepository authorityRepository;

	@Autowired
	SettlementRepository settlementRepository;

	@Autowired
	InstitutionRepository institutionRepository;

	@Autowired
	BCryptPasswordEncoder bCryptPasswordEncoder;

	@Autowired
	OrganizerEmailRepository organizerEmailRepository;

	@EventListener
	@Transactional
	@SuppressWarnings("unused")
	public void onApplicationEvent(ApplicationReadyEvent event) {
		createCounties();
		createSettlements();
		createInstitutions();
		createOrganizerEmails();
		createRolesAndAuthorities();
		createAdminUser();
		createActivities();
		createEvents();
	}

	@Transactional
	private void createCounties() {
		Set<String> counties = new HashSet<>(List.of(
				"Harghita", "Maros"
		));

		for (String county : counties) {
			CountyEntity countyEntity = countyRepository.findByName(county);

			if (countyEntity == null) {
				countyEntity = new CountyEntity(county);
				countyRepository.save(countyEntity);
			}
		}
	}

	@Transactional
	private void createSettlements() {
		Set<SettlementModel> settlements = new HashSet<>(List.of(
				new SettlementModel("Maros", "Marosvasarhely"),
				new SettlementModel("Harghita", "Balanbanya"),
				new SettlementModel("Harghita", "Borszek"),
				new SettlementModel("Harghita", "Csikszentmarton"),
				new SettlementModel("Harghita", "Csikszereda"),
				new SettlementModel("Harghita", "Danfalva"),
				new SettlementModel("Harghita", "Ditro"),
				new SettlementModel("Harghita", "Gyergyoalfalu"),
				new SettlementModel("Harghita", "Gyergyohollo"),
				new SettlementModel("Harghita", "Gyergyoszentmiklos"),
				new SettlementModel("Harghita", "Gyergyovarhegy"),
				new SettlementModel("Harghita", "Gyimesfelsolok"),
				new SettlementModel("Harghita", "Korond"),
				new SettlementModel("Harghita", "Marosheviz"),
				new SettlementModel("Harghita", "Szekelykeresztur"),
				new SettlementModel("Harghita", "Szekelyudvarhely"),
				new SettlementModel("Harghita", "Szentegyhaza"),
				new SettlementModel("Harghita", "Zetelaka")
		));

//		Set<SettlementModel> settlements = new HashSet<>(List.of(
//				new SettlementModel("Maros", "Marosvasarhely"),
//				new SettlementModel("Harghita", "Csikszereda")
//		));

		for (SettlementModel settlement : settlements) {
			CountyEntity county = countyRepository.findByName(settlement.county());

			if (county != null) {
				SettlementEntity settlementEntity = settlementRepository.findByName(settlement.settlement());

				if (settlementEntity == null) {
					settlementEntity = new SettlementEntity();
					settlementEntity.setCounty(county);
					settlementEntity.setName(settlement.settlement());
					settlementRepository.save(settlementEntity);
				}
			}
		}
	}

	@Transactional
	private void createInstitutions() {
		Set<InstitutionModel> institutions = new HashSet<>(List.of(
				new InstitutionModel("Marosvasarhely", "Bolyai Farkas Liceum"),
				new InstitutionModel("Balanbanya", "Liviu Rebreanu Szakkozepiskola"),
				new InstitutionModel("Borszek", "Zimmethausen Szakliceum"),
				new InstitutionModel("Csikszentmarton", "Tivai Nagy Imre Szakkozepiskola"),
				new InstitutionModel("Csikszereda", "Marton Aron Fogimnazium"),
				new InstitutionModel("Csikszereda", "Segito Maria Romai Katolikus Gimnazium"),
				new InstitutionModel("Csikszereda", "Joannes Kajoni Szakkozepiskola"),
				new InstitutionModel("Csikszereda", "Octavian Goga Fogimnazium"),
				new InstitutionModel("Csikszereda", "Kos Karoly Szakkozepiskola"),
				new InstitutionModel("Csikszereda", "Venczel Jozsef Szakkozepiskola"),
				new InstitutionModel("Csikszereda", "Szekely Karoly Szakkozepiskola"),
				new InstitutionModel("Danfalva", "Petofi Sandor Iskolakozpont"),
				new InstitutionModel("Ditro", "Puskas Tivadar Szakkozepiskola"),
				new InstitutionModel("Gyergyoalfalu", "Sover Elek Szakkozepiskola"),
				new InstitutionModel("Gyergyohollo", "Gyergyoholloi Szakkozepiskola"),
				new InstitutionModel("Gyergyoszentmiklos", "Salamon Erno Gimnazium"),
				new InstitutionModel("Gyergyoszentmiklos", "Batthyany Ignac Technikai Kollegium"),
				new InstitutionModel("Gyergyoszentmiklos", "Sfantu Nicolae Gimnazium"),
				new InstitutionModel("Gyergyoszentmiklos", "Fogarasy Mihaly Szakkozepiskola"),
				new InstitutionModel("Gyergyovarhegy", "Miron Cristea Liceum"),
				new InstitutionModel("Gyimesfelsolok", "Arpad-hazi Szent Erzsebet Romai Katolikus Teologiai Liceum"),
				new InstitutionModel("Korond", "Korondi Szakkozepiskola"),
				new InstitutionModel("Marosheviz", "O.C. Taslauanu Gimnazium"),
				new InstitutionModel("Marosheviz", "Kemeny Janos Elmeleti Liceum"),
				new InstitutionModel("Marosheviz", "Mihai Eminescu Fogimnazium"),
				new InstitutionModel("Szekelykeresztur", "Berde Mozes Unitarius Gimnazium"),
				new InstitutionModel("Szekelykeresztur", "Orban Balazs Gimnazium"),
				new InstitutionModel("Szekelyudvarhely", "Tamasi Aron Gimnazium"),
				new InstitutionModel("Szekelyudvarhely", "Benedek Elek Pedagogiai Liceum"),
				new InstitutionModel("Szekelyudvarhely", "Baczkamadarasi Kis Gergely Reformatus Kollegium"),
				new InstitutionModel("Szekelyudvarhely", "Kos Karoly Szakkozepiskola"),
				new InstitutionModel("Szekelyudvarhely", "Eotvos Jozsef Szakkozepiskola"),
				new InstitutionModel("Szekelyudvarhely", "Marin Preda Liceum"),
				new InstitutionModel("Szekelyudvarhely", "Banyai Janos Muszaki Szakkozepiskola"),
				new InstitutionModel("Szentegyhaza", "Gabor Aron Szakkozepiskola"),
				new InstitutionModel("Zetelaka", "Dr. P. Boros Fortunat Elmeleti Kozepiskola")
		));

//		Set<InstitutionModel> institutions = new HashSet<>(List.of(
//				new InstitutionModel("Marosvasarhely", "Bolyai Farkas Liceum"),
//				new InstitutionModel("Csikszereda", "Marton Aron Fogimnazium")
//		));

		for (InstitutionModel institution : institutions) {
			SettlementEntity settlement = settlementRepository.findByName(institution.settlement());

			if (settlement != null) {
				InstitutionEntity institutionEntity = institutionRepository.findByName(institution.institution());

				if (institutionEntity == null) {
					institutionEntity = new InstitutionEntity();
					institutionEntity.setSettlement(settlement);
					institutionEntity.setName(institution.institution());
					institutionRepository.save(institutionEntity);
				}
			}
		}
	}

	@Transactional
	private void createOrganizerEmails() {
		HashSet<String> organizerEmails = new HashSet<>(List.of(
				"anomakyr@gmail.com",
				"organizer1@gmail.com",
				"organizer2@gmail.com"
		));

		for (String organizerEmail : organizerEmails) {
			OrganizerEmailEntity organizerEmailEntity = organizerEmailRepository.findByEmail(organizerEmail);

			if (organizerEmailEntity == null) {
				organizerEmailEntity = new OrganizerEmailEntity(organizerEmail);
				organizerEmailRepository.save(organizerEmailEntity);
			}
		}
	}

	private void createRolesAndAuthorities() {
		AuthorityEntity readAuthority = createAuthority(Authorities.READ_AUTHORITY.name());
		AuthorityEntity writeAuthority = createAuthority(Authorities.WRITE_AUTHORITY.name());
		AuthorityEntity deleteAuthority = createAuthority(Authorities.DELETE_AUTHORITY.name());

		createRole(Roles.ROLE_USER.name(), new HashSet<>(Arrays.asList(readAuthority, writeAuthority)));
		createRole(Roles.ROLE_ORGANIZER.name(), new HashSet<>(Arrays.asList(readAuthority, writeAuthority)));
		createRole(Roles.ROLE_ADMIN.name(), new HashSet<>(List.of(readAuthority, writeAuthority, deleteAuthority)));
	}

	@Transactional
	private AuthorityEntity createAuthority(String name) {

		AuthorityEntity authorityEntity = authorityRepository.findByName(name);

		if (authorityEntity == null) {
			authorityEntity = new AuthorityEntity(name);
			authorityRepository.save(authorityEntity);
		}
		return authorityEntity;
	}

	@Transactional
	private void createRole(String name, HashSet<AuthorityEntity> authorities) {
		RoleEntity roleEntity = roleRepository.findByName(name);

		if (roleEntity == null) {
			roleEntity = new RoleEntity(name);
			roleEntity.setAuthorities(authorities);
			roleRepository.save(roleEntity);
		}
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
	private void createActivities() {
		ArrayList<ActivityEntity> activities = new ArrayList<>();

		activities.add(new ActivityEntity("Activity 1"));
		activities.add(new ActivityEntity("Activity 2"));
		activities.add(new ActivityEntity("Activity 3"));

		for (ActivityEntity activity : activities) {
			if (activityRepository.findByName(activity.getName()) == null) {
				activityRepository.save(activity);
			}
		}
	}

	private void createEvents() {
		ActivityEntity activity1 = activityRepository.findByName("Activity 1");
		ActivityEntity activity2 = activityRepository.findByName("Activity 2");
		UserEntity organizer = userRepository.findByEmail("organizer@mailinator.com");

		if (activity1 == null || activity2 == null || organizer == null) {
			return;
		}

		ArrayList<EventEntity> events = new ArrayList<>();

		events.add(new EventEntity(false, "Sapientia",
				"2023-09-15 10:15", null, organizer, activity1));

		events.add(new EventEntity(false, "312-es terem",
				"2023-10-20 11:20", null, organizer, activity1));

		events.add(new EventEntity(false, "Sportpalya",
				"2023-11-25 15:30", null, organizer, activity1));

		events.add(new EventEntity(false, "314-es terem",
				"2021-08-02 09:30", null, organizer, activity1));

		events.add(new EventEntity(false, "Udvar",
				"2023-08-02 22:30", null, organizer, activity2));

		events.add(new EventEntity(false, "Aula",
				"2023-04-22 19:45", null, organizer, activity2));

		events.add(new EventEntity(false, "1. emelet",
				"2024-01-26 07:12", null, organizer, activity2));

		events.add(new EventEntity(true, "2. emelet",
				"2024-01-08 09:10", "https://meeting.com", organizer, activity2));

		for (EventEntity event : events) {
			if (eventRepository.findByLocation(event.getLocation()) == null) {
				eventRepository.save(event);
			}
		}
	}
}