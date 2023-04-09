//
//  Game.swift
//  GameplayKit_Entity_Component Basics
//
//  Created by 신상우 on 2023/04/08.
//

import SceneKit
import GameplayKit

class Game: NSObject, SCNSceneRendererDelegate {
    // MARK: Properties
    
    /// Scene이에요~!
    let scene = SCNScene(named: "GameScene.scn")!
    
    /// 모든 player control components를 관리합니다. 이 컴포넌트시스템을 통해 모든 컴포넌트에 접근할 수 있어요.
    let playerControlComponentSystem = GKComponentSystem(componentClass: PlayerControlComponent.self)
    
    /// 모든 particle components를 관리합니다. 이 컴포넌트시스템을 통해 모든 컴포넌트에 접근할 수 있어요.
    let particleComponentSystem = GKComponentSystem(componentClass: ParticleComponent.self)
    
    /// box 엔티티를 담을 배열이에요.
    var boxEntities = [GKEntity]()
    
    /// 컴포넌트들 업데이트 해줘야한다했죠! 업데이트 시간을 추적하는 변수입니다.
    var previousUpdateTime: TimeInterval = 0
    
    // MARK: Initialization
    override init() {
        super.init()
        
        setUpEntities() // Scene에 엔티티 셋팅
        addComponentsToComponentSystems() ///ComponentSystem에서 모든 component들을 관리할 수 있게 추가해주는 함수
    }
    
    /// Scene에 엔티티를 설정합니다. 4개는 팩토리 메소드를 만들어 생성해보구요. 보라색박스 하나는 직접 해볼게요.
    func setUpEntities() {
        // 네개 색상의 박스를 만들건데 makeBoxEntity 팩토리메소드 구현을 어떻게 하는지 먼저 보러 내려갔다옵시다!
        let redBoxEntity = makeBoxEntity(forNodeWithName: "redBox", wantsPlayerControlComponent: true, withParticleComponentNamed: "Sparkle")
        
        let yellowBoxEntity = makeBoxEntity(forNodeWithName: "yellowBox", wantsPlayerControlComponent: true, withParticleComponentNamed: "Fire")
        
        let greenBoxEntity = makeBoxEntity(forNodeWithName: "greenBox", wantsPlayerControlComponent: true)
        
        let blueBoxEntity = makeBoxEntity(forNodeWithName: "blueBox", wantsPlayerControlComponent: true, withParticleComponentNamed: "Sparkle")

        // 이 보라색 박스는 튜토리얼에서 직접 만들어보라는 Todo를 줬네요.
        let purpleBoxEntity = GKEntity()
        let purpleBoxNode = scene.rootNode.childNode(withName: "purpleBox", recursively: false)
        
        // Create the purple box's geometry component, and add it to the entity.
        let geometryComponent = GeometryComponent(geometryNode: purpleBoxNode!)
        purpleBoxEntity.addComponent(geometryComponent)
        
        /*
         이 아래 부분에 보라색 박스 엔티티에 particle효과를 붙이거나 사용자가 컨트롤할지 여부를 코드로 작성해보라고 하네요.
        */
        
        let playerControlComponent = PlayerControlComponent()
        purpleBoxEntity.addComponent(playerControlComponent)
        
        boxEntities = [
            redBoxEntity,
            yellowBoxEntity,
            greenBoxEntity,
            blueBoxEntity,
            purpleBoxEntity
        ]
    }
    
    /// Per-component 방식으로 업데이트 메소드를 전송하는거 위에서 배웠죠! ComponentSystem을 이용해 특정 컴포넌트를 다 같이 관리하는것! 그걸 위해서 system에 컴포넌트들을 추가해주는 작업입니다.
    func addComponentsToComponentSystems() {
        for box in boxEntities {
            particleComponentSystem.addComponent(foundIn: box)
            playerControlComponentSystem.addComponent(foundIn: box)
        }
    }
    
    // MARK: Methods
    func jumpBoxes() {
        //컨트롤 여부 true로 설정해둔 엔티티들의 점프를 발생시킵니다.
        for case let component as PlayerControlComponent in playerControlComponentSystem.components {
            component.jump()
        }
    }
    
    /// 모든 프레임을 업데이트하는 델리게이트 메소드
    func renderer(_: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // 이전 업데이트 후 흐른 시간
        let timeSincePreviousUpdate = time - previousUpdateTime
        
        // particle component system을 업데이트시킴
        particleComponentSystem.update(deltaTime: timeSincePreviousUpdate)
        
        // 이전 업데이트 시간을 업데이트해 이후 계산을 정확히 유지시킴
        previousUpdateTime = time
    }
    
    // MARK: Box Factory Method
    func makeBoxEntity(forNodeWithName name: String, wantsPlayerControlComponent: Bool = false, withParticleComponentNamed particleComponentName: String? = nil) -> GKEntity {
        // 일단 엔티티를 생성해줍니다.
        let box = GKEntity()
        
        // 위에서 GameScene.snc 가져왔었죠? 거기 존재하는 identity name과 일치해야합니다 거기서 노드를 가져와서 엔티티로 만드는거같아요!
        guard let boxNode = scene.rootNode.childNode(withName: name, recursively: false) else {
            fatalError("Making box with name \(name) failed because the GameScene scene file contains no nodes with that name.")
        }
        
        // 아까 component에서 component재사용하는 방법이였죠? 서브클래싱하고 addComponent를 통해 엔티티에 추가해주라고한 부분 이렇게 사용하는 겁니다! 이로써 박스 엔티티가 이동할 수 있게 되겠어요!
        let geometryComponent = GeometryComponent(geometryNode: boxNode)
        box.addComponent(geometryComponent)
        
        // particle이 존재하면 엔티티에 추가해주구요!
        if let particleComponentName = particleComponentName {
            let particleComponent = ParticleComponent(particleName: particleComponentName)
            box.addComponent(particleComponent)
        }
        
        // 사용자가컨트롤하기 원하면 추가해줍니다.
        if wantsPlayerControlComponent {
            let playerControlComponent = PlayerControlComponent()
            box.addComponent(playerControlComponent)
        }
        
        return box
    }
}
