package com.sapientia.open.days.backend.shared;

import com.sapientia.open.days.backend.security.SecurityConstants;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import net.bytebuddy.utility.RandomString;
import org.springframework.stereotype.Component;

import java.security.SecureRandom;
import java.util.Date;
import java.util.Random;

@Component
public class Utils {

	public static int generateSixDigitNumber() {
		Random random = new Random(System.currentTimeMillis());
		return random.nextInt(1000, 10000);
	}

	public static boolean hasTokenExpired(String token) {
		Claims claims = Jwts.parser()
				.setSigningKey(SecurityConstants.getJwtSecretKey())
				.parseClaimsJws(token).getBody();

		Date currentDate = new Date();
		Date tokenExpirationDate = claims.getExpiration();

		return tokenExpirationDate.before(currentDate);
	}

	public String generatePublicId(int length) {
		StringBuilder result = new StringBuilder(length);
		final Random randomNumber = new SecureRandom();

		for (int i = 0; i < length; ++i) {
			String CHARACTER_SET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
			result.append(CHARACTER_SET.charAt(randomNumber.nextInt(CHARACTER_SET.length())));
		}

		return result.toString();
	}

	public String generateEmailVerificationToken(String userId) {
		return Jwts.builder()
				.setSubject(userId)
				.setExpiration(new Date(System.currentTimeMillis() + SecurityConstants.EXPIRATION_TIME))
				.signWith(SignatureAlgorithm.HS512, SecurityConstants.getJwtSecretKey())
				.compact();
	}

	public String generatePasswordResetToken(String userId) {
		return Jwts.builder()
				.setSubject(userId)
				.setExpiration(new Date(System.currentTimeMillis() + SecurityConstants.PASSWORD_RESET_EXPIRATION_TIME))
				.signWith(SignatureAlgorithm.HS512, SecurityConstants.getJwtSecretKey())
				.compact();
	}
}
