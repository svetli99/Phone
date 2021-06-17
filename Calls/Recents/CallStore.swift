
import UIKit
import CoreData

class CallStore {
    static var shared = CallStore()
    
    var allCalls = [Call]() {
        didSet {
            missedCalls = allCalls.filter { $0.isMissed }
        }
    }
    var missedCalls = [Call]()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Contacts")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()
    
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
                allCalls = try viewContext.fetch(fetchRequest)
                
            } catch {
                print("Error loading calls:",error)
            }
            
        }
    }
    
    func createCall(name: String,number: String, phoneType: String, date: Date, isMissed: Bool, isOutcome: Bool) {
        if allCalls.first?.name == name, allCalls.first?.isMissed == isMissed, allCalls.first?.type == phoneType,allCalls.first?.number == number {
            allCalls[0].inSeriesCount += 1
            allCalls[0].date?.append(date)
        } else {
            let viewContext = persistentContainer.viewContext
            var newCall: Call!
            viewContext.performAndWait {
                newCall = Call(context: viewContext)
                newCall.name = name
                newCall.number = number
                newCall.date = [date]
                newCall.type = phoneType
                newCall.isMissed = isMissed
                newCall.isOutcome = isOutcome
                newCall.inSeriesCount = 1
            }
            allCalls.insert(newCall, at: 0)
        }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Core Data save failed: \(error).")
        }
    }
    
    func deleteCall(segmentedIndex: Int,index: Int) {
        var index = index
        if segmentedIndex == 1 {
            var c = index
            for i in allCalls.indices where allCalls[i].isMissed {
                if c == 0 {
                    index = i
                    break
                }
                c -= 1
            }
        }
        let call = allCalls.remove(at: index)
        
        let context = persistentContainer.viewContext
        context.delete(call)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Error saving delete contact: \(error)")
        }
    }
    
    func getCall(segmentedIndex: Int, row: Int) -> Call {
        return segmentedIndex == 0 ? allCalls[row] : missedCalls[row]
    }
    
    func getNumberOfRows(segmentedIndex: Int) -> Int {
        return segmentedIndex == 0 ? allCalls.count : missedCalls.count
    }
}
