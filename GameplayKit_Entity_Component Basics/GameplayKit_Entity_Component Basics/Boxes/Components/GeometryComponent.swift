//
//  GeometryComponent.swift
//  GameplayKit_Entity_Component Basics
//
//  Created by 신상우 on 2023/04/08.
//

import SceneKit
import GameplayKit

class GeometryComponent: GKComponent {
    // MARK: Properties
    
    // 중력 노드
    let geometryNode: SCNNode
    
    // MARK: Init
    init(geometryNode: SCNNode) {
        self.geometryNode = geometryNode
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    /// 상자 노드에 상향 임펄스를 적용해서 점프를 발생시키는 함수입니다.
    func applyImpulse(_ vector: SCNVector3) {
        print(geometryNode.physicsBody)
        geometryNode.physicsBody?.applyForce(vector, asImpulse: true)
    }
}
