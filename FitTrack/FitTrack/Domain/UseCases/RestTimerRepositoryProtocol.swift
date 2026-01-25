//
//  RestTimerRepositoryProtocol.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/24/26.
//

import Foundation

protocol RestTimerRepositoryProtocol {
    func saveRestTimerState(_ state: RestTimerState) throws
    func loadRestTimerState() throws -> RestTimerState?
    func clearRestTimerState() throws
}
