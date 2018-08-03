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
    let evaluator:Evaluator = Evaluator()
    var justCalculated:Bool = false
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        NSApplication.shared.activate(ignoringOtherApps: true) // Makes window active upon loading so calculations can be made straight away
        
        resultField.maximumNumberOfLines = 1
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            if self.myKeyDown(with: $0) {
                return nil
            } else {
                return $0
            }
        }
    }
    
    //FUNCTION FOR HANDLING KEYMAPPINGS. SEE PICTURE.
    func myKeyDown(with event: NSEvent) -> Bool {
        // handle keyDown only if current window has focus, i.e. is keyWindow
        guard let locWindow = self.view.window,
            NSApplication.shared.keyWindow === locWindow else { return false }
        switch Int(event.keyCode) {
            case 124: //Right arrow Key
                justCalculated = false
                return true
            default:
                return false
        }
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
            resultField.stringValue = resultFieldMut
            
            if (resultField.stringValue.count >= 9 && resultField.font == NSFont.systemFont(ofSize: 56)) {
                resultField.font = NSFont.systemFont(ofSize: 28)
            }
            else if (resultField.stringValue.count >= 18 && resultField.font == NSFont.systemFont(ofSize: 28)) {
                resultField.font = NSFont.systemFont(ofSize: 14)
            }
            else if (resultField.stringValue.count >= 36 && resultField.font == NSFont.systemFont(ofSize: 14)) {
                resultField.font = NSFont.systemFont(ofSize: 8)
            }
            if (resultField.stringValue.count <= 36 && resultField.font == NSFont.systemFont(ofSize: 8)) {
                resultField.font = NSFont.systemFont(ofSize: 14)
            }
            if (resultField.stringValue.count <= 18 && resultField.font == NSFont.systemFont(ofSize: 14)) {
                resultField.font = NSFont.systemFont(ofSize: 28)
            }
            if (resultField.stringValue.count <= 9 && resultField.font == NSFont.systemFont(ofSize: 28)) {
                resultField.font = NSFont.systemFont(ofSize: 56)
            }
        }
    }
    
    override func moveRight(_ sender: Any?) {
        print("hi")
    }
    
    @IBOutlet var resultField: NSTextField!
    
    func calcNum(number:Int) {
        if (resultFieldMut == "0" || justCalculated) {
            resultFieldMut = "\(number)"
            justCalculated = false
        }
        else {
            resultFieldMut += "\(number)"
        }
    }
    
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
        justCalculated = false
    }
    @IBAction func calcMinus(_ sender: Any) {
        if (resultFieldMut != "0" && !checkOperator()) {
            resultFieldMut += " - "
        }
        else if (resultFieldMut != "0" && resultFieldMut.suffix(1) == " ") {
            resultFieldMut += "-"
        }
        else if (resultFieldMut == "0") {
            resultFieldMut = "-"
        }
        justCalculated = false
    }
    @IBAction func calcMult(_ sender: Any) {
        if (resultFieldMut != "0" && !checkOperator()) {
            resultFieldMut += " * "
        }
        justCalculated = false
    }
    @IBAction func calcDivide(_ sender: Any) {
        if (resultFieldMut != "0" && !checkOperator()) {
            resultFieldMut += " / "
        }
        justCalculated = false
    }
    
    @IBAction func calculate(_ sender: Any) {
        do {
            let expression = try Expression (string: resultFieldMut)
            let value = try evaluator.evaluate(expression)
            resultFieldMut = "\(value)"
        }
        catch {}
        if resultFieldMut.suffix(2) == ".0" {
            resultFieldMut.removeLast(2)
        }
        justCalculated = true
        
    }
    
    @IBAction func calcDot(_ sender: Any) {
        if (resultFieldMut == "0" || justCalculated) {
            resultFieldMut = "0."
        }
        else if (resultFieldMut.suffix(1) == " " || resultFieldMut.suffix(1) == "(") {
            resultFieldMut += "0."
        }
        else {
            resultFieldMut += "."
        }
        justCalculated = false
    }
    @IBAction func calc0(_ sender: Any) {
        if (resultFieldMut != "0") {
            resultFieldMut += "0"
        }
        justCalculated = false
    }
   
    @IBAction func calc1(_ sender: Any) {
        calcNum(number: 1)
    }
    @IBAction func calc2(_ sender: Any) {
        calcNum(number: 2)
    }
    @IBAction func calc3(_ sender: Any) {
        calcNum(number: 3)
    }
    @IBAction func calc4(_ sender: Any) {
        calcNum(number: 4)
    }
    @IBAction func calc5(_ sender: Any) {
        calcNum(number: 5)
    }
    @IBAction func calc6(_ sender: Any) {
        calcNum(number: 6)
    }
    @IBAction func calc7(_ sender: Any) {
        calcNum(number: 7)
    }
    @IBAction func calc8(_ sender: Any) {
        calcNum(number: 8)
    }
    @IBAction func calc9(_ sender: Any) {
        calcNum(number: 9)
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
        justCalculated = false
    }
    @IBAction func calcCloseP(_ sender: Any) {
        if (parenthAccum != 0) {
            resultFieldMut += ")"
            parenthAccum -= 1
        }
        justCalculated = false
    }
    
    @IBAction func calcClear(_ sender: Any) {
        resultFieldMut = "0"
        justCalculated = false
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
