//
//  ViewController.swift
//  Calx
//
//  Created by Evan David on 8/1/18.
//  Copyright © 2018 Evan David. All rights reserved.
//

import Cocoa
import MathParser

class ViewController: NSViewController {
    var parenthAccum:Int = 0 //Parentheses accumulator for matching up closed parentheses
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func checkOperator() -> Bool {
        if (resultField.stringValue.suffix(3) == " + " || resultField.stringValue.suffix(3) == " - " || resultField.stringValue.suffix(3) == " * " || resultField.stringValue.suffix(3) == " / ") {
            return true
        }
        else {
            return false
        }
    }
    
// ____________CALCULATOR BUTTONS_____________
    @IBOutlet var resultField: NSTextField!
    
    
    @IBAction func calcDel(_ sender: Any) {
        if checkOperator() {
            resultField.stringValue.removeLast(3)
        }
        else if (resultField.stringValue != "0" && resultField.stringValue.count > 1) {
            resultField.stringValue.removeLast()
        }
        else if (resultField.stringValue.count == 1) {
            resultField.stringValue = "0"
        }
    }
    
    @IBAction func calcPlus(_ sender: Any) {
        if (resultField.stringValue != "0" && !checkOperator()) {
            resultField.stringValue += " + "
        }
    }
    @IBAction func calcMinus(_ sender: Any) {
        //This one is going to be tricky--think about the logic of it
    }
    @IBAction func calcMult(_ sender: Any) {
        if (resultField.stringValue != "0" && !checkOperator()) {
            resultField.stringValue += " * "
        }
    }
    @IBAction func calcDivide(_ sender: Any) {
        if (resultField.stringValue != "0" && !checkOperator()) {
            resultField.stringValue += " / "
        }
    }
    
    @IBAction func calculate(_ sender: Any) {
        let expression = NSExpression(format: resultField.stringValue)
        let result = expression.expressionValue(with: nil, context: nil) as? Double
        resultField.stringValue = "\(result ?? 0)"
    }
    
    @IBAction func calcDot(_ sender: Any) {
        if (resultField.stringValue == "0") {
            resultField.stringValue = "."
        }
        else {
            resultField.stringValue += "."
        }
    }
    @IBAction func calc0(_ sender: Any) {
        if (resultField.stringValue != "0") {
            resultField.stringValue += "0"
        }
    }
    @IBAction func calc1(_ sender: Any) {
        if (resultField.stringValue == "0") {
            resultField.stringValue = "1"
        }
        else {
            resultField.stringValue += "1"
        }
    }
    @IBAction func calc2(_ sender: Any) {
        if (resultField.stringValue == "0") {
            resultField.stringValue = "2"
        }
        else {
            resultField.stringValue += "2"
        }
    }
    @IBAction func calc3(_ sender: Any) {
        if (resultField.stringValue == "0") {
            resultField.stringValue = "3"
        }
        else {
            resultField.stringValue += "3"
        }
    }
    @IBAction func calc4(_ sender: Any) {
        if (resultField.stringValue == "0") {
            resultField.stringValue = "4"
        }
        else {
            resultField.stringValue += "4"
        }
    }
    @IBAction func calc5(_ sender: Any) {
        if (resultField.stringValue == "0") {
            resultField.stringValue = "5"
        }
        else {
            resultField.stringValue += "5"
        }
    }
    @IBAction func calc6(_ sender: Any) {
        if (resultField.stringValue == "0") {
            resultField.stringValue = "6"
        }
        else {
            resultField.stringValue += "6"
        }
    }
    @IBAction func calc7(_ sender: Any) {
        if (resultField.stringValue == "0") {
            resultField.stringValue = "7"
        }
        else {
            resultField.stringValue += "7"
        }
    }
    @IBAction func calc8(_ sender: Any) {
        if (resultField.stringValue == "0") {
            resultField.stringValue = "8"
        }
        else {
            resultField.stringValue += "8"
        }
    }
    @IBAction func calc9(_ sender: Any) {
        if (resultField.stringValue == "0") {
            resultField.stringValue = "9"
        }
        else {
            resultField.stringValue += "9"
        }
    }
    @IBAction func calcOpenP(_ sender: Any) {
        if (resultField.stringValue == "0") {
            resultField.stringValue = "("
            parenthAccum += 1
        }
        else {
            resultField.stringValue += "("
            parenthAccum += 1
        }
    }
    @IBAction func calcCloseP(_ sender: Any) {
        if (parenthAccum != 0) {
            resultField.stringValue += ")"
            parenthAccum -= 1
        }
        
    }
    
    @IBAction func calcClear(_ sender: Any) {
        resultField.stringValue = "0"
    }
    
    
}













extension ViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> ViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "ViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
            fatalError("Why cant i find ViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
