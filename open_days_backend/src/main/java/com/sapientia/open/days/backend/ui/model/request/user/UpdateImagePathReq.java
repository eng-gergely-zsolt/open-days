package com.sapientia.open.days.backend.ui.model.request.user;

public class UpdateImagePathReq {
	private String publicId;
	private String imagePath;

	public String getPublicId() {
		return publicId;
	}

	public String getImagePath() {
		return imagePath;
	}

	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}
}
