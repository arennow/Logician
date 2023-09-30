// The Swift Programming Language
// https://docs.swift.org/swift-book

import os

public struct LogicianConfig {
	public typealias ExtraLogger = (_ loggerExpression: String, _ logTypeExpression: String, _ message: String) -> Void
	public static let defaultExtraLogger: ExtraLogger = { print("\($0) \($1): \($2)") }

	public var extraLoggers: Array<ExtraLogger>

	public init(extraLoggers: Array<ExtraLogger> = [Self.defaultExtraLogger]) {
		self.extraLoggers = extraLoggers
	}
}

@freestanding(expression)
public macro log(in logger: Logger, _ logType: OSLogType, _ value: OSLogMessage) = #externalMacro(module: "LogicianMacros", type: "LogicianLog")
