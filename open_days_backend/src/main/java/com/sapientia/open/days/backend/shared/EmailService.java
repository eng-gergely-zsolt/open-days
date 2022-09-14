package com.sapientia.open.days.backend.shared;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailService;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailServiceClientBuilder;
import com.amazonaws.services.simpleemail.model.*;
import com.sapientia.open.days.backend.shared.dto.UserDTO;

public class EmailService {

	String charset = "UTF-8";
	String senderEmail = "geergely.zsolt@gmail.com";

	public void verifyEmail(UserDTO userDto) {

		String emailSubject = "Open Days email verification";

		final String textBody = "Please verify your email address. "
				+ " Thank you for your registration! To be able to log in,"
				+ " please complete the process by opening the following link in you browser: "
				+ " http://localhost:8080/open-days-email-service/email-verification.html?token=$tokenValue";

		final String htmlBody = "<h2>Please verify your email address</h2>"
				+ "<p>Thank you for your registration! To be able to log in, please complete the process by clicking on this "
				+ "<a href='http://localhost:8080/open-days-email-service/email-verification.html?token=$tokenValue'>"
				+ "link" + "</a><br/><bt/>";

		AmazonSimpleEmailService emailService = AmazonSimpleEmailServiceClientBuilder.standard().withRegion(Regions.EU_CENTRAL_1).build();

		String htmlBodyWithToken = htmlBody.replace("$tokenValue", userDto.getEmailVerificationToken());
		String textBodyWithToken = textBody.replace("$tokenValue", userDto.getEmailVerificationToken());

		SendEmailRequest request = new SendEmailRequest().withDestination(new Destination().withToAddresses(userDto.getEmail()))
				.withMessage(new Message().withBody(new Body().withHtml(new Content().withCharset(charset)
						.withData(htmlBodyWithToken)).withText(new Content().withCharset(charset)
						.withData(textBodyWithToken))).withSubject(new Content().withCharset(charset)
						.withData(emailSubject))).withSource(senderEmail);

		emailService.sendEmail(request);
	}

	public boolean sendPasswordResetRequest(String firstName, String email, String token) {

		final String passwordResetSubject = "Password reset request";

		final String textBody = "A request to reset password. "
				+ "Hi, $firstName! "
				+ " If you want to change your password, please open the below link in your browser: "
				+ " http://localhost:8080/open-days-email-service/password-reset.html?token=$tokenValue";

		final String htmlBody = "<h2>A request to reset password</h2>"
				+ "<p> Hi, $firstName!</p>"
				+ "<p>If you want to change your password, please click this "
				+ "<a href='http://localhost:8080/open-days-email-service/password-reset.html?token=$tokenValue'>"
				+ "link" + "</a><br/><bt/>";

		AmazonSimpleEmailService emailService = AmazonSimpleEmailServiceClientBuilder.standard().withRegion(Regions.EU_CENTRAL_1).build();

		String htmlBodyWithToken = htmlBody.replace("$tokenValue", token);
		htmlBodyWithToken = htmlBodyWithToken.replace("$firstName", firstName);

		String textBodyWithToken = textBody.replace("$tokenValue", token);
		textBodyWithToken = textBodyWithToken.replace("$firstName", firstName);

		SendEmailRequest request = new SendEmailRequest().withDestination(new Destination().withToAddresses(email))
				.withMessage(new Message().withBody(new Body().withHtml(new Content().withCharset(charset)
						.withData(htmlBodyWithToken)).withText(new Content().withCharset(charset)
						.withData(textBodyWithToken))).withSubject(new Content().withCharset(charset)
						.withData(passwordResetSubject))).withSource(senderEmail);

		SendEmailResult result = emailService.sendEmail(request);

		return (result != null && result.getMessageId() != null && !result.getMessageId().isEmpty());
	}
}