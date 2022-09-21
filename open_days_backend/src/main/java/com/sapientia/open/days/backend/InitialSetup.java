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

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

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
	CountyRepository countyRepository;

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
				new SettlementModel("Harghita", "Csíkszereda"),
				new SettlementModel("Maros", "Marosvásárhely")
		));

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
				new InstitutionModel("Csíkszereda", "Márton Áron Főgimnázium"),
				new InstitutionModel("Marosvásárhely", "Bolyai Farkas Líceum")
		));

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

		RoleEntity roleAdmin = roleRepository.findByName(Roles.ROLE_USER.name());
		UserEntity adminUser = userRepository.findByEmail("admin@mailinator.com");

		if (adminUser == null && roleAdmin != null) {
			adminUser = new UserEntity();
			InstitutionEntity institution = institutionRepository.findByName("Márton Áron Főgimnázium");

			adminUser.setUsername("admin");
			adminUser.setLastName("Zsolt");
			adminUser.setFirstName("Gergely");
			adminUser.setInstitution(institution);
			adminUser.setEmail("admin@mailinator.com");
			adminUser.setEmailVerificationStatus(true);
			adminUser.setPublicId(utils.generatePublicId(15));
			adminUser.setEncryptedPassword(bCryptPasswordEncoder.encode("Pass1234"));
			adminUser.setRoles(new HashSet<>(List.of(roleAdmin)));
			userRepository.save(adminUser);
		}
	}
}