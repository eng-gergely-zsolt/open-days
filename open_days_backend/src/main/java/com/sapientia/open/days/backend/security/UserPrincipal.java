package com.sapientia.open.days.backend.security;

import com.sapientia.open.days.backend.io.entity.AuthorityEntity;
import com.sapientia.open.days.backend.io.entity.RoleEntity;
import com.sapientia.open.days.backend.io.entity.UserEntity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.Serial;
import java.util.Collection;
import java.util.HashSet;

@SuppressWarnings("unused")
public class UserPrincipal implements UserDetails {

	@Serial
	private static final long serialVersionUID = 1911049411012940256L;

	private String publicId;
	private final UserEntity userEntity;

	public UserPrincipal(UserEntity userEntity) {
		this.userEntity = userEntity;
		this.publicId = userEntity.getPublicId();
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {

		Collection<RoleEntity> roles = userEntity.getRoles();
		Collection<GrantedAuthority> authorities = new HashSet<>();
		Collection<AuthorityEntity> authorityEntities = new HashSet<>();

		if (roles == null) return authorities;

		roles.forEach((role) -> {
			authorities.add(new SimpleGrantedAuthority(role.getName()));
			authorityEntities.addAll(role.getAuthorities());
		});

		authorityEntities.forEach((authorityEntity) -> authorities.add(
				new SimpleGrantedAuthority(authorityEntity.getName())));

		return authorities;
	}

	public String getPublicId() {
		return publicId;
	}

	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}

	@Override
	public boolean isAccountNonLocked() {
		return true;
	}

	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}

	@Override
	public String getUsername() {
		return this.userEntity.getUsername();
	}

	@Override
	public String getPassword() {
		return this.userEntity.getEncryptedPassword();
	}

	@Override
	public boolean isEnabled() {
		return this.userEntity.getEmailVerificationStatus();
	}
}