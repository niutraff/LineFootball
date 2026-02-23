import Foundation
import Combine
import UIKit

private let homePhotoFilename = "home_profile.jpg"
private let defaultSeasonGoalTarget = 20

@MainActor
final class Feature1VM: ObservableObject {
    
    struct Output {
        let onDetail: () -> Void
    }
    
    struct RecordsInfo {
        var scores: Int
        var games: Int
        var assets: Int
        var saves: Int
        var seasonGoalTarget: Int
    }
    
    @Published
    var allResult: RecordsInfo = .init(scores: 0, games: 0, assets: 0, saves: 0, seasonGoalTarget: defaultSeasonGoalTarget)
    
    private let storage: DefaultsStorage
    
    @Published
    var homePhoto: UIImage?
    
    @Published
    var records: [ComandInfo] = []
    
    var output: Output?
    
    private let service: Feature1Service
    private var cancellables = Set<AnyCancellable>()
    
    init(service: Feature1Service, storage: DefaultsStorage = .shared) {
        self.service = service
        self.storage = storage
        subscribeToRecords()
        loadHomePhoto()
        loadSeasonGoalTarget()
    }
    
    func loadHomePhoto() {
        homePhoto = PlayerPhotoStorage.loadImage(filename: homePhotoFilename)
    }
    
    func setHomePhoto(_ image: UIImage?) {
        homePhoto = image
        if let image = image {
            _ = PlayerPhotoStorage.saveImage(image, filename: homePhotoFilename)
        }
    }
    
    func incrementSeasonTarget() {
        let newValue = min(allResult.seasonGoalTarget + 1, 999)
        allResult.seasonGoalTarget = newValue
        saveSeasonGoalTarget(newValue)
    }
    
    func decrementSeasonTarget() {
        let newValue = max(allResult.seasonGoalTarget - 1, 1)
        allResult.seasonGoalTarget = newValue
        saveSeasonGoalTarget(newValue)
    }
    
    func onDetailTapped() {
        output?.onDetail()
    }
    
    private func loadSeasonGoalTarget() {
        let savedInt: Int? = storage.value(forKey: .seasonGoalTarget)
        let savedNum: NSNumber? = storage.value(forKey: .seasonGoalTarget)
        let value = savedInt ?? savedNum?.intValue
        if let v = value, v >= 1, v <= 999 {
            allResult.seasonGoalTarget = v
        }
    }
    
    private func saveSeasonGoalTarget(_ value: Int) {
        storage.set(value, forKey: .seasonGoalTarget)
    }
    
    private func subscribeToRecords() {
        service.recordsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let info):
                    self?.records = info
                    self?.updateAllResult(from: info)
                case .failure(let error):
                    print(error.errorDescription ?? "Unknown error")
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateAllResult(from records: [ComandInfo]) {
        let scores = records.reduce(0) { sum, m in
            sum + (m.weWereHomeTeam ? m.goalUs : m.goalThem)
        }
        let games = records.count
        let assets = records.reduce(0) { $0 + $1.assits }
        let saves = records.reduce(0) { $0 + $1.saves }
        let currentTarget = allResult.seasonGoalTarget
        allResult = .init(scores: scores, games: games, assets: assets, saves: saves, seasonGoalTarget: currentTarget)
    }
}
