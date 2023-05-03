package com.sapientia.open.days.backend.io.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Set;

@Entity
@Table(name = "settlements")
@SuppressWarnings("unused")
public class SettlementEntity implements Serializable {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;

	@Column(length = 100, nullable = false)
	private String name;

	@OneToMany(mappedBy = "settlement")
	private Set<InstitutionEntity> institutions;

	@ManyToOne
	@JoinColumn(name = "county_id", nullable = false)
	private CountyEntity county;

	public long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public CountyEntity getCounty() {
		return county;
	}

	public Set<InstitutionEntity> getInstitutions() {
		return institutions;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setCounty(CountyEntity county) {
		this.county = county;
	}

	public void setInstitutions(Set<InstitutionEntity> institutions) {
		this.institutions = institutions;
	}
}