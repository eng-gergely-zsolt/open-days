package com.sapientia.open.days.backend;

import com.sapientia.open.days.backend.io.entity.AuthorityEntity;
import com.sapientia.open.days.backend.io.entity.RoleEntity;
import com.sapientia.open.days.backend.io.entity.UserEntity;
import com.sapientia.open.days.backend.io.repository.AuthorityRepository;
import com.sapientia.open.days.backend.io.repository.RoleRepository;
import com.sapientia.open.days.backend.io.repository.UserRepository;
import com.sapientia.open.days.backend.shared.Roles;
import com.sapientia.open.days.backend.shared.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.Collection;

@Component
public class InitialUserSetup {

	@Autowired
	AuthorityRepository authorityRepository;

	@Autowired
	RoleRepository roleRepository;

	@Autowired
	Utils utils;

	@Autowired
	BCryptPasswordEncoder bCryptPasswordEncoder;

	@Autowired
	UserRepository userRepository;

	// EventListener: Spring framework will call this function if the server up and running.
	@EventListener
	@Transactional
	public void onApplicationEvent(ApplicationReadyEvent event) {
		System.out.println("From Application ready event...");

		AuthorityEntity readAuthority = createAuthority("READ_AUTHORITY");
		AuthorityEntity writeAuthority = createAuthority("WRITE_AUTHORITY");
		AuthorityEntity deleteAuthority = createAuthority("DELETE_AUTHORITY");

		createRole(Roles.ROLE_USER.name(), Arrays.asList(readAuthority, writeAuthority));
		RoleEntity roleAdmin = createRole(Roles.ROLE_ADMIN.name(), Arrays.asList(readAuthority, writeAuthority, deleteAuthority));

		if (roleAdmin == null) return;

		UserEntity adminUser = userRepository.findByEmail("admin@gmail.com");

		if (adminUser == null) {
			adminUser = new UserEntity();
			adminUser.setUsername("admin");
			adminUser.setLastName("Zsolt");
			adminUser.setFirstName("Gergely");
			adminUser.setEmail("admin@gmail.com");
			adminUser.setEmailVerificationStatus(true);
			adminUser.setObjectId(utils.generateObjectId(15));
			adminUser.setEncryptedPassword(bCryptPasswordEncoder.encode("Pass1234"));
			adminUser.setRoles(Arrays.asList(roleAdmin));

			userRepository.save(adminUser);
		}
	}

	@Transactional
	private AuthorityEntity createAuthority(String name) {
		AuthorityEntity authority = authorityRepository.findByName(name);
		if (authority == null) {
			authority = new AuthorityEntity(name);
			authorityRepository.save(authority);
		}
		return authority;
	}

	@Transactional
	private RoleEntity createRole(String name, Collection<AuthorityEntity> authorities) {
		RoleEntity role = roleRepository.findByName(name);
		if (role == null) {
			role = new RoleEntity(name);
			role.setAuthorities(authorities);
			roleRepository.save(role);
		}
		return role;
	}
}