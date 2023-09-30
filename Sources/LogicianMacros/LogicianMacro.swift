import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct LogicianLog: ExpressionMacro {
	public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
		var argIterator = node.argumentList.makeIterator()

		guard let firstArg = argIterator.next(),
			  let secondArg = argIterator.next(),
			  let thirdArg = argIterator.next()
		else {
			fatalError("compiler bug: the macro does not have enough arguments; got \(node.argumentList.count)")
		}

		let strippedMessageTemporaryVar = context.makeUniqueName("strippedMessage")

		guard let messageArgument = thirdArg.expression.as(StringLiteralExprSyntax.self) else {
			throw ArgumentError(description: "Third argument must be a string literal")
		}

		let strippedMessageArgument = Self.removeStringInterpolationArguments(from: messageArgument)

		return """
		{
			(\(firstArg.expression) as Logger).log(level: (\(secondArg.expression) as OSLogType), \(messageArgument))
			let \(strippedMessageTemporaryVar): String = \(strippedMessageArgument)
			for extraLogger in globalLogicianConfig.extraLoggers {
				extraLogger(\(literal: firstArg.expression.description), \(literal: secondArg.expression.description), \(strippedMessageTemporaryVar))
			}
		}()
		"""
	}

	private static func removeStringInterpolationArguments(from input: StringLiteralExprSyntax) -> StringLiteralExprSyntax {
		var output = input

		for (segI, segment) in zip(output.segments.indices, output.segments) {
			guard var exprSeg = segment.as(ExpressionSegmentSyntax.self) else { continue }
			for (i, labeledExpr) in zip(exprSeg.expressions.indices, exprSeg.expressions) {
				guard labeledExpr.label != nil else { continue }
				exprSeg.expressions.remove(at: i)

				if exprSeg.expressions.startIndex < i {
					let prevIndex = exprSeg.expressions.index(before: i)
					var prevExpr = exprSeg.expressions[prevIndex]
					prevExpr.trailingComma = nil
					exprSeg.expressions[prevIndex] = prevExpr
				}
			}

			let range = segI..<(output.segments.index(after: segI))

			output.segments.replaceSubrange(range, with: [.expressionSegment(exprSeg)])
		}

		return output
	}

	struct ArgumentError: Error, CustomStringConvertible {
		let description: String
	}
}

@main
struct LogicianPlugin: CompilerPlugin {
	let providingMacros: [Macro.Type] = [
		LogicianLog.self,
	]
}
