//
//  DiscoveryRepository.swift
//  Scout
//
//  Created by Codex on 7/14/26.
//

import Foundation

protocol DiscoveryRepository {
    func loadQueue() async -> DiscoveryQueue
    func refreshQueue(existing queue: DiscoveryQueue) async -> DiscoveryQueue
    func retryQueue(after failure: DiscoveryQueueFailure?) async -> DiscoveryQueue
}
