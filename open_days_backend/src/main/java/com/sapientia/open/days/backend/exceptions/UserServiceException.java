package com.sapientia.open.days.backend.exceptions;

import java.io.Serial;

public class UserServiceException extends RuntimeException {
    @Serial
    private static final long serialVersionUID = 4460366926602512635L;

    public UserServiceException(String message) {
        super(message);
    }
}
