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
    var inSeriesCount: Int = 1 {
        didSet {
            if inSeriesCount > 1 {
                name += " (\(inSeriesCount))"
            }
        }
    }
    
    init(name: String, phoneType: String, date: Date, isMissed: Bool, hasIcon: Bool) {
        self.name = name
        self.phoneType = phoneType
        self.date = date
        self.isMissed = isMissed
        self.isOutcome = hasIcon
    }
}

class CallStore {
    static var shared = CallStore()
    
    var allCalls = [Call]() {
        didSet {
            missedCalls = allCalls.filter { $0.isMissed }
        }
    }
    var missedCalls = [Call]()
    
    let callArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent("calls.json")
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }()
    
    private init() {
        let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
        do {
            let jsonData = try Data(contentsOf: callArchiveURL)
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            allCalls = try jsonDecoder.decode([Call].self, from: jsonData)
            missedCalls = allCalls.filter { $0.isMissed }
        } catch {
            print("Error decoding allCalls: \(error)")
        }

    }
    
    @discardableResult func createCall(name: String, phoneType: String, date: Date, isMissed: Bool, hasIcon: Bool) -> Call {
        let newCall = Call(name: name, phoneType: phoneType, date: date, isMissed: isMissed, hasIcon: hasIcon)
        if let lastCall = allCalls.last, lastCall.name == newCall.name && lastCall.isMissed == newCall.isMissed{
            lastCall.inSeriesCount += 1
        } else{
            allCalls.insert(newCall, at: 0)
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
           createCall(name: name, phoneType: phoneType, date: date, isMissed: isMissed, hasIcon: hasIcon)
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
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            let data = try encoder.encode(allCalls)
            try data.write(to: callArchiveURL, options: [.atomic])
        } catch let encodingError {
            throw encodingError
        }
    }
}
