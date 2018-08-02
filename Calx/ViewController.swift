//
//  ViewController.swift
//  Calx
//
//  Created by Evan David on 8/1/18.
//  Copyright © 2018 Evan David. All rights reserved.
//

import Cocoa
import MathParser

class ViewController: NSViewController, NSTextFieldDelegate {
    var parenthAccum:Int = 0 //Parentheses accumulator for matching up closed parentheses
    let evaluator:Evaluator = Evaluator()
    
    override func controlTextDidChange(_ obj: Notification) {
        print("working")
        
        if (resultField.stringValue.count >= 10 && resultField.font == NSFont.systemFont(ofSize: 56)) {
            resultField.font = NSFont.systemFont(ofSize: 28)
        }
        else if (resultField.stringValue.count >= 18 && resultField.font == NSFont.systemFont(ofSize: 28)) {
            resultField.font = NSFont.systemFont(ofSize: 14)
        }
        else if (resultField.stringValue.count >= 36 && resultField.font == NSFont.systemFont(ofSize: 14)) {
            resultField.font = NSFont.systemFont(ofSize: 8)
        }
        else if (resultField.stringValue.count <= 36 && resultField.font == NSFont.systemFont(ofSize: 8)) {
            resultField.font = NSFont.systemFont(ofSize: 14)
        }
        else if (resultField.stringValue.count <= 18 && resultField.font == NSFont.systemFont(ofSize: 14)) {
            resultField.font = NSFont.systemFont(ofSize: 28)
        }
        else if (resultField.stringValue.count <= 10 && resultField.font == NSFont.systemFont(ofSize: 28)) {
            resultField.font = NSFont.systemFont(ofSize: 56)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultField.maximumNumberOfLines = 1
        resultField.delegate = self as NSTextFieldDelegate
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func checkOperator() -> Bool {
        if (resultFieldMut.suffix(3) == " + " || resultFieldMut.suffix(3) == " - " || resultFieldMut.suffix(3) == " * " || resultFieldMut.suffix(3) == " / ") {
            return true
        }
        else {
            return false
        }
    }
    
// ____________CALCULATOR BUTTONS_____________
    var resultFieldMut:String = "0" {
        didSet {
            print("working")
            resultField.stringValue = resultFieldMut
            
            if (resultField.stringValue.count >= 10 && resultField.font == NSFont.systemFont(ofSize: 56)) {
                resultField.font = NSFont.systemFont(ofSize: 28)
            }
            else if (resultField.stringValue.count >= 18 && resultField.font == NSFont.systemFont(ofSize: 28)) {
                resultField.font = NSFont.systemFont(ofSize: 14)
            }
            else if (resultField.stringValue.count >= 36 && resultField.font == NSFont.systemFont(ofSize: 14)) {
                resultField.font = NSFont.systemFont(ofSize: 8)
            }
            else if (resultField.stringValue.count <= 36 && resultField.font == NSFont.systemFont(ofSize: 8)) {
                resultField.font = NSFont.systemFont(ofSize: 14)
            }
            else if (resultField.stringValue.count <= 18 && resultField.font == NSFont.systemFont(ofSize: 14)) {
                resultField.font = NSFont.systemFont(ofSize: 28)
            }
            else if (resultField.stringValue.count <= 10 && resultField.font == NSFont.systemFont(ofSize: 28)) {
                resultField.font = NSFont.systemFont(ofSize: 56)
            }
        }
    }
    
    @IBOutlet var resultField: NSTextField!
    
    
    @IBAction func calcDel(_ sender: Any) {
        if checkOperator() {
            resultFieldMut.removeLast(3)
        }
        else if (resultFieldMut != "0" && resultFieldMut.count > 1) {
            resultFieldMut.removeLast()
        }
        else if (resultFieldMut.count == 1) {
            resultFieldMut = "0"
        }
    }
    
    @IBAction func calcPlus(_ sender: Any) {
        if (resultFieldMut != "0" && !checkOperator()) {
            resultFieldMut += " + "
        }
    }
    @IBAction func calcMinus(_ sender: Any) {
        //This one is going to be tricky--think about the logic of it
        resultFieldMut += " mom"
        
    }
    @IBAction func calcMult(_ sender: Any) {
        if (resultFieldMut != "0" && !checkOperator()) {
            resultFieldMut += " * "
        }
    }
    @IBAction func calcDivide(_ sender: Any) {
        if (resultFieldMut != "0" && !checkOperator()) {
            resultFieldMut += " / "
        }
    }
    
    @IBAction func calculate(_ sender: Any) {
        do {
            let expression = try Expression (string: resultFieldMut)
            let value = try evaluator.evaluate(expression)
            resultFieldMut = "\(value)"
        }
        catch {}
    }
    
    @IBAction func calcDot(_ sender: Any) {
        if (resultFieldMut == "0") {
            resultFieldMut = "."
        }
        else {
            resultFieldMut += "."
        }
    }
    @IBAction func calc0(_ sender: Any) {
        if (resultFieldMut != "0") {
            resultFieldMut += "0"
        }
    }
   
    @IBAction func calc1(_ sender: Any) {
        if (resultFieldMut == "0") {
            resultFieldMut = "1"
        }
        else {
            resultFieldMut += "1"
        }
    }
    @IBAction func calc2(_ sender: Any) {
        if (resultFieldMut == "0") {
            resultFieldMut = "2"
        }
        else {
            resultFieldMut += "2"
        }
    }
    @IBAction func calc3(_ sender: Any) {
        if (resultFieldMut == "0") {
            resultFieldMut = "3"
        }
        else {
            resultFieldMut += "3"
        }
    }
    @IBAction func calc4(_ sender: Any) {
        if (resultFieldMut == "0") {
            resultFieldMut = "4"
        }
        else {
            resultFieldMut += "4"
        }
    }
    @IBAction func calc5(_ sender: Any) {
        if (resultFieldMut == "0") {
            resultFieldMut = "5"
        }
        else {
            resultFieldMut += "5"
        }
    }
    @IBAction func calc6(_ sender: Any) {
        if (resultFieldMut == "0") {
            resultFieldMut = "6"
        }
        else {
            resultFieldMut += "6"
        }
    }
    @IBAction func calc7(_ sender: Any) {
        if (resultFieldMut == "0") {
            resultFieldMut = "7"
        }
        else {
            resultFieldMut += "7"
        }
    }
    @IBAction func calc8(_ sender: Any) {
        if (resultFieldMut == "0") {
            resultFieldMut = "8"
        }
        else {
            resultFieldMut += "8"
        }
    }
    @IBAction func calc9(_ sender: Any) {
        if (resultFieldMut == "0") {
            resultFieldMut = "9"
        }
        else {
            resultFieldMut += "9"
        }
    }
    @IBAction func calcOpenP(_ sender: Any) {
        if (resultFieldMut == "0") {
            resultFieldMut = "("
            parenthAccum += 1
        }
        else {
            resultFieldMut += "("
            parenthAccum += 1
        }
    }
    @IBAction func calcCloseP(_ sender: Any) {
        if (parenthAccum != 0) {
            resultFieldMut += ")"
            parenthAccum -= 1
        }
        
    }
    
    @IBAction func calcClear(_ sender: Any) {
        resultFieldMut = "0"
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
