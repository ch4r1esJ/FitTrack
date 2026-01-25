//
//  HKWorkoutActivityType + Data.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/21/26.
//

import HealthKit
import SwiftUI

extension HKWorkoutActivityType {
    
    var name: String {
        switch self {
        case .americanFootball:             return "American Football"
        case .archery:                      return "Archery"
        case .australianFootball:           return "Australian Football"
        case .badminton:                    return "Badminton"
        case .baseball:                     return "Baseball"
        case .basketball:                   return "Basketball"
        case .bowling:                      return "Bowling"
        case .boxing:                       return "Boxing"
        case .climbing:                     return "Climbing"
        case .crossTraining:                return "Cross Training"
        case .curling:                      return "Curling"
        case .cycling:                      return "Cycling"
        case .dance:                        return "Dance"
        case .danceInspiredTraining:        return "Dance Inspired Training"
        case .elliptical:                   return "Elliptical"
        case .equestrianSports:             return "Equestrian Sports"
        case .fencing:                      return "Fencing"
        case .fishing:                      return "Fishing"
        case .functionalStrengthTraining:   return "Functional Strength Training"
        case .golf:                         return "Golf"
        case .gymnastics:                   return "Gymnastics"
        case .handball:                     return "Handball"
        case .hiking:                       return "Hiking"
        case .hockey:                       return "Hockey"
        case .hunting:                      return "Hunting"
        case .lacrosse:                     return "Lacrosse"
        case .martialArts:                  return "Martial Arts"
        case .mindAndBody:                  return "Mind and Body"
        case .mixedMetabolicCardioTraining: return "Mixed Metabolic Cardio Training"
        case .paddleSports:                 return "Paddle Sports"
        case .play:                         return "Play"
        case .preparationAndRecovery:       return "Preparation and Recovery"
        case .racquetball:                  return "Racquetball"
        case .rowing:                       return "Rowing"
        case .rugby:                        return "Rugby"
        case .running:                      return "Running"
        case .sailing:                      return "Sailing"
        case .skatingSports:                return "Skating Sports"
        case .snowSports:                   return "Snow Sports"
        case .soccer:                       return "Soccer"
        case .softball:                     return "Softball"
        case .squash:                       return "Squash"
        case .stairClimbing:                return "Stair Climbing"
        case .surfingSports:                return "Surfing Sports"
        case .swimming:                     return "Swimming"
        case .tableTennis:                  return "Table Tennis"
        case .tennis:                       return "Tennis"
        case .trackAndField:                return "Track and Field"
        case .traditionalStrengthTraining:  return "Traditional Strength Training"
        case .volleyball:                   return "Volleyball"
        case .walking:                      return "Walking"
        case .waterFitness:                 return "Water Fitness"
        case .waterPolo:                    return "Water Polo"
        case .waterSports:                  return "Water Sports"
        case .wrestling:                    return "Wrestling"
        case .yoga:                         return "Yoga"
            
        case .barre:                        return "Barre"
        case .coreTraining:                 return "Core Training"
        case .crossCountrySkiing:           return "Cross Country Skiing"
        case .downhillSkiing:               return "Downhill Skiing"
        case .flexibility:                  return "Flexibility"
        case .highIntensityIntervalTraining:    return "High Intensity Interval Training"
        case .jumpRope:                     return "Jump Rope"
        case .kickboxing:                   return "Kickboxing"
        case .pilates:                      return "Pilates"
        case .snowboarding:                 return "Snowboarding"
        case .stairs:                       return "Stairs"
        case .stepTraining:                 return "Step Training"
        case .wheelchairWalkPace:           return "Wheelchair Walk Pace"
        case .wheelchairRunPace:            return "Wheelchair Run Pace"
            
        case .taiChi:                       return "Tai Chi"
        case .mixedCardio:                  return "Mixed Cardio"
        case .handCycling:                  return "Hand Cycling"
            
        case .discSports:                   return "Disc Sports"
        case .fitnessGaming:                return "Fitness Gaming"
            
        default:                            return "Other"
        }
    }
    
    var image: String {
        switch self {
        case .americanFootball:             return "figure.american.football"
        case .archery:                      return "figure.archery"
        case .australianFootball:           return "figure.australian.football"
        case .badminton:                    return "figure.badminton"
        case .baseball:                     return "figure.baseball"
        case .basketball:                   return "figure.basketball"
        case .bowling:                      return "figure.bowling"
        case .boxing:                       return "figure.boxing"
        case .climbing:                     return "figure.climbing"
        case .crossTraining:                return "figure.cross.training"
        case .curling:                      return "figure.curling"
        case .cycling:                      return "figure.outdoor.cycle"
        case .dance:                        return "figure.dance"
        case .danceInspiredTraining:        return "figure.dance"
        case .elliptical:                   return "figure.elliptical"
        case .equestrianSports:             return "figure.equestrian.sports"
        case .fencing:                      return "figure.fencing"
        case .fishing:                      return "figure.fishing"
        case .functionalStrengthTraining:   return "figure.strengthtraining.functional"
        case .golf:                         return "figure.golf"
        case .gymnastics:                   return "figure.gymnastics"
        case .handball:                     return "figure.handball"
        case .hiking:                       return "figure.hiking"
        case .hockey:                       return "figure.hockey"
        case .hunting:                      return "figure.hunting"
        case .lacrosse:                     return "figure.lacrosse"
        case .martialArts:                  return "figure.martial.arts"
        case .mindAndBody:                  return "figure.mind.and.body"
        case .mixedMetabolicCardioTraining: return "figure.mixed.cardio"
        case .paddleSports:                 return "figure.rowing"
        case .play:                         return "figure.play"
        case .preparationAndRecovery:       return "figure.cooldown"
        case .racquetball:                  return "figure.racquetball"
        case .rowing:                       return "figure.rowing"
        case .rugby:                        return "figure.rugby"
        case .running:                      return "figure.run"
        case .sailing:                      return "figure.sailing"
        case .skatingSports:                return "figure.skating"
        case .snowSports:                   return "snowflake"
        case .soccer:                       return "figure.soccer"
        case .softball:                     return "figure.softball"
        case .squash:                       return "figure.squash"
        case .stairClimbing:                return "figure.stair.stepper"
        case .surfingSports:                return "figure.surfing"
        case .swimming:                     return "figure.pool.swim"
        case .tableTennis:                  return "figure.table.tennis"
        case .tennis:                       return "figure.tennis"
        case .trackAndField:                return "figure.track.and.field"
        case .traditionalStrengthTraining:  return "figure.strengthtraining.traditional"
        case .volleyball:                   return "figure.volleyball"
        case .walking:                      return "figure.walk"
        case .waterFitness:                 return "figure.water.fitness"
        case .waterPolo:                    return "figure.water.polo"
        case .waterSports:                  return "water.waves"
        case .wrestling:                    return "figure.wrestling"
        case .yoga:                         return "figure.yoga"
            
        case .barre:                        return "figure.barre"
        case .coreTraining:                 return "figure.core.training"
        case .crossCountrySkiing:           return "figure.skiing.crosscountry"
        case .downhillSkiing:               return "figure.skiing.downhill"
        case .flexibility:                  return "figure.flexibility"
        case .highIntensityIntervalTraining: return "figure.highintensity.intervaltraining"
        case .jumpRope:                     return "figure.jumprope"
        case .kickboxing:                   return "figure.kickboxing"
        case .pilates:                      return "figure.pilates"
        case .snowboarding:                 return "figure.snowboarding"
        case .stairs:                       return "figure.stairs"
        case .stepTraining:                 return "figure.step.training"
        case .wheelchairWalkPace:           return "figure.rolling"
        case .wheelchairRunPace:            return "figure.rolling"
            
        case .taiChi:                       return "figure.taichi"
        case .mixedCardio:                  return "figure.mixed.cardio"
        case .handCycling:                  return "figure.hand.cycling"
            
        case .discSports:                   return "figure.disc.sports"
        case .fitnessGaming:                return "gamecontroller"
            
        default:                            return "questionmark.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .swimming, .surfingSports, .waterFitness, .waterPolo, .waterSports,
                .sailing, .fishing, .paddleSports, .rowing:
            return .blue
            
        case .soccer, .golf, .americanFootball, .australianFootball, .rugby,
                .lacrosse, .hockey, .baseball, .softball, .cricket, .discSports,
                .archery, .hiking, .hunting, .equestrianSports:
            return .green
            
        case .running, .trackAndField, .basketball, .volleyball, .cycling,
                .handball, .mixedMetabolicCardioTraining, .highIntensityIntervalTraining,
                .jumpRope, .mixedCardio, .stairClimbing, .stairs, .stepTraining:
            return .orange
            
        case .traditionalStrengthTraining, .functionalStrengthTraining, .crossTraining,
                .boxing, .kickboxing, .martialArts, .wrestling, .fencing, .coreTraining:
            return .red
            
        case .tennis, .badminton, .squash, .racquetball, .tableTennis, .fitnessGaming,
                .bowling, .climbing:
            return .yellow
            
        case .yoga, .pilates, .taiChi, .mindAndBody, .flexibility, .barre,
                .dance, .danceInspiredTraining, .gymnastics:
            return .purple
            
        case .snowSports, .snowboarding, .crossCountrySkiing, .downhillSkiing,
                .skatingSports, .curling:
            return .teal
            
        case .walking, .elliptical, .wheelchairWalkPace, .wheelchairRunPace,
                .preparationAndRecovery, .play, .handCycling:
            return .gray
            
        default:
            return .gray
        }
    }
}
