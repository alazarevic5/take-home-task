//
//  SportsViewModel.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import Foundation
import Combine

class SportsViewModel: ObservableObject {

    @Published var filteredMatches: [Match] = []
    @Published var availableSports: [Sport] = []
    @Published var selectedSportId: Int? = nil

    @Published var selectedTimeTab: TimeFilter = .today

    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var errorMessage: String = ""

    internal let repository: SportsRepository
    internal var cancellables = Set<AnyCancellable>()

    init(repository: SportsRepository = SportsRepository()) {
        self.repository = repository
        setupSubscriptions()
        loadInitialData()
    }

    private func setupSubscriptions() {
        repository.$sports
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sports in
                print("received - sports count: \(sports.count)")
                self?.availableSports = sports

                if self?.selectedSportId == nil && !sports.isEmpty {
                    self?.selectedSportId = sports.first?.id
                }
            }
            .store(in: &cancellables)

        Publishers.CombineLatest3(repository.$matches, $selectedSportId, $selectedTimeTab)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] (matches, sportId, timeTab) in
            self?.updateFilteredMatches(matches: matches, sportId: sportId, timeTab: timeTab)
        }
        .store(in: &cancellables)

        Publishers.CombineLatest3(repository.$isLoadingSports, repository.$isLoadingCompetitions, repository.$isLoadingMatches)
        .map { $0 || $1 || $2 }
        .receive(on: DispatchQueue.main)
        .assign(to: \.isLoading, on: self)
        .store(in: &cancellables)

        Publishers.CombineLatest3(repository.$sportsError, repository.$competitionsError, repository.$matchesError)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] (sportsError, competitionsError, matchesError) in
            let errors = [sportsError, competitionsError, matchesError].compactMap { $0 }
            if let firstError = errors.first {
                self?.hasError = true
                self?.errorMessage = firstError.localizedDescription
            } else {
                self?.hasError = false
                self?.errorMessage = ""
            }
        }
        .store(in: &cancellables)
    }

    private func loadInitialData() {
        print("ViewModel - loading initial data...")
        repository.loadAllData()
    }


    
}
