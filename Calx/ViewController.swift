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
    static var evaluator:Evaluator = Evaluator()
    var justCalculated:Bool = false
    static var normal:Bool = true
    let pasteboard = NSPasteboard.general
    var answer:String?
    static let defaults = UserDefaults.standard
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSApplication.shared.activate(ignoringOtherApps: true) // Makes window active upon loading so calculations can be made straight away
        if (ViewController.defaults.integer(forKey: "angleMode") == 1 && degRad != nil) {
            ViewController.evaluator.angleMeasurementMode = .degrees
            degRad.title = "Degrees"
            degRad.alphaValue = 0.8
        } else if (degRad != nil) {
            ViewController.evaluator.angleMeasurementMode = .radians
            degRad.title = "Radians"
            degRad.alphaValue = 1
        }
        
        //Monitor for single keystrokes
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            if self.myKeyDown(with: $0) {
                return nil
            } else {
                return $0
            }
        }
        //Monitor for key-combos
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            if self.specialMyKeyDown(with: $0) {
                return nil
            } else {
                return $0
            }
        }
        
        
    }
    
    //Function for handling single keymappings using ints (see appleKeyboardInts.png)
    func myKeyDown(with event: NSEvent) -> Bool {
        // handle keyDown only if current window has focus, i.e. is keyWindow
        guard let locWindow = self.view.window,
            NSApplication.shared.keyWindow === locWindow else { return false }
        switch Int(event.keyCode) {
            case 124: //Right arrow Key
                justCalculated = false
                return true

            case 53: //esc key
                AppDelegate.popover.close()
                return true
            case 36: //enter key
                calculate((Any).self)
                return true
            default:
                return false
        }
    }
    
    //Function for handling key-combos using events
    func specialMyKeyDown(with event: NSEvent) -> Bool {
        guard let locWindow = self.view.window,
            NSApplication.shared.keyWindow === locWindow else { return false }
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        case [.command] where event.characters == "s": //s key
            if (ViewController.normal) {
                showScientific()
            } else {
                showNormal()
            }
            return true
        default:
            return false
        }
    }
    
    func showScientific() -> Void {
        AppDelegate.popover.contentViewController = ViewController.freshScientificController()
        AppDelegate.popover.show(relativeTo: AppDelegate.getButton().bounds, of: AppDelegate.getButton(), preferredEdge: NSRectEdge.minY)
        NSApplication.shared.activate(ignoringOtherApps: true)
        ViewController.normal = false
    }
    func showNormal() -> Void {
        AppDelegate.popover.contentViewController = ViewController.freshController()
        AppDelegate.popover.show(relativeTo: AppDelegate.getButton().bounds, of: AppDelegate.getButton(), preferredEdge: NSRectEdge.minY)
        NSApplication.shared.activate(ignoringOtherApps: true)
        ViewController.normal = true
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
            
            //Fixing rounding problem to avoid values less than 1E-8
            if (Double(resultFieldMut) != nil) {
                var doubleResult = Double(resultFieldMut)
                if (abs(doubleResult!) <= 1E-8 && abs(doubleResult!) >= 0) {
                    doubleResult = floor(abs(doubleResult!))
                    resultFieldMut = "\(doubleResult!)"
                    if (resultFieldMut.suffix(2) == ".0") {
                        resultFieldMut.removeLast(2)
                    }
                    resultField.stringValue = resultFieldMut
                }
            }
            
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
    func calcNum(str:String) {
        if (resultFieldMut == "0" || justCalculated) {
            resultFieldMut = "\(str)"
            justCalculated = false
        }
        else {
            resultFieldMut += "\(str)"
        }
    }
    
    @IBAction func calcDel(_ sender: Any) {
        if checkOperator() {
            resultFieldMut.removeLast(3)
        }
        else if (resultFieldMut != "0" && resultFieldMut.count > 1) {
            if (resultFieldMut.suffix(1) == "(") {
                parenthAccum -= 1
            } else if (resultFieldMut.suffix(1) == ")") {
                parenthAccum += 1
            }
            print(parenthAccum)
            resultFieldMut.removeLast()
        }
        else if (resultFieldMut.count == 1) {
            resultFieldMut = "0"
            parenthAccum = 0
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
            resultFieldMut = resultFieldMut.replacingOccurrences(of: "^", with: "**")
            resultFieldMut = resultFieldMut.replacingOccurrences(of: "e²", with: "(e)²")
            resultFieldMut = resultFieldMut.replacingOccurrences(of: "π²", with: "(π)²")
            resultFieldMut = resultFieldMut.replacingOccurrences(of: "e⁻¹", with: "(e)⁻¹")
            resultFieldMut = resultFieldMut.replacingOccurrences(of: "π⁻¹", with: "(π)⁻¹")
            if let ans = answer {
                resultFieldMut = resultFieldMut.replacingOccurrences(of: "ans", with: ans)
            }
            let expression = try Expression (string: resultFieldMut)
            let value = try ViewController.evaluator.evaluate(expression)
            
            resultFieldMut = "\(value)".replacingOccurrences(of: "**", with: "^")
        } catch {
            if (parenthAccum != 0) {
                changeCopyText(str: "Close your parentheses!")
            } else {
                changeCopyText(str: "Invalid input")
                
            }
        }
        if resultFieldMut.suffix(2) == ".0" {
            resultFieldMut.removeLast(2)
        }
        justCalculated = true
        answer = resultFieldMut
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
        if (resultFieldMut != "0" && !checkOperator()) {
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
        parenthAccum = 0
    }
    
    
    @IBAction func copyResult(_ sender: Any) {
        pasteboard.clearContents()
        pasteboard.setString(resultFieldMut, forType: .string)
        changeCopyText(str: "Copied")
    }
    
    func changeCopyText(str:String) {
        copied.stringValue = str
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.copied.stringValue = " : Copy Result"
        }
    }
    @IBOutlet var copied: NSTextField!
    
    
    //____________SCIENTIFIC CALCULATOR BUTTONS_____________
    
    func trigFunctions(function:String) {
        if (resultFieldMut == "0" || justCalculated) {
            resultFieldMut = "\(function)("
            parenthAccum += 1
        }
        else {
            resultFieldMut += "\(function)("
            parenthAccum += 1
        }
        justCalculated = false
    }
    
    @IBAction func sin(_ sender: Any) {
        trigFunctions(function: "sin")
    }
    
    @IBAction func arcsin(_ sender: Any) {
        trigFunctions(function: "asin")
    }
    
    @IBAction func cos(_ sender: Any) {
        trigFunctions(function: "cos")
    }
    
    @IBAction func arccos(_ sender: Any) {
        trigFunctions(function: "acos")
    }
    
    @IBAction func tan(_ sender: Any) {
        trigFunctions(function: "tan")
    }
    
    @IBAction func arctan(_ sender: Any) {
        trigFunctions(function: "atan")
    }
    
    @IBAction func pi(_ sender: Any) {
        calcNum(str: "π")
    }
    
    @IBAction func pow(_ sender: Any) {
        if (!checkOperator() && resultFieldMut != "0") {
            resultFieldMut += "^("
            parenthAccum += 1
            justCalculated = false
        }
    }
    
    @IBAction func euler(_ sender: Any) {
        calcNum(str: "e")
    }
    
    @IBAction func natlog(_ sender: Any) {
        trigFunctions(function: "ln")
    }
    
    @IBAction func log10(_ sender: Any) {
        trigFunctions(function: "log")
    }
    
    @IBAction func squared(_ sender: Any) {
        if (!checkOperator() && resultFieldMut != "0") {
            resultFieldMut += "²"
            justCalculated = false
        }
    }
    @IBAction func squareRoot(_ sender: Any) {
        trigFunctions(function: "√")
    }
    
    @IBAction func factorial(_ sender: Any) {
        if (resultFieldMut != "0" && !checkOperator()) {
            resultFieldMut += "!"
        }
        justCalculated = false
    }
    
    @IBAction func timesTenToThe(_ sender: Any) {
        if (!checkOperator() && resultFieldMut != "0") {
            resultFieldMut += "E"
            justCalculated = false
        }
    }
    
    @IBAction func oneOver(_ sender: Any) {
        if (!checkOperator() && resultFieldMut != "0") {
            resultFieldMut += "⁻¹"
            justCalculated = false
        }
    }
    @IBAction func percentify(_ sender: Any) {
        resultFieldMut.insert("(", at: resultFieldMut.startIndex)
        resultFieldMut.append(") / 100")
        calculate((Any).self)
    }
    
    @IBAction func ansInsert(_ sender: Any) {
        if (answer != nil) {
            calcNum(str: "ans")
        } else {
            changeCopyText(str: "No stored answer")
        }
    }
    
    //____DEGREE RADIANS CONTROL____
    
    @IBOutlet var degRad: SYFlatButton!
    
    @IBAction func degRadClick(_ sender: Any) {
        switch ViewController.evaluator.angleMeasurementMode {
        case .radians:
            ViewController.evaluator.angleMeasurementMode = .degrees
            ViewController.defaults.set(1, forKey: "angleMode")
            degRad.title = "Degrees"
            NSAnimationContext.runAnimationGroup({_ in
                NSAnimationContext.current.duration = 1.0
                degRad.animator().alphaValue = 0.8
            }, completionHandler: {})
            
        case .degrees:
            ViewController.evaluator.angleMeasurementMode = .radians
            ViewController.defaults.set(0, forKey: "angleMode")
            degRad.title = "Radians"
            NSAnimationContext.runAnimationGroup({_ in
                NSAnimationContext.current.duration = 1.0
                degRad.animator().alphaValue = 1
            }, completionHandler: {})
        }
    }
    
    
}




extension ViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> ViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "standardDark")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
            fatalError("Why cant i find ViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
    
    static func freshScientificController() -> ViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "scientificDark")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
            fatalError("HELP")
        }
        return viewcontroller
    }
}
