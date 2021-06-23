
import UIKit
import CoreData

class CallStore {
    static var shared = CallStore()
    
    var allCalls = [[Call]]() {
        didSet {
            missedCalls = allCalls.filter { $0.first?.callType == "Missed" }
        }
    }
    var missedCalls = [[Call]]()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }()
    
    private init() {
        loadCalls()
    }
    
    func loadCalls() {
        let fetchRequest: NSFetchRequest<Call> = Call.fetchRequest()
        let sortByDateTaken = NSSortDescriptor(key: #keyPath(Call.date),ascending: false)
        fetchRequest.sortDescriptors = [sortByDateTaken]
        
        let viewContext = persistentContainer.viewContext
        viewContext.performAndWait {
            
            do {
                let calls = try viewContext.fetch(fetchRequest)
                
               
                guard var prevCall = calls.first else {
                    return
                }
                allCalls = [[prevCall]]
                for call in calls[1...] {
                    if prevCall.name == call.name, prevCall.number == call.number, prevCall.phoneType == call.phoneType, isInSameSection(prevCall.callType, call.callType) {
                        allCalls[allCalls.count - 1].append(call)
                    } else {
                        allCalls.append([call])
                        prevCall = call
                    }
                }
                
            } catch {
                print("Error loading calls:",error)
            }
            
        }
    }
    
    func createCall(name: String, number: String, phoneType: String?, date: Date, callType: String?, callTime: String) {
        let viewContext = persistentContainer.viewContext
        var newCall: Call!
        viewContext.performAndWait {
            newCall = Call(context: viewContext)
            newCall.name = name
            newCall.number = number
            newCall.date = date
            newCall.phoneType = phoneType
            newCall.callTime = callTime
            newCall.callType = callType
        }
        
        let first = allCalls.first?.last
        if first?.name == name, isInSameSection(first?.callType, callType), first?.phoneType == phoneType, first?.number == number {
            allCalls[0].append(newCall)
        } else {
            allCalls.insert([newCall], at: 0)
        }
        
        
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Core Data save failed: \(error).")
        }
    }
    
    private func isInSameSection(_ firts: String?,_ second: String?) -> Bool {
        return (firts == "Missed" && second == "Missed") || (firts != "Missed" && second != "Missed")
    }
    
    func deleteCall(segmentedIndex: Int,index: Int) {
        var index = index
        if segmentedIndex == 1 {
            var c = index
            for i in allCalls.indices where allCalls[i].first?.callType == "Missed" {
                if c == 0 {
                    index = i
                    break
                }
                c -= 1
            }
        }
        
        let context = persistentContainer.viewContext
        
        allCalls[index].forEach {
            context.delete($0)
        }
        allCalls.remove(at: index)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Error saving delete contact: \(error)")
        }
    }
    
    func getCall(segmentedIndex: Int, row: Int) -> [Call] {
        return segmentedIndex == 0 ? allCalls[row] : missedCalls[row]
    }
    
    func getNumberOfRows(segmentedIndex: Int) -> Int {
        return segmentedIndex == 0 ? allCalls.count : missedCalls.count
    }
}
