//
//  HKWorkoutActivityType + Extension.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import HealthKit
import SwiftUI

extension HKWorkoutActivityType {
    var colorName: String {
        switch self {
        case .swimming, .surfingSports, .waterFitness, .waterPolo, .waterSports,
                .sailing, .fishing, .paddleSports, .rowing:
            return "blue"
            
        case .soccer, .golf, .americanFootball, .australianFootball, .rugby,
                .lacrosse, .hockey, .baseball, .softball, .cricket, .discSports,
                .archery, .hiking, .hunting, .equestrianSports:
            return "green"
            
        case .running, .trackAndField, .basketball, .volleyball, .cycling,
                .handball, .mixedMetabolicCardioTraining, .highIntensityIntervalTraining,
                .jumpRope, .mixedCardio, .stairClimbing, .stairs, .stepTraining:
            return "orange"
            
        case .traditionalStrengthTraining, .functionalStrengthTraining, .crossTraining,
                .boxing, .kickboxing, .martialArts, .wrestling, .fencing, .coreTraining:
            return "red"
            
        case .tennis, .badminton, .squash, .racquetball, .tableTennis, .fitnessGaming,
                .bowling, .climbing:
            return "yellow"
            
        case .yoga, .pilates, .taiChi, .mindAndBody, .flexibility, .barre,
                .dance, .danceInspiredTraining, .gymnastics:
            return "purple"
            
        case .snowSports, .snowboarding, .crossCountrySkiing, .downhillSkiing,
                .skatingSports, .curling:
            return "teal"
            
        case .walking, .elliptical, .wheelchairWalkPace, .wheelchairRunPace,
                .preparationAndRecovery, .play, .handCycling:
            return "gray"
            
        default:
            return "gray"
        }
    }
}
