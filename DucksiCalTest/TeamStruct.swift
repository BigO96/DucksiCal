//
//  TeamStruct.swift
//  DucksiCalTest
//
//  Created by Oscar Epp on 4/24/24.
//

import Foundation

struct DucksTeam: Equatable{
    let name: String
    let symbolName: String
}

let ducksteams = [
    DucksTeam(name: "Football", symbolName: "football.fill"),
    DucksTeam(name: "Baseball", symbolName: "baseball.fill"),
    DucksTeam(name: "Basketball", symbolName: "basketball.fill"),
    DucksTeam(name: "TrackandField", symbolName: "figure.run"),
    DucksTeam(name: "Other", symbolName: "questionmark")


]
