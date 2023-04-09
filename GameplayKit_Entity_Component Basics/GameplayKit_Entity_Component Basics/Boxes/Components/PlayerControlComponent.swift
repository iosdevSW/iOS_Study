//
//  PlayerControlComponent.swift
//  GameplayKit_Entity_Component Basics
//
//  Created by 신상우 on 2023/04/09.
//

import GameplayKit
import SceneKit

class PlayerControlComponent: GKComponent {
    // MARK: Properties
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }

    // MARK: Methods
    // 객체에 y축으로 2만큼 임펄스를 전달해 점프동작을 만드는 함수
    func jump() {
        let jumpVector = SCNVector3(x: 0, y: 2, z: 0)
        geometryComponent?.applyImpulse(jumpVector)
    }
}
