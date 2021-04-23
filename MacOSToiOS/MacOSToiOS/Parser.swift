//
//  ReadOnly.swift
//  MacOSToiOS
//
//  Created by WS Build on 4/21/21.
//

import Foundation
import MachO

enum Parser {
    private static func readBinary(atPath path: String) -> (Data, [Data], Data) {
        guard let handle = FileHandle(forReadingAtPath: path) else {
            fatalError("Cannot open a handle for the file at \(path). Aborting.")
        }
        
        // chop up the file into a relevant number of segments
        let headerData = try! handle.read(upToCount: MemoryLayout<mach_header_64>.stride)!
        
        let header: mach_header_64 = headerData.asStruct()
        if header.magic != MH_MAGIC_64 || header.cputype != CPU_TYPE_ARM64 {
            fatalError("The file is not a correct arm64 binary. Try thinning (via lipo) or unarchiving (via ar) first.")
        }
        
        let loadCommandsData: [Data] = (0..<header.ncmds).map { _ in
            let loadCommandPeekData = try! handle.peek(upToCount: MemoryLayout<load_command>.stride)
            return try! handle.read(upToCount: Int(loadCommandPeekData!.commandSize))!
        }
        
        let programData = try! handle.readToEnd()!
        
        try! handle.close()
        
        return (headerData, loadCommandsData, programData)
    }
    
    private static func readSegment64(_ data: Data, _ offset: UInt32) -> Data {
        // decode both the segment_command_64 and the subsequent section_64s
        var segment: segment_command_64 = data.asStruct()
        
        print("\n\n~~~~~~BEGINNING SEGMENT64~~~~~~~")
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        
        print("\n SEGMENT: \n")
        print("\(segment)\n")

        let sections: [section_64] = (0..<Int(segment.nsects)).map { index in
            let offset = MemoryLayout<segment_command_64>.stride + index * MemoryLayout<section_64>.stride
            return data.asStruct(fromByteOffset: offset)
        }
        
        print("FILEOFF: \(segment.fileoff)")
        print("FILESIZE: \(segment.filesize)")
        print("VMSIZE: \(segment.vmsize)")

        let offsetSections = sections.map { section -> section_64 in
            print("\n^^^^^^^^^ SECTION OFFSETS ^^^^^^^^^")
            print("\n \(section) \n")
            print("SECTION OFFSET: \(section.offset)")
            print("SECTION RELOFF: \(section.reloff)")
            print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
            return section
        }
                
        var datas = [Data]()
        datas.append(Data(bytes: &segment, count: MemoryLayout<segment_command_64>.stride))
        datas.append(contentsOf: offsetSections.map { section in
            var section = section
            return Data(bytes: &section, count: MemoryLayout<section_64>.stride)
        })
        
        if datas.merge() != data {
            fatalError("DIFFERENT SIZE AFTER PARSING")
        }
        
        print("\n\n~~~~~~RETURNING SEGMENT64~~~~~~~")
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        
        return data
    }
    
    private static func readBuildVersion(_ data: Data, _ offset: UInt32) -> Data {
        let buildVersion : build_version_command = data.asStruct()
        print("\n~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
        print("PARSING BUILD VERSION COMMAND")
        print("CMD:      \(buildVersion.cmd)")
        print("CMD-SIZE: \(buildVersion.cmdsize)")
        print("PLATFORM: \(buildVersion.platform)")
        print("MINOS:    \(buildVersion.minos)")
        print("SDK:      \(buildVersion.sdk)")
        print("NTOOLS:   \(buildVersion.ntools)")
        print("\n~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
        return data
    }
    
    private static func readVersionMin(_ data: Data, _ offset: UInt32) -> Data {
        let versionMin : version_min_command = data.asStruct()
        print("\n~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
        print("PARSING VERSION MIN COMMAND")
        print("CMD:      \(versionMin.cmd)")
        print("CMD-SIZE: \(versionMin.cmdsize)")
        print("VERSION:  \(versionMin.version)")
        print("SDK:      \(versionMin.sdk)")
        print("\n~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
        return data
    }
    
    private static func readDataCommand(_ data: Data, _ offset: UInt32) -> Data {
        let command: linkedit_data_command = data.asStruct()
        print("\n~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
        print("PARSING DATA COMMAND")
        print("DATAOFF: \(command.dataoff)")
        print("CMDSIZE: \(data.commandSize)")
        print("\n~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
        return data
    }
    
    private static func readSymTab(_ data: Data, _ offset: UInt32) -> Data {
        let command: symtab_command = data.asStruct()
        print("\n~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
        print("PARSING SYMBOL TABLE")
        print("STROFF: \(command.stroff)")
        print("SYMOFF: \(command.symoff)")
        print("CMDSIZE: \(data.commandSize)")
        print("\n~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
        return data
    }
    
    static func processBinary(atPath path: String) {
        let (headerData, loadCommandsData, programData) = readBinary(atPath: path)
        
        // `offset` is kind of a magic number here, since we know that's the only meaningful change to binary size
        // having a dynamic `offset` requires two passes over the load commands and is left as an exercise to the reader
        let offset = UInt32(abs(MemoryLayout<version_min_command>.stride - MemoryLayout<build_version_command>.stride))
        
        print("=======PROCESSING BINARY=========")
        print("=================================")
        print("=================================")
        print("=================================")
        print("\n Searching path \(path)\n")
        print("\n New offset is \(offset)\n")
                
        let editedCommandsData = loadCommandsData
            .map { (lc) -> Data in
                switch Int32(lc.loadCommand) {
                case LC_SEGMENT_64:
                    print("************** Found LC_SEGMENT_64: \(Int32(lc.loadCommand))\n")
                    return readSegment64(lc, offset)
                case LC_DATA_IN_CODE:
                    print("************** Found LC_DATA_IN_CODE: \(Int32(lc.loadCommand))\n")
                    return readDataCommand(lc, offset)
                case LC_LINKER_OPTIMIZATION_HINT:
                    print("************** Found LC_LINKER_OPTIMIZATION_HINT: \(Int32(lc.loadCommand))\n")
                    return readDataCommand(lc, offset)
                case LC_SYMTAB:
                    print("************** Found LC_SYMTAB: \(Int32(lc.loadCommand))\n")
                    return readSymTab(lc, offset)
                case LC_BUILD_VERSION:
                    print("************** Found LC_BUILD_VERSION: \(Int32(lc.loadCommand))\n")
                    return readBuildVersion(lc, offset)
                case LC_VERSION_MIN_IPHONEOS:
                    print("************** Found LC_VERSION_MIN_IPHONEOS: \(Int32(lc.loadCommand))\n")
                    return readVersionMin(lc, offset)
                default:
                    print("************** Found MISC: \(Int32(lc.loadCommand))\n")
                    return lc
                }
            }
            .merge()
        
        var header: mach_header_64 = headerData.asStruct()
        header.sizeofcmds = UInt32(editedCommandsData.count)
        
        // reassemble the binary
        let reworkedData = [
            Data(bytes: &header, count: MemoryLayout<mach_header_64>.stride),
            editedCommandsData,
            programData
        ].merge()
        
        let ogCommandSize = loadCommandsData.merge()
        
        print("REWORKED HEADER: \(Data(bytes: &header, count: MemoryLayout<mach_header_64>.stride).count) bytes")
        print("OG HEADER: \(headerData.count)\n")
        
        print("REWORKED COMMANDS: \(editedCommandsData.count) bytes")
        print("OG COMMANDS: \(ogCommandSize.count) bytes\n")
        
        print("REWORKED DATA: \(reworkedData.count) bytes")
        print("ORIGINAL DATA: \(headerData.count + ogCommandSize.count + programData.count) bytes")
        
        if reworkedData.count != (headerData.count + ogCommandSize.count + programData.count) {
            fatalError("DIFFERENT SIZE AFTER PARSE")
        }
                
        print("======================")
    }
}
