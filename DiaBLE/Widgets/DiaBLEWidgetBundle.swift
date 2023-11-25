//
//  DiaBLEWidgetBundle.swift
//  DiaBLEWidget
//
//  Created by Guido Soranzio on 25/11/23.
//

import WidgetKit
import SwiftUI

@main
struct DiaBLEWidgetBundle: WidgetBundle {
    var body: some Widget {
        DiaBLEWidget()
        DiaBLEWidgetLiveActivity()
    }
}
