package com.sapientia.open.days.backend.io.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Set;

@Entity
@SuppressWarnings("unused")
@Table(name = "institutions")
public class InstitutionEntity implements Serializable {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;

	@Column(length = 100, nullable = false)
	private String name;

	@OneToMany(mappedBy = "institution")
	private Set<UserEntity> users;

	@ManyToOne
	@JoinColumn(name = "settlement_id", nullable = false)
	private SettlementEntity settlement;

	public InstitutionEntity() {}

	public InstitutionEntity(long id, String name, SettlementEntity settlement) {
		this.id = id;
		this.name = name;
		this.settlement = settlement;
	}

	public long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public Set<UserEntity> getUsers() {
		return users;
	}

	public SettlementEntity getSettlement() {
		return settlement;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setUsers(Set<UserEntity> users) {
		this.users = users;
	}

	public void setSettlement(SettlementEntity settlement) {
		this.settlement = settlement;
	}
}