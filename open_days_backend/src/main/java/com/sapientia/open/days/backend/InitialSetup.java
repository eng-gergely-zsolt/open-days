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
		createUsers();
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

		for (SettlementModel settlement : settlements) {
			CountyEntity county = countyRepository.findByName(settlement.getCounty());

			if (county != null) {
				SettlementEntity settlementEntity = settlementRepository.findByName(settlement.getSettlement());

				if (settlementEntity == null) {
					settlementEntity = new SettlementEntity();
					settlementEntity.setCounty(county);
					settlementEntity.setName(settlement.getSettlement());
					settlementRepository.save(settlementEntity);
				}
			}
		}
	}

	@Transactional
	private void createInstitutions() {
		Set<InstitutionModel> institutions = new HashSet<>(List.of(
				new InstitutionModel("Marosvasarhely", "Bolyai Farkas Liceum"),
				new InstitutionModel("Marosvasarhely", "Sapientia EMTE MS"),
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

		for (InstitutionModel institution : institutions) {
			SettlementEntity settlement = settlementRepository.findByName(institution.getSettlement());

			if (settlement != null) {
				InstitutionEntity institutionEntity = institutionRepository.findByName(institution.getInstitution());

				if (institutionEntity == null) {
					institutionEntity = new InstitutionEntity();
					institutionEntity.setSettlement(settlement);
					institutionEntity.setName(institution.getInstitution());
					institutionRepository.save(institutionEntity);
				}
			}
		}
	}

	@Transactional
	private void createOrganizerEmails() {
		HashSet<String> organizerEmails = new HashSet<>(List.of(
				"anomakyr@gmail.com"
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
	private void createUsers() {
		UserEntity adminUser = userRepository.findByEmail("admin@mailinator.com");
		RoleEntity roleAdmin = roleRepository.findByName(Roles.ROLE_ADMIN.name());

		String encryptedPassword = bCryptPasswordEncoder.encode("Pass1234");
		InstitutionEntity institution = institutionRepository.findByName("Sapientia EMTE MS");

		if (adminUser == null && roleAdmin != null) {
			Set<RoleEntity> roles = new HashSet<>(List.of(roleAdmin));

			adminUser = new UserEntity("admin@mailinator.com", "admin", "John", "Doe", "qwertyuiopasdf1",
					encryptedPassword, roles, institution, true);

			userRepository.save(adminUser);
		}

		UserEntity organizerUser = userRepository.findByEmail("organizer@mailinator.com");
		RoleEntity roleOrganizer = roleRepository.findByName(Roles.ROLE_ORGANIZER.name());

		if (organizerUser == null && roleOrganizer != null) {
			Set<RoleEntity> roles = new HashSet<>(List.of(roleOrganizer));

			organizerUser = new UserEntity("geergely.zsolt@gmail.com", "organizer", "Zsolt", "Gergely",
					"qwertyuiopasdf2", encryptedPassword, roles, institution, true);

			userRepository.save(organizerUser);
		}

		RoleEntity roleParticipant = roleRepository.findByName(Roles.ROLE_USER.name());
		UserEntity participantUser = userRepository.findByEmail("customer@mailinator.com");

		if (participantUser == null && roleParticipant != null) {
			Set<RoleEntity> roles = new HashSet<>(List.of(roleParticipant));

			participantUser = new UserEntity("user@mailinator.com", "user", "Marci", "Puck",
					"qwertyuiopasdf3", encryptedPassword, roles, institution, true);

			userRepository.save(participantUser);
		}
	}

	@Transactional
	private void createActivities() {
		ArrayList<ActivityEntity> activities = new ArrayList<>();

		activities.add(new ActivityEntity("Kampusztura"));
		activities.add(new ActivityEntity("Gepeszmernoki tanszekbemutato"));
		activities.add(new ActivityEntity("Kerteszmernoki tanszekbemutato"));
		activities.add(new ActivityEntity("Villamosmernoki tanszekbemutato"));
		activities.add(new ActivityEntity("Matematika-Informatika tanszekbemutato"));
		activities.add(new ActivityEntity("Alkalmazott Nyelveszeti tanszekbemutato"));
		activities.add(new ActivityEntity("Alkalmazott Tarsadalomtudomanyok tanszekbemutato"));

		for (ActivityEntity activity : activities) {
			if (activityRepository.findByName(activity.getName()) == null) {
				activityRepository.save(activity);
			}
		}
	}

	private void createEvents() {
		ArrayList<EventEntity> events = new ArrayList<>();
		UserEntity organizer = userRepository.findByEmail("geergely.zsolt@gmail.com");

		ActivityEntity activity1 = activityRepository.findByName("Kampusztura");
		ActivityEntity activity3 = activityRepository.findByName("Gepeszmernoki tanszekbemutato");
		ActivityEntity activity2 = activityRepository.findByName("Kerteszmernoki tanszekbemutato");
		ActivityEntity activity4 = activityRepository.findByName("Villamosmernoki tanszekbemutato");
		ActivityEntity activity5 = activityRepository.findByName("Matematika-Informatika tanszekbemutato");
		ActivityEntity activity6 = activityRepository.findByName("Alkalmazott Nyelveszeti tanszekbemutato");
		ActivityEntity activity7 = activityRepository.findByName("Alkalmazott Tarsadalomtudomanyok tanszekbemutato");

		String descriptionActivity1 = "Ezen az esemenyen a diakoknak bemutatjuk az egyetem kampuszat erintve a konyvtarat," +
				"HOK-ot, sportpalyat, bentlakast es placcot. öüóőúűéáí";

		events.add(new EventEntity(false, "Sapientia",
				"2024-03-01 10:15", "event/placeholder.jpg", descriptionActivity1, null, organizer, activity1));

		events.add(new EventEntity(false, "312-es terem",
				"2024-03-01 11:20", "event/placeholder.jpg", "", null, organizer, activity2));

		events.add(new EventEntity(false, "Sportpalya",
				"2024-03-10 15:30", "event/placeholder.jpg", "", null, organizer, activity3));

		events.add(new EventEntity(false, "114-es terem",
				"2024-03-15 09:30", "event/placeholder.jpg", "", null, organizer, activity4));

		events.add(new EventEntity(false, "114-es terem",
				"2024-04-02 22:30", "event/placeholder.jpg", "", null, organizer, activity5));

		events.add(new EventEntity(false, "Aula",
				"2024-04-22 19:45", "event/placeholder.jpg", "", null, organizer, activity6));

		events.add(new EventEntity(false, "1. emelet",
				"2024-05-26 07:12", "event/placeholder.jpg", "", null, organizer, activity7));

		events.add(new EventEntity(true, "2. emelet",
				"2024-05-08 09:10", "event/placeholder.jpg", "", "https://meeting.com", organizer, activity1));

		for (EventEntity event : events) {
			if (eventRepository.findByLocation(event.getLocation()) == null) {
				eventRepository.save(event);
			}
		}
	}
}