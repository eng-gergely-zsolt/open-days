package com.sapientia.open.days.backend.exceptions;

import com.sapientia.open.days.backend.ui.model.response.ErrorMessageModel;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;

import java.util.Date;

@ControllerAdvice
@SuppressWarnings("unused")
public class ApplicationExceptionHandler {

	/*
	 * A custom error message.
	 * This method is responsible for only one UserServiceException exception.
	 */
	@ExceptionHandler(value = {UserServiceException.class})
	public ResponseEntity<Object> handleUserServiceException(UserServiceException exception, WebRequest request) {

		ErrorMessageModel errorMessages = new ErrorMessageModel(new Date(), exception.getMessage());

		return new ResponseEntity<>(errorMessages, new HttpHeaders(), HttpStatus.INTERNAL_SERVER_ERROR);
	}

	// This method handles all the other, non-specified exceptions.
	@ExceptionHandler(value = {Exception.class})
	public ResponseEntity<Object> handleOtherException(Exception exception, WebRequest request) {

		ErrorMessageModel errorMessages = new ErrorMessageModel(new Date(), exception.getMessage());

		return new ResponseEntity<>(errorMessages, new HttpHeaders(), HttpStatus.INTERNAL_SERVER_ERROR);
	}
}
