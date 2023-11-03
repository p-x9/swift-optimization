import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftOptimizationSupport

struct SwiftOptimizationMacro {
    struct Arguments {
        let level: OptimizationLevel

        init(level: OptimizationLevel) {
            self.level = level
        }
    }

    static func arguments(of node: AttributeSyntax) -> Arguments? {
        guard case let .argumentList(arguments) = node.arguments else {
            return nil
        }

        var level: OptimizationLevel?
        if let accessExpr = arguments.lazy.compactMap({ $0.expression.as(MemberAccessExprSyntax.self) }).first {
            let rawValue = accessExpr.declName.baseName.trimmed.text.replacingOccurrences(of: "`", with: "")
            level = OptimizationLevel(rawValue: rawValue)
        }

        guard let level else { return nil }

        return .init(level: level)
    }
}

extension SwiftOptimizationMacro: MemberAttributeMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        guard let arguments = arguments(of: node) else {
            return []
        }

        let optimizationAttr: AttributeSyntax = "@_optimize(\(raw: arguments.level.rawValue))"

        if let varDecl = member.as(VariableDeclSyntax.self),
           !checkIfOptimizeAttributeExisted(varDecl.attributes),
           let binding = varDecl.bindings.first,
           !binding.isStored {
            return [
                optimizationAttr
            ]
        }

        if let funcDecl = member.as(FunctionDeclSyntax.self),
           !checkIfOptimizeAttributeExisted(funcDecl.attributes) {
            return [
                optimizationAttr
            ]
        }

        return []
    }
}

extension SwiftOptimizationMacro {
    static func checkIfOptimizeAttributeExisted(_ attributes: AttributeListSyntax) -> Bool {
        attributes.contains { element in
            guard case let .attribute(attribute) = element,
                  let name = attribute.attributeName.as(IdentifierTypeSyntax.self),
                  ["_optimize"].contains(name.name.trimmed.text) else {
                return false
            }
            return true
        }
    }
}
