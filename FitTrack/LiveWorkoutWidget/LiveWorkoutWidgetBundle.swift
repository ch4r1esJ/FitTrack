//
//  LiveWorkoutWidgetBundle.swift
//  LiveWorkoutWidget
//
//  Created by Charles Janjgava on 1/17/26.
//

import WidgetKit
import SwiftUI

@main
struct LiveWorkoutWidgetBundle: WidgetBundle {
    var body: some Widget {
        LiveWorkoutWidget()
        LiveWorkoutWidgetControl()
        LiveWorkoutWidgetLiveActivity()
    }
}
