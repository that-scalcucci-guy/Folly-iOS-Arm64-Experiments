//
//  Transmogrifier.swift
//  MacOSToiOS
//
//  Created by WS Build on 4/21/21.
//

import Foundation
import MachO

enum Transmogrifier {
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
    
    private static func updateVersionMin(_ data: Data, _ offset: UInt32) -> Data {
        var command = version_min_command(cmd: UInt32(LC_VERSION_MIN_IPHONEOS),
                                      cmdsize: UInt32(MemoryLayout<version_min_command>.stride),
                                      version: 13 << 16 | 0 << 8 | 0,
                                      sdk: 13 << 16 | 0 << 8 | 0)
        
        return Data(bytes: &command, count: MemoryLayout<version_min_command>.stride)
    }
    
    private static func updateBuildVersion(_ data: Data) -> Data {
        var command = build_version_command(cmd: UInt32(LC_BUILD_VERSION),
                                            cmdsize: UInt32(MemoryLayout<build_version_command>.stride),
                                            platform: UInt32(PLATFORM_IOS),
                                            minos: 13 << 16 | 0 << 8 | 0,
                                            sdk: 14 << 16 | 4 << 8 | 0,
                                            ntools: 0)
        
        return Data(bytes: &command, count: MemoryLayout<build_version_command>.stride)
    }
    
    static func processBinary(atPath path: String) {
        let (headerData, loadCommandsData, programData) = readBinary(atPath: path)

        print("Searching path \(path)")
        
        let editedCommandsData = loadCommandsData
            .map { (lc) -> Data in
                switch Int32(lc.loadCommand) {
                case LC_BUILD_VERSION:
                    print("************** Found LC_BUILD_VERSION: \(Int32(lc.loadCommand))")
                    return updateBuildVersion(lc)
                default:
                    print("************** Found MISC: \(Int32(lc.loadCommand))")
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
        
        // save back to disk
        print("Saving back to disk")
        
        try! reworkedData.write(to: URL(fileURLWithPath: path))
    }
}


/*
 //
 //  Transmogrifier.swift
 //  MacOSToiOS
 //
 //  Created by WS Build on 4/21/21.
 //

 import Foundation
 import MachO

 enum Transmogrifier {
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
     
     private static func updateSegment64(_ data: Data, _ offset: UInt32) -> Data {
         // decode both the segment_command_64 and the subsequent section_64s
         var segment: segment_command_64 = data.asStruct()
         print("BEGINNING SEGMENT64: \(segment)")

         let sections: [section_64] = (0..<Int(segment.nsects)).map { index in
             let offset = MemoryLayout<segment_command_64>.stride + index * MemoryLayout<section_64>.stride
             return data.asStruct(fromByteOffset: offset)
         }
         
         print("CREATED SECTIONS SEGMENT64")

         // shift segment information by the offset
         segment.fileoff -= segment.fileoff > 0 ? UInt64(offset) : 0
         segment.filesize -= segment.filesize > 0 ? UInt64(offset) : 0
         segment.vmsize -= segment.vmsize > 0 ? UInt64(offset) : 0
         
         print("SHIFTED SEGMENTS SEGMENT64")

         let offsetSections = sections.map { section -> section_64 in
             print("\n ~~~~~~~~~~~~~")
             print("OFFSETTING SECTION \(section)")
             var section = section
             
             //section.offset -= UInt32(offset)
             print("OFFSET: \(section.offset)")
             if section.offset > 0 {
                 print("OFFSET GREATER THAN 0")
                 print("DOING OPERATION: \(section.offset) - \(UInt32(offset))")
                 print("NEW OFFSET: \(section.offset - UInt32(offset))")
                 section.offset -= UInt32(offset)
             } else {
                 print("NEW OFFSET: \(section.offset - 0)")
             }
             
             print("RELOFF: \(section.reloff)")
             if section.reloff > 0 {
                 print("RELOFF GREATER THAN 0")
                 print("DOING OPERATION: \(section.reloff) - \(UInt32(offset))")
                 print("NEW RELOFF: \(section.reloff - UInt32(offset))")
                 section.reloff -= UInt32(offset)
             } else {
                 print("NEW RELOFF: \(section.reloff - 0)")
                 section.reloff -= 0
             }

             //section.reloff -= section.reloff > 0 ? UInt32(offset) : 0
             print("DONE OFFSETTING SECTION \(section)")
             print("\n ~~~~~~~~~~~~~")
             return section
         }
         
         print("CREATED OFFSET SECTIONS SEGMENT64")
         
         var datas = [Data]()
         datas.append(Data(bytes: &segment, count: MemoryLayout<segment_command_64>.stride))
         datas.append(contentsOf: offsetSections.map { section in
             var section = section
             return Data(bytes: &section, count: MemoryLayout<section_64>.stride)
         })
         
         print("RETURNING SEGMENT64")
         return datas.merge()
     }
     
     private static func updateVersionMin(_ data: Data, _ offset: UInt32) -> Data {
         var command = version_min_command(cmd: UInt32(LC_VERSION_MIN_IPHONEOS),
                                       cmdsize: UInt32(MemoryLayout<version_min_command>.stride),
                                       version: 13 << 16 | 0 << 8 | 0,
                                       sdk: 13 << 16 | 0 << 8 | 0)
         
         return Data(bytes: &command, count: MemoryLayout<version_min_command>.stride)
     }
     
     private static func updateBuildVersion(_ data: Data) -> Data {
         var command = build_version_command(cmd: UInt32(LC_BUILD_VERSION),
                                             cmdsize: UInt32(MemoryLayout<build_version_command>.stride),
                                             platform: UInt32(PLATFORM_IOS),
                                             minos: 13 << 16 | 0 << 8 | 0,
                                             sdk: 14 << 16 | 4 << 8 | 0,
                                             ntools: 0)
         
         return Data(bytes: &command, count: MemoryLayout<version_min_command>.stride)
     }
     
     private static func updateDataInCode(_ data: Data, _ offset: UInt32) -> Data {
         var command: linkedit_data_command = data.asStruct()
         command.dataoff -= offset
         return Data(bytes: &command, count: data.commandSize)
     }
     
     private static func updateSymTab(_ data: Data, _ offset: UInt32) -> Data {
         var command: symtab_command = data.asStruct()
         command.stroff -= offset
         command.symoff -= offset
         return Data(bytes: &command, count: data.commandSize)
     }
     
     static func processBinary(atPath path: String) {
         let (headerData, loadCommandsData, programData) = readBinary(atPath: path)
         
         // `offset` is kind of a magic number here, since we know that's the only meaningful change to binary size
         // having a dynamic `offset` requires two passes over the load commands and is left as an exercise to the reader
         let offset = UInt32(abs(MemoryLayout<version_min_command>.stride - MemoryLayout<build_version_command>.stride))
         
         print("======================")
         print("======================")
         print("======================")
         print("======================")
         print("Searching path \(path)")
         print("New offset is \(offset)")
         
         let editedCommandsData = loadCommandsData
             .map { (lc) -> Data in
                 switch Int32(lc.loadCommand) {
                 case LC_BUILD_VERSION:
                     print("************** Found LC_BUILD_VERSION: \(Int32(lc.loadCommand))")
                     return updateBuildVersion(lc)
                 /*case LC_SEGMENT_64:
                     print("************** Found LC_SEGMENT_64: \(Int32(lc.loadCommand))")
                     return updateSegment64(lc, offset)
                 case LC_DATA_IN_CODE:
                     print("************** Found LC_DATA_IN_CODE: \(Int32(lc.loadCommand))")
                     return updateDataInCode(lc, offset)
                 case LC_LINKER_OPTIMIZATION_HINT:
                     print("************** Found LC_LINKER_OPTIMIZATION_HINT: \(Int32(lc.loadCommand))")
                     return updateDataInCode(lc, offset)
                 case LC_SYMTAB:
                     print("************** Found LC_SYMTAB: \(Int32(lc.loadCommand))")
                     return updateSymTab(lc, offset)
                 case LC_BUILD_VERSION:
                     print("************** Found LC_BUILD_VERSION: \(Int32(lc.loadCommand))")
                     return updateVersionMin(lc, offset)
                 case LC_VERSION_MIN_IPHONEOS:
                     print("************** Found LC_VERSION_MIN_IPHONEOS: \(Int32(lc.loadCommand))")
                     fatalError("This arm64 binary already contains an LC_VERSION_MIN_IPHONEOS load command!")*/
                 default:
                     print("************** Found MISC: \(Int32(lc.loadCommand))")
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
         
         // save back to disk
         print("Saving back to disk")
         print("======================")
         print("======================")
         print("======================")
         print("======================")
         print("======================")
         
         try! reworkedData.write(to: URL(fileURLWithPath: path))
     }
 }

 */
