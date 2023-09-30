import Logician
import os

extension Logger {
	static let screep = Logger(subsystem: "com.example.log", category: "test")
}

#log(in: .screep, as: .debug, "This is two")
#log(in: .screep, as: .debug, "This is a second one: \(1 + 5, privacy: .public)")
#log(in: .screep, as: .error, "Bar!")
