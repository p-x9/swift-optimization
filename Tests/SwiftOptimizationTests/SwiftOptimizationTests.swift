import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import SwiftOptimization
@testable import SwiftOptimizationMacros

final class SwiftOptimizationTests: XCTestCase {
    let macros: [String: Macro.Type] = [
        "Optimize": SwiftOptimizationMacro.self
    ]

    func testExpansionVariable() {
        assertMacroExpansion(
            """
            @Optimize(.none)
            struct Item {
                var _hello: String
                var hello: String {
                    get { _hello }
                    set { _hello = newValue }
                }
                var こんにちは: String {
                    didSet {}
                }
            }
            """,
            expandedSource: """
            struct Item {
                var _hello: String
                @_optimize(none)
                var hello: String {
                    get { _hello }
                    set { _hello = newValue }
                }
                var こんにちは: String {
                    didSet {}
                }
            }
            """,
            macros: macros
        )
    }

    func testExpansionFunction() {
        assertMacroExpansion(
            """
            @Optimize(.none)
            struct Item {
                var hello: String
                func printHello() {
                    print(hello)
                }
            }
            """,
            expandedSource: """
            struct Item {
                var hello: String
                @_optimize(none)
                func printHello() {
                    print(hello)
                }
            }
            """,
            macros: macros
        )
    }

    func testExpansionExistedVariable() {
        assertMacroExpansion(
            """
            @Optimize(.none)
            struct Item {
                var _hello: String
                @_optimize(none)
                var hello: String {
                    get { _hello }
                    set { _hello = newValue }
                }
                var こんにちは: String {
                    didSet {}
                }
            }
            """,
            expandedSource: """
            struct Item {
                var _hello: String
                @_optimize(none)
                var hello: String {
                    get { _hello }
                    set { _hello = newValue }
                }
                var こんにちは: String {
                    didSet {}
                }
            }
            """,
            macros: macros
        )
    }

    func testExpansionExistedFunction() {
        assertMacroExpansion(
            """
            @Optimize(.none)
            struct Item {
                var hello: String
                @_optimize(none)
                func printHello() {
                    print(hello)
                }
            }
            """,
            expandedSource: """
            struct Item {
                var hello: String
                @_optimize(none)
                func printHello() {
                    print(hello)
                }
            }
            """,
            macros: macros
        )
    }

    func testCompileVariable() {
        @Optimize(.size)
        struct Item {
            var _hello: String
            var hello: String {
                get { _hello }
                set { _hello = newValue }
            }
            var こんにちは: String {
                didSet {}
            }
        }
    }

    func testCompileFunction() {
        @Optimize(.size)
        struct Item {
            var hello: String
            func printHello() {
                print(hello)
            }
        }
    }
}
