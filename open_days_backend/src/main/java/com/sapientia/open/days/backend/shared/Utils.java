package com.sapientia.open.days.backend.shared;

import org.springframework.stereotype.Component;

import java.security.SecureRandom;
import java.util.Random;

@Component
public class Utils {
    private final Random RANDOM_NUMBER = new SecureRandom();
    private final String CHARACTER_SET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

    public String generateObjectId(int length) { return generateRandomString(length); }

    private String generateRandomString(int length) {
        StringBuilder result = new StringBuilder(length);

        for (int i = 0; i < length; ++i) {
            result.append(CHARACTER_SET.charAt(RANDOM_NUMBER.nextInt(CHARACTER_SET.length())));
        }

        return result.toString();
    }
}
