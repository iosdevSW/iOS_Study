//
//  ParticleComponent.swift
//  GameplayKit_Entity_Component Basics
//
//  Created by 신상우 on 2023/04/09.
//

import SpriteKit
import SceneKit
import GameplayKit

class ParticleComponent: GKComponent {
    // MARK: Propertie
    /// 엔티티의 모양,위치 등을 변경하는 컴포넌트
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    /// particle effec를 가지는지 bool 여부
    var boxHasParticleEffect = false
    
    /// particle effect를 생성하고 관리하는 객체
    let particleEmitter: SCNParticleSystem
    
    /// 객체 주변에 빛나게 해주는 객체
    let boxLight = SCNLight()

    /// 밝기 변경 연산 프로퍼티
    var lightBrightness: CGFloat = 1 {
        didSet {
            boxLight.color = SKColor(white: lightBrightness, alpha: 1)
        }
    }
    
    /// 난수를 발생시키는 객체입니다. 빛의 밝기를 랜덤하게 만드는데 사용합니다.
    let randomSource = GKRandomSource()
    
    /// 밝기가 목표 밝기보다 낮으면 증가된 밝기를 반환하고 그렇지 않으면 감소된 밝기를 반환합니다. 이 작업을 통해 자연스러운 반짝임을 나타낼 수 있습니다.
    var nextLightBrightness: CGFloat {
        let delta: CGFloat = lightBrightness < targetLightBrightness ? 0.025 : -0.025
        return lightBrightness + delta
    }
    
    /// 목표 밝기입니다.
    var targetLightBrightness: CGFloat = 0.5
    
    // MARK: Initialization
    init(particleName: String) {
        /// particle생성자
        particleEmitter = SCNParticleSystem(named: particleName, inDirectory: "/")!
        
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    override func update(deltaTime _: TimeInterval) {
        
        //상자 geometry 컴포넌트가 생성되었지만 아직 particle 효과나 조명 효과가 부착되지 않은경우 부착합니다.
        updateGeometryComponent()
        
        // 프레임마다 새로운 목표 밝기를 생성합니다.
        targetLightBrightness = nextTargetLightBrightness()
        
        // 프레임마다 조명 밝기를 업데이트하여 조명이 깜박거립니다.
        lightBrightness = nextLightBrightness
    }
    
    /// 상자 geometry 컴포넌트가 생성되었지만 아직 particle 효과나 조명 효과가 부착되지 않은경우 부착합니다.
    func updateGeometryComponent() {
        if let geometryComponent = geometryComponent, !boxHasParticleEffect {
            geometryComponent.geometryNode.addParticleSystem(particleEmitter)
            geometryComponent.geometryNode.light = boxLight
        }
        
        // 부착 여부 갱신
        boxHasParticleEffect = geometryComponent != nil
    }
    
    // MARK: Light Flickering Algorithm
    // 조명의 목표 밝기를 무작위로 조정합니다.
    func nextTargetLightBrightness() -> CGFloat {
        // 목표 밝기가 랜덤하게 증가하거나 감소합니다.
        let increaseLightTargetBrightness = randomSource.nextBool() // false true가 랜덤으로
        let delta: CGFloat = increaseLightTargetBrightness ? 0.2 : -0.2 // 증가 or 감소
        
        // 다음 목표값 조정
        let newTargetLightBrightness = targetLightBrightness + delta
        
        // 밝기가 아무리 작아져도 0 아무리 커져도 1로 제한
        let clampedLightBrightness = (newTargetLightBrightness...newTargetLightBrightness).clamped(to: (0...1)).lowerBound
        
        return clampedLightBrightness
    }
}

