import Foundation
import Combine

enum Feature2ServiceError: Error, LocalizedError {
    case decodingFailed(Error)
    case encodingFailed(Error)
    case invalidIndex(Int)
    case storageFailure(Error)
    
    var errorDescription: String? {
        switch self {
        case .decodingFailed(let error):
            return "Failed to decode info: \(error.localizedDescription)"
        case .encodingFailed(let error):
            return "Failed to encode info: \(error.localizedDescription)"
        case .invalidIndex(let index):
            return "Invalid index for deletion: \(index)"
        case .storageFailure(let error):
            return "Storage operation failed: \(error.localizedDescription)"
        }
    }
}

protocol Feature2Repository {
    var recordsPublisher: AnyPublisher<Result<[PlayerInfo], Feature2ServiceError>, Never> { get }
    func loadRecords() throws -> [PlayerInfo]
    func saveRecord(_ info: [PlayerInfo]) throws
}

final class KeyValueRecordsRepository2: Feature2Repository {
    private let storage: DefaultsStorage
    
    private let recordSubject = PassthroughSubject<Result<[PlayerInfo], Feature2ServiceError>, Never>()
    
    var recordsPublisher: AnyPublisher<Result<[PlayerInfo], Feature2ServiceError>, Never> {
        recordSubject.eraseToAnyPublisher()
    }
    
    init(storage: DefaultsStorage = DefaultsStorage()) {
        self.storage = storage
    }
    
    func loadRecords() throws -> [PlayerInfo] {
        guard let data = storage.data(forKey: .playerData) else {
            return []
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            return try decoder.decode([PlayerInfo].self, from: data)
        } catch {
            throw Feature2ServiceError.decodingFailed(error)
        }
    }
    
    func saveRecord(_ info: [PlayerInfo]) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let data = try encoder.encode(info)
            storage.set(data, forKey: .playerData)
            recordSubject.send(.success(info))
        } catch {
            throw Feature2ServiceError.encodingFailed(error)
        }
    }
}

actor Feature2Service {
    nonisolated var recordsPublisher: AnyPublisher<Result<[PlayerInfo], Feature2ServiceError>, Never> { recordsSubject.eraseToAnyPublisher() }
    
    private var records: [PlayerInfo] = []
    private var cancellables = Set<AnyCancellable>()
    private let repository: Feature2Repository
    private let recordsSubject = CurrentValueSubject<Result<[PlayerInfo], Feature2ServiceError>, Never>(.success([]))
    
    init(repository: Feature2Repository = KeyValueRecordsRepository2()) {
        self.repository = repository
        Task { await setupRepositorySubscription() }
        Task { await loadRecords() }
    }
    
    private func setupRepositorySubscription() {
        repository.recordsPublisher
            .sink { [weak self] info in
                Task { [weak self] in
                    await self?.updateRecordsSubject(info)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateRecordsSubject(_ result: Result<[PlayerInfo], Feature2ServiceError>) {
        recordsSubject.send(result)
        if case .success(let records) = result {
            self.records = records
        }
    }
    
    private func loadRecords() {
        do {
            let loadedInfo = try repository.loadRecords()
            self.records = loadedInfo
            recordsSubject.send(.success(records))
        } catch {
            recordsSubject.send(.failure(Feature2ServiceError.storageFailure(error)))
        }
    }
    
    func getRecords() async -> [PlayerInfo] {
        records
    }

    func saveRecord(_ result: PlayerInfo) async {
        do {
            var latest = try repository.loadRecords()
            if let index = latest.firstIndex(where: { $0.id == result.id }) {
                latest[index] = result
            } else {
                latest.append(result)
            }
            try repository.saveRecord(latest)
            self.records = latest
            recordsSubject.send(.success(latest))
        } catch {
            recordsSubject.send(.failure(Feature2ServiceError.storageFailure(error)))
        }
    }

    func deleteRecord(id: String) async {
        do {
            var latest = try repository.loadRecords()
            latest.removeAll { $0.id == id }
            try repository.saveRecord(latest)
            self.records = latest
            recordsSubject.send(.success(latest))
        } catch {
            recordsSubject.send(.failure(Feature2ServiceError.storageFailure(error)))
        }
    }
}





