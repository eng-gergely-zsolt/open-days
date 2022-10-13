package com.sapientia.open.days.backend.exceptions;

import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.OperationStatus;
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
	 * This method is responsible for only one GeneralServiceException exception.
	 */
	@ExceptionHandler(value = {GeneralServiceException.class})
	public ResponseEntity<Object> handleUserServiceException(GeneralServiceException exception, WebRequest request) {

		ErrorMessageModel errorMessages = new ErrorMessageModel(exception.getCode(), exception.getMessage(), exception.getOperationResult());

		return new ResponseEntity<>(errorMessages, new HttpHeaders(), HttpStatus.INTERNAL_SERVER_ERROR);
	}

	// This method handles all the other, non-specified exceptions.
	@ExceptionHandler(value = {Exception.class})
	public ResponseEntity<Object> handleOtherException(Exception exception, WebRequest request) {

		ErrorMessageModel errorMessages = new ErrorMessageModel(ErrorCode.UNSPECIFIED_ERROR.getErrorCode(),
				exception.getMessage(), OperationStatus.ERROR.name());

		return new ResponseEntity<>(errorMessages, new HttpHeaders(), HttpStatus.INTERNAL_SERVER_ERROR);
	}
}
