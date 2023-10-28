//
//  StationPickerView.swift
//  KOLEO
//
//  Created by Adrian Bobrowski on 27/10/2023.
//

import SwiftUI

struct StationPickerView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: StationPickerViewModel
    
    @Binding var selected: Station?
    
    var body: some View {
        Group {
            if self.viewModel.searchResults.isEmpty {
                ContentUnavailableView.search
            } else {
                List {
                    ForEach(self.viewModel.searchResults) { station in
                        Button {
                            self.dismiss()
                            self.selected = station
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(station.name)
                                    .font(.headline)
                                
                                Text([station.city, station.region, station.country]
                                    .compactMap { $0 }
                                    .filter { !$0.isEmpty }
                                    .formatted(.list(type: .and, width: .narrow))
                                )
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                        }
                    }
                }
                .buttonStyle(.plain)
                .listStyle(.plain)
            }
        }
        .searchable(text: self.$viewModel.filter, placement: .navigationBarDrawer(displayMode: .always))
    }
}

#Preview {
    NavigationStack {
        StationPickerView(viewModel: .init(
            stations: [.init(
                id: 30601,
                name: "Poznań Główny",
                location: .init(latitude: 52.39444864, longitude: 16.90972358),
                hits: 4627,
                city: "Poznań",
                region: "wielkopolskie",
                country: "Polska"
            )],
            keywords: []
        ), selected: .constant(nil))
        .navigationTitle("Select")
    }
}

#Preview("No results") {
    NavigationStack {
        StationPickerView(viewModel: .init(
            stations: [],
            keywords: []
        ), selected: .constant(nil))
    }
}
