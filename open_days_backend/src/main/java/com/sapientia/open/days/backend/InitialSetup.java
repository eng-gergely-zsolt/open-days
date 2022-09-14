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

	@EventListener
	@Transactional
	@SuppressWarnings("unused")
	public void onApplicationEvent(ApplicationReadyEvent event) {
		createCounties();
		createSettlements();
		createInstitutions();
		createAdminUser();
	}

	@Transactional
	private void createAdminUser() {
		AuthorityEntity readAuthority = createAuthority(Authorities.READ_AUTHORITY.name());
		AuthorityEntity writeAuthority = createAuthority(Authorities.WRITE_AUTHORITY.name());
		AuthorityEntity deleteAuthority = createAuthority(Authorities.DELETE_AUTHORITY.name());

		createRole(Roles.ROLE_USER.name(), Arrays.asList(readAuthority, writeAuthority));
		createRole(Roles.ROLE_CREATOR.name(), Arrays.asList(readAuthority, writeAuthority));
		RoleEntity roleAdmin = createRole(Roles.ROLE_ADMIN.name(), List.of(readAuthority, writeAuthority, deleteAuthority));

		UserEntity adminUser = userRepository.findByEmail("admin@mailinator.com");

		if (adminUser == null) {
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

	@Transactional
	private RoleEntity createRole(String name, List<AuthorityEntity> authorities) {
		RoleEntity roleEntity = roleRepository.findByName(name);

		if (roleEntity == null) {
			roleEntity = new RoleEntity(name);
			roleEntity.setAuthorities(authorities);
			roleRepository.save(roleEntity);
		}
		return roleEntity;
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
	private void createCounties() {
		Set<String> counties = new HashSet<>(List.of(
				"Harghita", "Maros"
		));

		for (String countyName : counties) {
			CountyEntity county = countyRepository.findByName(countyName);

			if (county == null) {
				county = new CountyEntity(countyName);
				countyRepository.save(county);
			}
		}
	}

	@Transactional
	private void createSettlements() {
		Set<SettlementModel> settlements = new HashSet<>(List.of(
				new SettlementModel("Harghita", "Csíkszereda"),
				new SettlementModel("Maros", "Marosvásárhely")
		));

		for (SettlementModel settlementModel : settlements) {
			CountyEntity county = countyRepository.findByName(settlementModel.county());

			if (county != null) {
				SettlementEntity settlement = settlementRepository.findByName(settlementModel.settlement());

				if (settlement == null) {
					settlement = new SettlementEntity();
					settlement.setCounty(county);
					settlement.setName(settlementModel.settlement());
					settlementRepository.save(settlement);
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

		for (InstitutionModel institutionModel : institutions) {
			SettlementEntity settlement = settlementRepository.findByName(institutionModel.settlement());

			if (settlement != null) {
				InstitutionEntity institution = institutionRepository.findByName(institutionModel.institution());

				if (institution == null) {
					institution = new InstitutionEntity();
					institution.setSettlement(settlement);
					institution.setName(institutionModel.institution());
					institutionRepository.save(institution);
				}
			}
		}
	}
}