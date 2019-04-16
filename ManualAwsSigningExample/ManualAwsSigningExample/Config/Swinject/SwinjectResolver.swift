//
//  SwinjectResolver.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 16/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Swinject
import Direkt

class SwinjectResolver: Direkt.Resolver {

    struct ResolvingFailedError: Swift.Error {}
    var container: Container!
    private var assemblies: [Assembly] = []
    private(set) var assembler: Assembler!

    init(container: Container) {
        self.container = container
        self.assemblies =  [
            ControllerAssembly(),
            ServiceAssembly(),
            NetworkAssembly()
        ]
        self.assembler = Assembler(self.assemblies)
    }

    init(assembler: Assembler) {
        self.assembler = assembler
    }

    func assemble() {
        _ = self.assemblies.map {
            $0.assemble(container: self.container)
        }
    }

    func resolve<T, E>(_ type: T.Type, input: E? = nil) throws -> T {
        let maybeResolved: T?
        if let input = input {
            maybeResolved = assembler.resolver.resolve(type, argument: input)
        } else {
            maybeResolved = assembler.resolver.resolve(type)
        }

        guard let resolved = maybeResolved else {
            throw ResolvingFailedError()
        }

        return resolved
    }
}

