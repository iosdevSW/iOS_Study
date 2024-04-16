//
//  GalleryScrollTargetBehavior.swift
//  BeyondScrollView
//
//  Created by iOS신상우 on 4/16/24.
//

import SwiftUI

struct GalleryScrollTargetBehavior: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < (context.containerSize.height / 3.0),
           context.velocity.dy < 0.0 {
            target.rect.origin.y = 0.0
        }
    }
}
