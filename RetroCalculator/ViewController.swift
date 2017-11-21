//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Lance Robbins on 11/16/17.
//  Copyright © 2017 Appcation. All rights reserved.


/* Project Worked on:
 - UIStackView (autolayout)
 - constraints (autolayout)
 - button/label/images/IBActions/Segues/Math
 - using custom fonts
 - using .wav files in the app
 
 
 */

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // class properties
    var btnSound: AVAudioPlayer!
    var opSound: AVAudioPlayer!
    var runningNumber = ""
    
    enum SoundType: String {
        case Operation = "op"
        case Number = "num"
    }
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty "
    }
    
    var currentOperation = Operation.Empty
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    
    
    @IBOutlet weak var outputLbl: UILabel!
    
    
    // class methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var path = Bundle.main.path(forResource: "btn", ofType: ".wav")
        let soundURL = URL(fileURLWithPath: path!) //unwrap path
        path = Bundle.main.path(forResource: "baseball_hit", ofType: ".wav")
        let operatorSoundURL = URL(fileURLWithPath: path!) //unwrap path
        
        // prepare number sound
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
                btnSound.prepareToPlay()
            
        } catch let err as NSError{
            print(err.debugDescription)
        }
        
        // prepare operator sound
        do {
            try opSound = AVAudioPlayer(contentsOf: operatorSoundURL)
            opSound.prepareToPlay()
            
        } catch let err as NSError{
            print(err.debugDescription)
        }
        
        outputLbl.text = "0"
    }
    
    @IBAction func numberPressed(sender: UIButton){
        playSound(soundtype: SoundType.Number)
        
        // Updates output label
        runningNumber += "\(sender.tag)"
        outputLbl.text = runningNumber
        
        
        
    }
    
    @IBAction func onDividePressed(sender: AnyObject){
        processOperation(operation: Operation.Divide)
    }
    @IBAction func onMultiplyPressed(sender: AnyObject){
        processOperation(operation: .Multiply)

    }
    @IBAction func onSubtractPressed(sender: AnyObject){
        processOperation(operation: .Subtract)

    }
    @IBAction func onAddPressed(sender: AnyObject){
        processOperation(operation: .Add)

    }
    
    @IBAction func onEqualPressed(sender: AnyObject){
        processOperation(operation: currentOperation)
    }
    
    @IBAction func onClearPressed(sender: AnyObject){
        
        playSound(soundtype: .Operation)
        
        leftValStr = ""
        rightValStr = ""
        runningNumber = ""
        result = ""
        currentOperation = Operation.Empty
        outputLbl.text = "0"
        
        
    }
    
    func playSound(soundtype: SoundType){
        // stop sound first in case somebody is clicking fast
        if btnSound.isPlaying {
            btnSound.stop()
        }
        
        
        if opSound.isPlaying {
            opSound.stop()
        }
        
        if soundtype == SoundType.Operation {
            opSound.play()

        }
        else if soundtype == SoundType.Number {
            btnSound.play()
        }
    }

    func processOperation(operation: Operation){
        playSound(soundtype: SoundType.Operation)
        
        if currentOperation != Operation.Empty{
            if runningNumber != ""{
                rightValStr = runningNumber
                runningNumber = "" // clear out when done to make sure 2 operation keys aren't hit in a row
            
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
            
                leftValStr = result
                outputLbl.text = result
            }
            currentOperation = operation
        } else {
            // first time an operator is pressed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
            
        }
    }
   


}

