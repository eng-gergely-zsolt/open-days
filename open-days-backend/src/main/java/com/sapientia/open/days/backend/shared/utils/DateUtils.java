package com.sapientia.open.days.backend.shared.utils;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class DateUtils {

	/**
	 * It converts the give string to a DateTime object.
	 * @param dateTimeString A string that represents a DateTime. It should be in yyyy-MM-dd HH:mm format.
	 * @return It returns a valid DateTime object or null if the given string is not in the required format.
	 */
	public static DateTime getDateTimeFromString(String dateTimeString) {
		DateTime dateTime;
		DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm");

		if (dateTimeString.length() != 16) {
			return null;
		}

		try {
			dateTime =  DateTime.parse(dateTimeString, formatter);
		} catch (Exception exception) {
			return null;
		}

		return dateTime;
	}
}
