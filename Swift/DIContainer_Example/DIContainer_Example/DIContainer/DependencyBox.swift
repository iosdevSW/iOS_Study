//
//  DependencyBox.swift
//  DIContainer_Example
//
//  Created by iOS신상우 on 10/23/24.
//

import Foundation

public class DependencyBox {
    
    // 의존성을 등록하기 위한 레지스트리 (타입 + 태그 조합을 키로 사용)
    private var registry = [String: () -> Any]()
    private var singletonInstances = [String: Any]()  // 싱글톤 인스턴스 저장
    
    public init() { }
    
    private func key<T>(for type: T.Type, name: String? = nil) -> String {
        if let name = name {
            return "\(String(describing: T.self))-\(name)"
        } else {
            return String(describing: T.self)
        }
    }
    
    // 의존성 등록 함수
    @discardableResult
    public func register<T>(
        _ type: T.Type,
        name: String? = nil,
        scope: ObjectScope = .singleton,
        factory: @escaping () -> T
    ) -> Self {
        let key = self.key(for: type, name: name)
        
        // 싱글톤 스코프일 경우, 팩토리 함수로 인스턴스를 미리 생성하여 저장
        if scope == .singleton {
            let instance = factory()
            singletonInstances[key] = instance
            registry[key] = { instance }  // 항상 동일한 인스턴스 반환
        } else {
            registry[key] = factory  // 매번 새로운 인스턴스를 반환할 팩토리 저장
        }
        return self
    }
    
    // 의존성 주입(Resolve) 함수
    public func resolve<T>(name: String? = nil) -> T {
        let key = self.key(for: T.self, name: name)
        guard let factory = registry[key] else {
            fatalError("No registered dependency found for \(key)")
        }
        guard let instance = factory() as? T else {
            fatalError("Dependency type mismatch for \(key)")
        }
        return instance
    }
}

public extension DependencyBox {
    static let live = DependencyBox()  // 싱글톤 인스턴스
}
