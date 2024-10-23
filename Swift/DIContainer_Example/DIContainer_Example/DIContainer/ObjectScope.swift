//
//  ObjectScope.swift
//  DIContainer_Example
//
//  Created by iOS신상우 on 10/23/24.
//

import Foundation

public enum ObjectScope {
    case singleton   // 한 번 생성된 인스턴스를 재사용
    case transient   // 매번 새로운 인스턴스를 생성
}
