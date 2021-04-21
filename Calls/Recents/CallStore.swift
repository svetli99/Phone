//
//  CallStore.swift
//  Calls
//
//  Created by Svetlio on 16.04.21.
//

import UIKit

class Call: Codable {
    var name: String
    var phoneType: String
    var date: Date
    var isMissed: Bool
    var isOutcome: Bool
    var inSeriesCount: Int  {
        didSet {
            if inSeriesCount > 1 {
                name += " (\(inSeriesCount))"
            }
        }
    }
    
    init(name: String, phoneType: String, date: Date, isMissed: Bool, hasIcon: Bool, inSeriesCount: Int) {
        self.name = name
        self.phoneType = phoneType
        self.date = date
        self.isMissed = isMissed
        self.isOutcome = hasIcon
        self.inSeriesCount = inSeriesCount
    }
}

class CallStore {
    var allCalls: [Call] {
        didSet {
            missedCalls = allCalls.filter { $0.isMissed }
        }
    }
    var missedCalls = [Call]()
    
    let callArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("calls.json")
    }()
    
    init() {
        allCalls = [Call]()
        do {
            let jsonData = try Data(contentsOf: callArchiveURL)
            allCalls = try JSONDecoder().decode([Call].self, from: jsonData)
        } catch {
            print("Error decoding allItems: \(error)")
        }

    }
    
    @discardableResult func createCall(name: String, phoneType: String, date: Date, isMissed: Bool, hasIcon: Bool, inSeriesCount: Int) -> Call {
        let newCall = Call(name: name, phoneType: phoneType, date: date, isMissed: isMissed, hasIcon: hasIcon, inSeriesCount: inSeriesCount)
        if let lastCall = allCalls.last, lastCall.name == newCall.name && lastCall.isMissed == newCall.isMissed{
            lastCall.inSeriesCount += 1
        } else{
            allCalls.append(newCall)
        }
        return newCall
    }
    
    func getCall(segmentedIndex: Int, row: Int) -> Call {
        return segmentedIndex == 0 ? allCalls[row] : missedCalls[row]
    }
    
    func getNumberOfRows(segmentedIndex: Int) -> Int {
        return segmentedIndex == 0 ? allCalls.count : missedCalls.count
    }
    
    func loadCalls() {
        let name = "Refik"
        let phoneType = "mobile"
        let date = Date()
        var isMissed = false
        var hasIcon = true
        
        for _ in 1...15 {
           createCall(name: name, phoneType: phoneType, date: date, isMissed: isMissed, hasIcon: hasIcon, inSeriesCount: 1)
            isMissed.toggle()
            hasIcon.toggle()
        }
    }
    
    func deleteCall(segmentedIndex: Int, row: Int) {
        var row = row
        if segmentedIndex == 1 {
            var c = row
            for i in allCalls.indices where allCalls[i].isMissed {
                
                if c == 0 {
                    row = i
                    break
                }
                c -= 1
            }
        }
        allCalls.remove(at: row)
    }
    
    @objc func saveChanges() throws {
        print("Saving items to: \(callArchiveURL)")
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(allCalls)
            try data.write(to: callArchiveURL, options: [.atomic])
        } catch let encodingError {
            throw encodingError
        }
    }
}
