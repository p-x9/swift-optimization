//
//  SwiftOptimizationMacroPlugin.swift
//
//
//  Created by p-x9 on 2023/11/03.
//  
//

#if canImport(SwiftCompilerPlugin)
import SwiftSyntaxMacros
import SwiftCompilerPlugin

@main
struct SwiftOptimizationMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SwiftOptimizationMacro.self
    ]
}
#endif
