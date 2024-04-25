//
//  GetCal.swift
//  DucksiCalTest
//
//  Created by Oscar Epp on 4/24/24.
//

import Foundation

class EventViewModel: ObservableObject {
    @Published var events: [SportsEvent] = []
    private var teamName: String
    private let teamURLs: [String: String] = [
        "Football": "https://admin.goducks.com/calendar.ashx/calendar.ics?sport_id=3&schedule_id=2466",
        "Baseball": "https://admin.goducks.com/calendar.ashx/calendar.ics?sport_id=1&schedule_id=2464",
        "Basketball": "https://admin.goducks.com/calendar.ashx/calendar.ics?sport_id=6&schedule_id=2461",
        "TrackandField": "https://admin.goducks.com/calendar.ashx/calendar.ics?sport_id=11&schedule_id=2467",
        "Other": "https://admin.goducks.com/calendar.ashx/calendar.ics?sport_id=11&schedule_id=2467"
    ]
    
    init(teamName: String) {
        self.teamName = teamName
        guard let urlString = teamURLs[teamName] else {
            print("URL not found for team: \(teamName)")
            return
        }
        loadEvents(from: urlString)
    }

    func loadEvents(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Unexpected status code: \((response as? HTTPURLResponse)?.statusCode ?? 999)")
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.events = self.parseICalendarData(String(data: data, encoding: .utf8) ?? "")
                    self.events.sort(by: { $0.start < $1.start })
                }
            }
        }
        task.resume()
    }

    private func parseICalendarData(_ data: String) -> [SportsEvent] {
        var events = [SportsEvent]()
        var currentEvent: [String: String] = [:]

        data.components(separatedBy: "\n").forEach { line in
            switch line {
            case let line where line.starts(with: "BEGIN:VEVENT"):
                currentEvent.removeAll()
            case let line where line.starts(with: "END:VEVENT"):
                if let event = createSportsEvent(from: currentEvent) {
                    events.append(event)
                }
            default:
                let components = line.components(separatedBy: ":")
                if components.count > 1 {
                    let key = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    let value = components.dropFirst().joined(separator: ":").trimmingCharacters(in: .whitespacesAndNewlines)
                    currentEvent[key] = value
                }
            }
        }
        return events
    }

    private func createSportsEvent(from dictionary: [String: String]) -> SportsEvent? {
        guard let uid = dictionary["UID"],
              let summary = dictionary["SUMMARY"],
              let description = dictionary["DESCRIPTION"],
              let location = dictionary["LOCATION"],
              let dtStart = dictionary["DTSTART"],
              let dtEnd = dictionary["DTEND"],
              let startDate = DateFormatter.icalDateFormatter.date(from: dtStart),
              let endDate = DateFormatter.icalDateFormatter.date(from: dtEnd) else {
            return nil
        }
        
        return SportsEvent(id: uid, summary: summary, start: startDate, end: endDate,
                           description: description, location: location)
    }
}

extension DateFormatter {
    static let icalDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}

struct SportsEvent: Identifiable {
    var id: String
    var summary: String
    var start: Date
    var end: Date
    var description: String
    var location: String
}
