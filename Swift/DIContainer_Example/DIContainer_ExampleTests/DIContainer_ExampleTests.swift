//
//  DIContainer_ExampleTests.swift
//  DIContainer_ExampleTests
//
//  Created by iOS신상우 on 10/23/24.
//

import Testing
@testable import DIContainer_Example

struct DIContainer_ExampleTests {
    private let dependecy: DependencyBox
    
    // Before each test
    init() async throws {
        self.dependecy = DependencyBox()
    }
    
    func address<T: AnyObject>(of instance: T) -> String {
        return Unmanaged.passUnretained(instance).toOpaque().debugDescription
    }

    @Test
    func 부모타입으로_컨테이너_등록_성공() async throws {
        // given
        let sangwoo = User(name: "상우", age: 12)
        
        // when
        dependecy.register(Userable.self) {
            sangwoo
        }
        
        var user: Userable {
            dependecy.resolve()
        }
        
        // then
        #expect(user.age == sangwoo.age)
        #expect(user.name == sangwoo.name)
    }
    
    
    // 같은 타입으로 2개 등록하면 마지막에 등록한 객체가 나옴
    @Test
    func 부모타입으로_컨테이너_자식구현체2개_등록() async throws {
        // given
        let sangwoo = User(name: "상우", age: 12)
        let dongwoo = User(name: "동우", age: 4)
        
        // when
        dependecy.register(Userable.self) {
            sangwoo
        }
        
        dependecy.register(Userable.self) {
            dongwoo
        }
        
        var user: Userable {
            dependecy.resolve()
        }
        
        // then
        #expect(user.age != sangwoo.age)
        #expect(user.name != sangwoo.name)
        #expect(user.age == dongwoo.age)
        #expect(user.name == dongwoo.name)
    }
    
    // 같은 타입으로 2개 이상 등록하려면 태그를 사용해야함
    @Test
    func 부모타입으로_자식구현체2개_등록_태그사용() async throws {
        // given
        let sangwoo = User(name: "상우", age: 12)
        let dongwoo = User(name: "동우", age: 4)
        
        // when
        
        // Userable타입의 tag는 live
        dependecy.register(Userable.self, name: DependencyTag.live.rawValue) {
            sangwoo
        }
        
        // Userable타입의 tag는 test
        dependecy.register(Userable.self, name: DependencyTag.test.rawValue) {
            dongwoo
        }
        
        var nonTagUser: Userable {
            dependecy.resolve(name: DependencyTag.live.rawValue)
        }
        
        var liveTagUser: Userable {
            dependecy.resolve(name: DependencyTag.live.rawValue)
        }
        
        var testTagUser: Userable {
            dependecy.resolve(name: DependencyTag.test.rawValue)
        }
        
        // then
        #expect(liveTagUser.name == sangwoo.name)
        #expect(liveTagUser.age == sangwoo.age)
        
        #expect(testTagUser.name == dongwoo.name)
        #expect(testTagUser.age == dongwoo.age)
    }
    
    // 싱글톤이면 resolve 할 때마다 같은 인스턴스가 나와야함
    @Test
    func 싱글톤_스코프_사용시_resolve마다_동일한_인스턴스인가() async throws {
        // given
        
        // Userable타입의 tag는 live
        dependecy.register(Admin.self, scope: .singleton) {
            Admin(name: "상우", age: 12)
        }
        
        // when
        
        var user1: Admin {
            dependecy.resolve()
        }
        
        var user2: Admin {
            dependecy.resolve()
        }
        
        // then
        #expect(user1 === user2)
    }
    
    // transient이면 resolve 할 때마다 같은 인스턴스가 나와야함
    @Test
    func transient_스코프_사용시_resolve마다_동일한_인스턴스인가() async throws {
        // given
        
        // when
        
        dependecy.register(Admin.self, scope: .transient) {
            Admin(name: "상우", age: 12)
        }
        
        var user1: Admin {
            dependecy.resolve()
        }
        
        var user2: Admin {
            dependecy.resolve()
        }
        
        // then
        #expect(user1 !== user2)
    }
    
//    // transient이면 resolve 할 때마다 같은 인스턴스가 나와야함
//    @Test
//    func 구조체타입은_스코프영향없이_늘_새로운_인스턴스() async throws {
//        // given
//        
//        dependecy.register(User.self, scope: .transient) {
//            User(name: "상우", age: 12)
//        }
//        
//        // when
//        var user1: User {
//            dependecy.resolve()
//        }
//        
//        var user2: User {
//            dependecy.resolve()
//        }
//        
//        // then
//        #expect(user1 == user2)
//    }
}
