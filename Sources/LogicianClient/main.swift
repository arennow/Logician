import Logician
import os

extension Logger {
	static let screep = Logger(subsystem: "com.example.log", category: "test")
}

#log(in: .screep, .fault, "This is a second one: \(1 + 5, privacy: .public), and also this was weird: \("BRR", privacy: .sensitive)")
