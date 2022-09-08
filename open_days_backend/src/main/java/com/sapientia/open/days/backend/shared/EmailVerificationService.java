package com.sapientia.open.days.backend.shared;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailService;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailServiceClientBuilder;
import com.amazonaws.services.simpleemail.model.*;
import com.sapientia.open.days.backend.shared.dto.UserDTO;

public class EmailVerificationService {
    String senderEmail = "geergely.zsolt@gmail.com";

    // The HTML body for the email.
    final String HTML_BODY = "<h2>Please verify your email address</h2>"
            + "<p>Thank you for your registration! To be able to log in, please complete the process by clicking on this "
            + "<a href='http://localhost:8080/open-days-email-service/email-verification.html?token=$tokenValue'>"
            + "link" + "</a><br/><bt/>";

    // The mail body for recipients with non-HTML email clients
    final String TEXT_BODY = "Please verify your email address. "
            + " Thank you for your registration! To be able to log in, please complete the process by opening the following link in you browser: "
            + " http://localhost:8080/open-days-email-service/email-verification.html?token=$tokenValue";

    public void verifyEmail(UserDTO userDto) {
        AmazonSimpleEmailService client = AmazonSimpleEmailServiceClientBuilder.standard().withRegion(Regions.EU_CENTRAL_1)
                .build();

        String htmlBodyWithToken = HTML_BODY.replace("$tokenValue", userDto.getEmailVerificationToken());
        String textBodyWithToken = TEXT_BODY.replace("$tokenValue", userDto.getEmailVerificationToken());

        String charset = "UTF-8";
        String emailSubject = "Open Days email verification";

        SendEmailRequest request = new SendEmailRequest()
                .withDestination(new Destination().withToAddresses(userDto.getEmail()))
                .withMessage(new Message()
                        .withBody(new Body().withHtml(new Content().withCharset(charset).withData(htmlBodyWithToken))
                                .withText(new Content().withCharset(charset).withData(textBodyWithToken)))
                        .withSubject(new Content().withCharset(charset).withData(emailSubject)))
                .withSource(senderEmail);

        client.sendEmail(request);
    }

    public boolean sendPasswordResetRequest(String firstName, String email, String token) {

        boolean returnValue = false;
        final String passwordResetSubject = "Password reset request";

        final String passwordResetHTMLBody = "<h2>A request to reset password</h2>"
                + "<p> Hi, $firstName!</p>"
                + "<p>If you want to change your password, please click this "
                + "<a href='http://localhost:8080/open-days-email-service/password-reset.html?token=$tokenValue'>"
                + "link" + "</a><br/><bt/>";

        final String passwordResetTextBody = "A request to reset password. "
                + "Hi, $firstName! "
                + " If you want to change your password, please open the below link in your browser: "
                + " http://localhost:8080/open-days-email-service/password-reset.html?token=$tokenValue";

        AmazonSimpleEmailService client = AmazonSimpleEmailServiceClientBuilder.standard().withRegion(Regions.EU_CENTRAL_1)
                .build();

        String htmlBodyWithToken = passwordResetHTMLBody.replace("$tokenValue", token);
        htmlBodyWithToken = htmlBodyWithToken.replace("$firstName", firstName);

        String textBodyWithToken = passwordResetTextBody.replace("$tokenValue", token);
        textBodyWithToken = textBodyWithToken.replace("$firstName", firstName);

        SendEmailRequest request = new SendEmailRequest()
                .withDestination(
                        new Destination().withToAddresses(email))
                .withMessage(new Message()
                        .withBody(new Body()
                                .withHtml(new Content()
                                        .withCharset("UTF-8").withData(htmlBodyWithToken))
                                .withText(new Content()
                                        .withCharset("UTF-8").withData(textBodyWithToken)))
                        .withSubject(new Content()
                                .withCharset("UTF-8").withData(passwordResetSubject)))
                .withSource(senderEmail);

        SendEmailResult result = client.sendEmail(request);

        if (result != null && (result.getMessageId() != null && !result.getMessageId().isEmpty())) {
            return true;
        }

        return returnValue;
    }
}