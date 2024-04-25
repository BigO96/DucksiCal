//
//  DucksGamesView.swift
//  DucksiCalTest
//
//  Created by Oscar Epp on 4/24/24.
//

import SwiftUI

struct DucksGamesView: View {
    @State private var selectedTeam: DucksTeam = ducksteams[0]

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(ducksteams, id: \.name) { team in
                        Button(action: {
                            selectedTeam = team
                        }) {
                            VStack {
                                Image(systemName: team.symbolName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding()
                                    .background(selectedTeam == team ? Color.gray.opacity(0.4) : Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                                    .foregroundColor(Color.blue)
                                
                                Text(team.name)
                                    .font(.caption)
                                    .foregroundColor(Color.secondary)
                                

                            }
                            .padding(.vertical, 4)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)

            TeamScheduleView(viewModel: EventViewModel(teamName: selectedTeam.name))
        }
    }
}

#Preview {
    DucksGamesView()
}
