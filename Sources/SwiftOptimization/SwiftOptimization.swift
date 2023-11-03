@_exported import SwiftOptimizationSupport

@attached(memberAttribute)
public macro Optimize(
    _ level: OptimizationLevel
) = #externalMacro(
    module: "SwiftOptimizationMacros",
    type: "SwiftOptimizationMacro"
)
