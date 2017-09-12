//
//  EDDateHelper.swift
//  EDDateHelper
//
//  Created by Eugene Kalyada on 12.09.17.
//  Copyright © 2017 Eugene Kalyada. All rights reserved.
//

import UIKit
import EDLocalizator

open class EDDateHelper {

	open static var timezone = TimeZone(abbreviation: "UTC")!

	open static var locale = Locale(identifier: "en_US")

	public enum Format: String {
		case ISODateTime = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		case ISODate = "yyyy-MM-dd"
		case USDateShort = "MM/dd/yyyy"
		case USDateShort2 = "MM-dd-yyyy"
		case USDate = "MMM dd, yyyy"
		case USDateTime = "MMM dd, yyyy, h:mm a"
		case fullMonth = "MMMM"
		case fullYear = "yyyy"
		case monthYear = "MMM yyyy"
		case monthYr = "MMM yy"
	}

	open static var instance: EDDateHelper {
		get {
			return EDDateHelper()
		}
	}

	open static var formatter : DateFormatter {
		get {
			let formatter = DateFormatter()
			formatter.dateFormat = Format.ISODateTime.rawValue
			formatter.timeZone = EDDateHelper.timezone
			formatter.locale = EDDateHelper.locale
			return formatter
		}
	}

	open static var dateFormatter : DateFormatter {
		get {

			let formatter = EDDateHelper.formatter
			formatter.dateFormat = Format.ISODate.rawValue
			return formatter
		}
	}

	open static func dateFrom(string: String, format: Format) -> Date? {
		return self.dateFrom(string: string, format: format.rawValue)
	}

	open static func dateFrom(string: String, format: String) -> Date? {
		let formatter = EDDateHelper.formatter
		formatter.dateFormat = format
		return formatter.date(from: string)
	}

	open static func stringFrom(date: Date, format: Format) -> String {
		let formatter = EDDateHelper.formatter
		formatter.dateFormat = format.rawValue
		return formatter.string(from: date)
	}

	open var calendar : Calendar {
		var calendar = Calendar(identifier: .iso8601)
		calendar.timeZone = EDDateHelper.timezone
		return calendar
	}

	open func displayDate(_ date: Date) -> String{
		let formatter = EDDateHelper.dateFormatter
		formatter.dateFormat = Format.USDate.rawValue
		return formatter.string(from: date)
	}

	open func displayDateTime(_ date: Date, _ localTimeZone: Bool?) -> String{
		let formatter = EDDateHelper.dateFormatter
		if let bool = localTimeZone, bool == true {
			formatter.timeZone = TimeZone.current
		}
		formatter.dateFormat = Format.USDateTime.rawValue
		return formatter.string(from: date)
	}



	open func lastDateMonth(date: Date) -> Date {
		let dayRange = calendar.range(of: .day, in: .month, for: date)
		let dayCount = dayRange?.count
		var comp = calendar.dateComponents([.year, .month, .day], from: date)
		comp.hour = 23
		comp.minute = 59
		comp.second = 59
		comp.day = dayCount

		return calendar.date(from: comp)!
	}

	open func firstDateMoth(date: Date) -> Date {
		var comp = calendar.dateComponents([.year, .month, .day], from: date)
		comp.hour = 0
		comp.minute = 0
		comp.second = 0
		comp.day = 1

		return calendar.date(from: comp)!
	}

	open func resetTime(date: Date) -> Date {
		var comp = calendar.dateComponents([.year, .month, .day, .hour], from: date)
		comp.hour = 0
		comp.minute = 0
		comp.second = 0
		return calendar.date(from: comp)!
	}

	open func increaseMonth(date: Date) -> Date {
		var comp = calendar.dateComponents([.year, .month, .day], from: date)
		//if year is actual
		if comp.month != 12 {
			comp.month = comp.month! + 1
		}
		else {
			comp.month = 1
			comp.year = comp.year! + 1
		}
		return calendar.date(from: comp)!
	}

	open func timeAgoSinceDate(date:Date, numericDates:Bool) -> String {
		let calendar = NSCalendar.current
		let unitFlags : Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
		let now = Date()
		let earliest = now < date ? now : date
		let latest = (earliest == now) ? date : now
		let components:DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)

		var template = ""
		var argumnets: CVarArg = 1

		if (components.year! >= 2) {
			template = "years"
			argumnets = components.year!
		}
		else if (components.year! >= 1){
			if (numericDates){
				template = "year"
				argumnets = 1
			}
			else {
				template = "last_year"
			}
		}
		else if (components.month! >= 2) {
			template = "months"
			argumnets = components.month!

		}
		else if (components.month! >= 1){
			if (numericDates){
				template = "month"
				argumnets = 1
			}
			else {
				template = "last_month"
			}
		}
		else if (components.weekOfYear! >= 2) {
			template = "weeks"
			argumnets = components.weekOfYear!
		}
		else if (components.weekOfYear! >= 1){
			if (numericDates){
				template = "week"
				argumnets = 1
			}
			else {
				template = "last_week"
			}
		}
		else if (components.day! >= 2) {
			template = "days"
			argumnets = components.day!
		}
		else if (components.day! >= 1){
			if (numericDates){
				template = "day"
				argumnets = 1
			}
			else {
				template = "yesterday"
			}
		}
		else if (components.hour! >= 2) {
			template = "hours"
			argumnets = components.hour!
		}
		else if (components.hour! >= 1){
			if (numericDates){
				template = "hour"
				argumnets = 1
			}
			else {
				template = "an_hour"
			}
		}
		else if (components.minute! >= 2) {
			template = "minutes"
			argumnets = components.minute!
		}
		else if (components.minute! >= 1){
			if (numericDates){
				template = "minute"
				argumnets = 1
			}
			else {
				template = "1_minute"
			}
		}
		else if (components.second! >= 3) {
			template = "seconds"
			argumnets = components.second!
		}
		else {
			template = "now"
		}
		return "Date.Ago.\(template)".localized(argumnets)

	}

}
