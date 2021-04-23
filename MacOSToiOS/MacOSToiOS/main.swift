import Foundation
import MachO

// support checking for Mach-O `cmd` and `cmdsize` properties
extension Data {
    var loadCommand: UInt32 {
        let lc: load_command = withUnsafeBytes { $0.load(as: load_command.self) }
        return lc.cmd
    }
    
    var commandSize: Int {
        let lc: load_command = withUnsafeBytes { $0.load(as: load_command.self) }
        return Int(lc.cmdsize)
    }
    
    func asStruct<T>(fromByteOffset offset: Int = 0) -> T {
        return withUnsafeBytes { $0.load(fromByteOffset: offset, as: T.self) }
    }
}

extension Array where Element == Data {
    func merge() -> Data {
        return reduce(into: Data()) { $0.append($1) }
    }
}

// support peeking at Data contents
extension FileHandle {
    func peek(upToCount count: Int) throws -> Data? {
        // persist the current offset, since `upToCount` doesn't guarantee all bytes will be read
        let originalOffset = offsetInFile
        let data = try read(upToCount: count)
        try seek(toOffset: originalOffset)
        return data
    }
}

let binaryPath = CommandLine.arguments[1]
let instruction = CommandLine.arguments[2]

switch instruction {
case "-p" :
    Parser.processBinary(atPath: binaryPath)
case "-t" :
    Transmogrifier.processBinary(atPath: binaryPath)
default:
    print("Unknown action \(instruction)")
}
