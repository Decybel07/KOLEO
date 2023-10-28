//
//  MainView.swift
//  KOLEO
//
//  Created by Adrian Bobrowski on 27/10/2023.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var viewModel: MainViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    self.stationsFormView()
                    
                    if let error = self.viewModel.error {
                        self.errorView(error: error)
                    } else if self.viewModel.processingCount > 0 {
                        self.loadingView()
                    } else {
                        self.distanceView()
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
            }
            .refreshable {
                self.viewModel.refresh()
            }
            .navigationTitle("title")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Components
private extension MainView {
    
    func errorView(error: Error) -> some View {
        ContentUnavailableView {
            Label("error.title", systemImage: "exclamationmark.triangle.fill")
        } description: {
            Text(error.localizedDescription)
        } actions: {
            Button {
                self.viewModel.refresh()
            } label: {
                Text("retry")
            }
        }
    }
    
    func loadingView() -> some View {
        ContentUnavailableView {
            ProgressView {
                Text("loading.title")
            }
        }
    }
    
    func distanceView() -> some View {
        VStack(spacing: 10) {
            Text("distance")
                .font(.title)
            
            if let distance = self.viewModel.distance {
                Text(distance.formatted(.measurement(width: .abbreviated, usage: .road)) )
                    .foregroundStyle(.primary)
                    .font(.largeTitle)
            } else {
                Text("selectBothStations")
                    .foregroundStyle(.secondary)
                    .font(.body)
            }
        }
        .padding()
    }
    
    func stationsFormView() -> some View {
        Form {
            GroupBox("connection") {
                LabeledContent("source.label") {
                    self.stationPickerView("source.title", selected: self.$viewModel.source)
                }
                LabeledContent("destination.label") {
                    self.stationPickerView("destination.title", selected: self.$viewModel.destination)
                }
            }
        }
        .buttonStyle(.bordered)
        .formStyle(.columns)
    }
    
    func stationPickerView(_ title: LocalizedStringKey, selected: Binding<Station?>) -> some View {
        NavigationLink {
            StationPickerView(
                viewModel: .init(
                    stations: self.viewModel.stations,
                    keywords: self.viewModel.keywords
                ),
                selected: selected
            )
            .navigationTitle(title)
        } label: {
            Group {
                if let selected = selected.wrappedValue {
                    Text(selected.name )
                        .foregroundStyle(.secondary)
                } else {
                    Text(title)
                        .foregroundStyle(.tertiary)
                }
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundStyle(.primary)
        .disabled(self.viewModel.processingCount > 0 || self.viewModel.stations.isEmpty)
        .redacted(reason: self.viewModel.processingCount > 0 ? .placeholder : [])
    }
}

#Preview {
    MainView()
        .environmentObject(MainViewModel(
            stationRepositoryService: StubStationRepositoryService(
                stations: [],
                keywords: []
            )
        ))
}
