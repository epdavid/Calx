//
//  TodayViewController.swift
//  Calx Widget
//
//  Created by Evan David on 8/6/18.
//  Copyright © 2018 Evan David. All rights reserved.
//

import Cocoa
import NotificationCenter
import MathParser


class TodayViewController: NSViewController, NCWidgetProviding {
    
    var parenthAccum:Int = 0 //Parentheses accumulator for matching up closed parentheses
    static var evaluator:Evaluator = Evaluator()
    var justCalculated:Bool = false
    static var normal:Bool = true
    let pasteboard = NSPasteboard.general
    var answer:String?

    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.noData)
        self.preferredContentSize = NSMakeSize(0, 282)
        
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
        case [.command] where event.characters == "v": //cmd+v
            let contents = pasteboard.string(forType: NSPasteboard.PasteboardType.string)
            if (contents != nil) {
                if resultFieldMut != "0" {
                    resultFieldMut += contents!
                } else if resultFieldMut == "0" {
                    resultFieldMut = contents!
                }
            }
            return true
        default:
            return false
        }
    }

    
    func animateSelf(_ me: SYFlatButton) {
        NSAnimationContext.runAnimationGroup({_ in
            NSAnimationContext.current.duration = 0.07
            me.animator().alphaValue = 0.5
        }, completionHandler: {
            NSAnimationContext.current.duration = 0.07
            me.animator().alphaValue = 1.0
        })
    }
    
    func checkOperator() -> Bool {
        if (resultFieldMut.suffix(3) == " + " || resultFieldMut.suffix(3) == " - " || resultFieldMut.suffix(3) == " × " || resultFieldMut.suffix(3) == " / ") {
            return true
        }
        else {
            return false
        }
    }
    
    var resultFieldMut:String = "0" {
        didSet {
            if resultField != nil {
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
                
                if (resultField.stringValue.count >= 9 && resultField.font == NSFont.systemFont(ofSize: 50)) {
                    resultField.font = NSFont.systemFont(ofSize: 28)
                } else if (resultField.stringValue.count >= 18 && resultField.font == NSFont.systemFont(ofSize: 28)) {
                    resultField.font = NSFont.systemFont(ofSize: 14)
                } else if (resultField.stringValue.count >= 36 && resultField.font == NSFont.systemFont(ofSize: 14)) {
                    resultField.font = NSFont.systemFont(ofSize: 8)
                }
                
                if (resultField.stringValue.count <= 36 && resultField.font == NSFont.systemFont(ofSize: 8)) {
                    resultField.font = NSFont.systemFont(ofSize: 14)
                }
                if (resultField.stringValue.count <= 18 && resultField.font == NSFont.systemFont(ofSize: 14)) {
                    resultField.font = NSFont.systemFont(ofSize: 28)
                }
                if (resultField.stringValue.count <= 9 && resultField.font == NSFont.systemFont(ofSize: 28)) {
                    resultField.font = NSFont.systemFont(ofSize: 50)
                }
            }
        }
    }
    
    
    @IBOutlet var resultField: NSTextField!
    
    func calcNum(number:Int) {
        if (resultFieldMut == "0" || justCalculated) {
            resultFieldMut = "\(number)"
            justCalculated = false
        } else {
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
            resultFieldMut.removeLast()
        }
        else if (resultFieldMut.count == 1) {
            resultFieldMut = "0"
            parenthAccum = 0
        }
        
        
    }
    
    @IBAction func calcPlus(_ sender: Any) {
        animateSelf(sender as! SYFlatButton)
        if (resultFieldMut != "0" && !checkOperator()) {
            resultFieldMut += " + "
        }
        justCalculated = false
        
    }
    @IBAction func calcMinus(_ sender: Any) {
        animateSelf(sender as! SYFlatButton)
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
        animateSelf(sender as! SYFlatButton)
        if (resultFieldMut != "0" && !checkOperator()) {
            resultFieldMut += " × "
        }
        justCalculated = false
    }
    @IBAction func calcDivide(_ sender: Any) {
        animateSelf(sender as! SYFlatButton)
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
            let value = try TodayViewController.evaluator.evaluate(expression)
            
            resultFieldMut = "\(value)"
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
        animateSelf(sender as! SYFlatButton)
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
        animateSelf(sender as! SYFlatButton)
        if (resultFieldMut != "0" && !checkOperator()) {
            resultFieldMut += "0"
        }
        justCalculated = false
    }
    
    @IBAction func calc1(_ sender: Any) {
        calcNum(number: 1)
        animateSelf(sender as! SYFlatButton)
    }
    @IBAction func calc2(_ sender: Any) {
        animateSelf(sender as! SYFlatButton)
        calcNum(number: 2)
    }
    @IBAction func calc3(_ sender: Any) {
        animateSelf(sender as! SYFlatButton)
        calcNum(number: 3)
    }
    @IBAction func calc4(_ sender: Any) {
        animateSelf(sender as! SYFlatButton)
        calcNum(number: 4)
    }
    @IBAction func calc5(_ sender: Any) {
        animateSelf(sender as! SYFlatButton)
        calcNum(number: 5)
    }
    @IBAction func calc6(_ sender: Any) {
        animateSelf(sender as! SYFlatButton)
        calcNum(number: 6)
    }
    @IBAction func calc7(_ sender: Any) {
        animateSelf(sender as! SYFlatButton)
        calcNum(number: 7)
    }
    @IBAction func calc8(_ sender: Any) {
        animateSelf(sender as! SYFlatButton)
        calcNum(number: 8)
    }
    @IBAction func calc9(_ sender: Any) {
        animateSelf(sender as! SYFlatButton)
        calcNum(number: 9)
    }
    @IBAction func calcOpenP(_ sender: Any) {
        animateSelf(sender as! SYFlatButton)
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
        animateSelf(sender as! SYFlatButton)
        if (parenthAccum != 0) {
            resultFieldMut += ")"
            parenthAccum -= 1
        }
        justCalculated = false
    }
    
    @IBAction func calcClear(_ sender: Any) {
        animateSelf(sender as! SYFlatButton)
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
    
    

}
