//
//  RoadmapView.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import SwiftUI

public struct RoadmapView<Header: View, Footer: View>: View {
    @StateObject var viewModel: RoadmapViewModel
    let header: Header
    let footer: Footer
    @State private var selectedFilter: String
    
    public var body: some View {
            featuresList
                .scrollContentHidden()
                .listStyle(.plain)
                .conditionalSearchable(if: viewModel.allowSearching, text: $viewModel.searchText)
    }
    
    var featuresList: some View {
        VStack {
            HStack(spacing: 8) {
                Text("Filter:")
                Picker("", selection: $selectedFilter) {
                    ForEach(viewModel.statuses, id: \.self) {
                        Text($0.localizedCapitalized)
                    }
                }
                .tint(.black)
                .pickerStyle(.menu)
                .onChange(of: selectedFilter, perform: { newValue in
                    viewModel.filterFeatures(by: newValue)
                })
                Spacer()
            }
            .padding(.horizontal, 22)
            
            List {
                header
                ForEach(viewModel.filteredFeatures) { feature in
                    RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                        .macOSListRowSeparatorHidden()
                        .listRowBackground(Color.clear)
                }
                footer
            }
        }
    }
}

public extension RoadmapView where Header == EmptyView, Footer == EmptyView {
    init(configuration: RoadmapConfiguration) {
        self.init(viewModel: .init(configuration: configuration), header: EmptyView(), footer: EmptyView(), selectedFilter: "")
    }
}

public extension RoadmapView where Header: View, Footer == EmptyView {
    init(configuration: RoadmapConfiguration, @ViewBuilder header: () -> Header) {
        self.init(viewModel: .init(configuration: configuration), header: header(), footer: EmptyView(), selectedFilter: "")
    }
}

public extension RoadmapView where Header == EmptyView, Footer: View {
    init(configuration: RoadmapConfiguration, @ViewBuilder footer: () -> Footer) {
        self.init(viewModel: .init(configuration: configuration), header: EmptyView(), footer: footer(), selectedFilter: "")
    }
}

public extension RoadmapView where Header: View, Footer: View {
    init(configuration: RoadmapConfiguration, @ViewBuilder header: () -> Header, @ViewBuilder footer: () -> Footer) {
        self.init(viewModel: .init(configuration: configuration), header: header(), footer: footer(), selectedFilter: "")
    }
}

struct RoadmapView_Previews: PreviewProvider {
    static var previews: some View {
        RoadmapView(configuration: .sample())
    }
}
