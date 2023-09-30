// The Swift Programming Language
// https://docs.swift.org/swift-book

import os

@freestanding(expression)
public macro log(in logger: Logger, as logType: OSLogType, _ value: OSLogMessage) = #externalMacro(module: "LogicianMacros", type: "LogicianLog")
