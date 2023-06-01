package com.sapientia.open.days.backend.io.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Collection;
import java.util.Set;

@Entity
@Table(name = "roles")
@SuppressWarnings("unused")
public class RoleEntity implements Serializable {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;

	@Column(nullable = false, length = 20)
	private String name;

	@OneToMany(mappedBy = "role")
	private Collection<UserEntity> users;

	@ManyToMany(cascade = {CascadeType.PERSIST}, fetch = FetchType.EAGER)
	@JoinTable(name = "roles_authorities", joinColumns = @JoinColumn(name = "roles_id", referencedColumnName = "id"),
			inverseJoinColumns = @JoinColumn(name = "authorities_id", referencedColumnName = "id"))
	private Set<AuthorityEntity> authorities;

	public RoleEntity() {}

	public RoleEntity(long id, String name) {
		this.id = id;
		this.name = name;
	}

	public long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public Collection<UserEntity> getUsers() {
		return users;
	}

	public Set<AuthorityEntity> getAuthorities() {
		return authorities;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setUsers(Collection<UserEntity> users) {
		this.users = users;
	}

	public void setAuthorities(Set<AuthorityEntity> authorities) {
		this.authorities = authorities;
	}
}