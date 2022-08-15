package com.sapientia.open.days.backend.shared;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailService;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailServiceClientBuilder;
import com.amazonaws.services.simpleemail.model.*;
import com.sapientia.open.days.backend.shared.dto.UserDto;

public class EmailVerificationService {
    // The HTML body for the email.
    final String HTML_BODY = "<h2>Please verify your email address</h2>"
            + "<p>Thank you for your registration! To be able to log in, please complete the process by clicking on this "
            + "<a href='http://ec2-3-73-158-165.eu-central-1.compute.amazonaws.com:8080/verification-service/email-verification.html?token=$tokenValue'>"
            + "link" + "</a><br/><bt/>";

    // The mail body for recipients with non-HTML email clients
    final String TEXT_BODY = "Please verify your email address. "
            + " Thank you for your registration! To be able to log in, please complete the process by opening the following link in you browser: "
            + " http://ec2-3-73-158-165.eu-central-1.compute.amazonaws.com:8080/verification-service/email-verification.html?token=$tokenValue";

    public void verifyEmail(UserDto userDto) {
        AmazonSimpleEmailService client = AmazonSimpleEmailServiceClientBuilder.standard().withRegion(Regions.EU_CENTRAL_1)
                .build();

        String htmlBodyWithToken = HTML_BODY.replace("$tokenValue", userDto.getEmailVerificationToken());
        String textBodyWithToken = TEXT_BODY.replace("$tokenValue", userDto.getEmailVerificationToken());

        String charset = "UTF-8";
        String senderEmail = "geergely.zsolt@gmail.com";
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
}