import UIKit

var greeting = "Hello, playground"
let testDates = [
    "20231202T200000Z",  // Normal datetime
    "20231202",          // All-day event
    "DTSTART;VALUE=DATE:20231202"  // All-day with VALUE=DATE
]

testDates.forEach {
    if let date = parseDate($0) {
        print("Successfully parsed \($0): \(date)")
    } else {
        print("Failed to parse \($0)")
    }
}
