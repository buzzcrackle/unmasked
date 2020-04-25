//
//  Calculate.swift
//  ObjectDetection
//
//  Created by Jesse Liang on 4/25/20.
//  Copyright © 2020 Y Media Labs. All rights reserved.
//

import Foundation
import SwiftCSV

public class Calculate {
    
    var csv:CSV? = nil
    var csvData:[String:[String:Int]]? = [:]
    
    init() {
        do {
            let urlPath = Bundle.main.url(forResource: "emergency-supplies", withExtension: "csv")
            csv = try CSV(url: urlPath!)
    //        csv = try CSV(url: URL(fileURLWithPath: "./ViewControllers/emergency-supplies.csv"))
            let namedRows = csv!.namedRows
            for i in 0...namedRows.count - 1 {
                let currRow = namedRows[i]
                print(currRow)
                let need = Int(currRow["Need"]!)!
                let medNeed = Int(currRow["MedNeed"]!)!
                let demand = Int(currRow["Demand"]!)!
                csvData![currRow["Item"]!] = ["Need": need, "MedNeed": medNeed, "Demand": demand] as [String:Int]
            }
        } catch {
            print(error)
        }
    }
    
    func calcSocTaxRate(item: String, quantity: Int) -> Float {
        let currData = csvData![item]
        let need = currData!["Need"]!
        let medNeed = currData!["MedNeed"]!
        let demand = currData!["Demand"]!
        let demPerc:Float = (Float(demand) + 100.0)/100.0
        let demandMult:Float = (currData!["Demand"]!) >= 40 ? demPerc : 1.0
        let med:Float = (Float(medNeed)*1.5 - Float(need))/400.0
        let medDemand = med >= 0.0 ? med : 0.0
        return Float(quantity*2)/Float(demand) * pow(demPerc, Float(quantity - 1) * (medDemand + 1) * demandMult) + medDemand// + demand
    }
    
    func calcSocCost(item: String, quantity: Int, price: Float) -> Float {
        let rate = self.calcSocTaxRate(item: item, quantity: quantity)
        return price * rate
    }
    
    func calcEnvCost(item: String, quantity: Int, price: Float) -> Float {
        return 10.0
    }
      
    func getItemNames() -> Array<String> {
        var value = Array<String>()
        for i in csvData!.keys {
          value.append(i)
        }
        return value
    }
}

var calculator = Calculate()