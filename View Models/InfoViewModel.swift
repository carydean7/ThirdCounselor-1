//
//  InfoViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 9/28/23.
//

import Foundation

class InfoViewModel: BaseViewModel {
    @Published var contents = [Info]()
    
    var disclosureGroupSectionTitles: [String] = [String]()
    var instructions = [String]()
    var functionsWithTopicSteps: [Function] = [Function]()
    
    var indexForFunctionsDisclosureLabels = 0

    static let shared = InfoViewModel()
    
    public override init() {
        super.init()
        
        fetchData {
        }
    }
    
    func fetchData(completion: @escaping () -> Void) {
        if contents.isEmpty {
            let jsonData = getDataFromJSON(fileName: "Info")
            contents = getInfo(from: jsonData)
                        
            if !contents.isEmpty {
                fetchDisclosureGroupSectionTitles()
            }
        }
        
        completion()
    }
        
    func fetchDisclosureGroupSectionTitles() {
        var functions = [Function]()
        
        for content in contents {
            disclosureGroupSectionTitles.append(content.screen)
            fetchInstructions(instruction: content.instructions)
            
            for function in content.functions {
                functions.append(Function(uid: UUID().uuidString, name: function.name, topic: function.topic, steps: function.steps))
            }
        }
    }
    
    func fetchInstructions(instruction: String) {
        instructions.append(instruction)
    }
    
    func disclosureGroupLabel(for functions: [Function], at index: Int) -> String {
        let label = functions[index].topic
       // indexForFunctionsDisclosureLabels += 1
        return label
    }
    
    func getInfo(from data: Any) -> [Info] {
        if data is JSONDictionary {
            let json: JSONDictionary = data as! JSONDictionary
            if let contentsArray = json[DictionaryKeys.contents.rawValue] as? [[String: Any]] {
                for content in contentsArray {
                    if let screen = content[DictionaryKeys.screen.rawValue] as? String, let instructions = content[DictionaryKeys.instructions.rawValue] as? String, let functions = content[DictionaryKeys.functions.rawValue] as? [[String: String]] {
                        contents.append(Info(uid: UUID().uuidString,
                                             screen: screen,
                                             instructions: instructions,
                                             functions: fetchFunctions(from: functions)))
                    }
                }
            }
        }
        
        return contents
    }
    
    func fetchFunctions(from data: [[String: String]]) -> [Function] {
        var functions = [Function]()
        
        for dict in data {
            functions.append(createFunction(from: dict))
        }
        
        return functions
    }
    
    func createFunction(from data: [String: String]) -> Function {
        if let name = data[DictionaryKeys.name.rawValue],
           let topic = data[DictionaryKeys.topic.rawValue],
           let steps = data[DictionaryKeys.steps.rawValue] {
            return Function(uid: UUID().uuidString,
                            name: name,
                            topic: topic,
                            steps: steps)
        }
        
        return Function(uid: "", name: "", topic: "", steps: "")
    }
}
