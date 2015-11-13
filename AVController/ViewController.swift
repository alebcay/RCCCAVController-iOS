//
//  ViewController.swift
//  AVController
//
//  Created by Caleb Xu on 11/10/15.
//  Copyright © 2015 Raleigh Chinese Christian Church. All rights reserved.
//

import UIKit
import JLToast
import Just

let API_SERVER_CONTROLLER_URL = "http://107.15.102.164.xip.io:8080"

internal class API {
    class func makeCall(cmd : String) -> Bool {
        let response = Just.get(API_SERVER_CONTROLLER_URL + "/rcccav/" + cmd)
        if (response.ok) {
            return true
        }
        else {
            return false
        }
    }
}

internal class Input {
    let name : String
    let id : Int
    init(desiredName : String, desiredId : Int) {
        name = desiredName
        id = desiredId
    }
}

internal class Projector {
    let name : String
    let id : Int
    var on = false
    var frozen = false
    init(desiredName : String, desiredId : Int) {
        name = desiredName
        id = desiredId
    }
    
    func switchTo(inputSource : Input) -> Bool {
        return API.makeCall("video/vga_matrix_switch/S" + String(inputSource.id) + "_" + String(self.id))
    }
    
    func turnOn() -> Bool {
        return API.makeCall("video/" + self.name + "/ON")
    }
    
    func turnOff() -> Bool {
        return API.makeCall("video/" + self.name + "/OFF")
    }
    
    func freeze() -> Bool {
        return API.makeCall("video/" + self.name + "/FREEZE_ON")
    }
    
    func unfreeze() -> Bool {
        return API.makeCall("video/" + self.name + "/FREEZE_OFF")
    }
}

internal class System {
    var on = false
    var frozen = false
    
    class func turnOn() -> Bool {
        return API.makeCall("system/ON")
    }
    
    class func turnOff() -> Bool {
        return API.makeCall("system/OFF")
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        PowerSwitch.selectedSegmentIndex = UISegmentedControlNoSegment
        FreezeAllSwitch.selectedSegmentIndex = UISegmentedControlNoSegment
        FrontLeftRightSwitch.selectedSegmentIndex = UISegmentedControlNoSegment
        FrontCenterSwitch.selectedSegmentIndex = UISegmentedControlNoSegment
        PowerSwitch.addTarget(self, action: Selector("powerIsChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        FreezeAllSwitch.addTarget(self, action: Selector("freezeAllIsChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        FrontLeftRightSwitch.addTarget(self, action: Selector("frontLeftRightIsChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        FrontCenterSwitch.addTarget(self, action: Selector("frontCenterIsChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        print("OK. App is ready.")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var FrontLeftRight = Projector(desiredName: "Front Left/Right", desiredId: 1)
    var FrontCenter    = Projector(desiredName: "Front Center", desiredId: 2)
    
    let Mac            = Input(desiredName: "Mac", desiredId: 1)
    let Podium         = Input(desiredName: "Podium", desiredId: 2)
    let Camcorder      = Input(desiredName: "Camcorder", desiredId: 3)
    
    @IBOutlet weak var PowerSwitch: UISegmentedControl!
    
    func powerIsChanged(PowerSwitch: UISegmentedControl) {
        if (PowerSwitch.selectedSegmentIndex == 0) {
            if (System.turnOn()) {
                JLToast.makeText("Successfully powered system on.").show()
            }
            else {
                PowerSwitch.selectedSegmentIndex = UISegmentedControlNoSegment
                JLToast.makeText("Failed to power system on.").show()
            }
        }
        else {
            if (System.turnOff()) {
                JLToast.makeText("Successfully powered system off.").show()
            }
            else {
                PowerSwitch.selectedSegmentIndex = UISegmentedControlNoSegment
                JLToast.makeText("Failed to power system off.").show()
            }
        }
    }
    
    @IBOutlet weak var FreezeAllSwitch: UISegmentedControl!
    
    func freezeAllIsChanged(FreezeAllSwitch: UISegmentedControl) {
        
    }
    
    @IBOutlet weak var FrontLeftRightSwitch: UISegmentedControl!
    
    func frontLeftRightIsChanged(FrontLeftRightSwitch: UISegmentedControl) {
        if (FrontLeftRightSwitch.selectedSegmentIndex == 0) {
            if (FrontLeftRight.turnOff()) {
                JLToast.makeText("Successfully powered off Front Left/Right.").show()
            }
            else {
                JLToast.makeText("Failed to power off Front Left/Right.").show()
            }
        }
        else if (FrontLeftRightSwitch.selectedSegmentIndex == 1) {
            if (FrontLeftRight.freeze()) {
                JLToast.makeText("Successfully froze Front Left/Right.").show()
            }
            else {
                JLToast.makeText("Failed to freeze Front Left/Right.").show()
            }
        }
        else if (FrontLeftRightSwitch.selectedSegmentIndex == 2) {
            if (FrontLeftRight.switchTo(Mac)) {
                JLToast.makeText("Successfully switched Front Left/Right to Mac input.").show()
            }
            else {
                JLToast.makeText("Failed to switch Front Left/Right to Mac input.").show()
            }
        }
        else if (FrontLeftRightSwitch.selectedSegmentIndex == 3) {
            if (FrontLeftRight.switchTo(Podium)) {
                JLToast.makeText("Successfully switched Front Left/Right to Podium input.").show()
            }
            else {
                JLToast.makeText("Failed to switch Front Left/Right to Podium input.").show()
            }
        }
        else if (FrontLeftRightSwitch.selectedSegmentIndex == 4) {
            if (FrontLeftRight.switchTo(Camcorder)) {
                JLToast.makeText("Successfully switched Front Left/Right to Camcorder input.").show()
            }
            else {
                JLToast.makeText("Failed to switch Front Left/Right to Camcorder input.").show()
            }
        }
        else {
            return
        }
    }
    
    @IBOutlet weak var FrontCenterSwitch: UISegmentedControl!
    
    func frontCenterIsChanged(FrontCenterSwitch: UISegmentedControl) {
        if (FrontCenterSwitch.selectedSegmentIndex == 0) {
            if (FrontCenter.turnOff()) {
                JLToast.makeText("Successfully powered off Front Center.").show()
            }
            else {
                JLToast.makeText("Failed to power off Front Center.").show()
            }
        }
        else if (FrontCenterSwitch.selectedSegmentIndex == 1) {
            if (FrontCenter.freeze()) {
                JLToast.makeText("Successfully froze Front Center.").show()
            }
            else {
                JLToast.makeText("Failed to freeze Front Center.").show()
            }
        }
        else if (FrontCenterSwitch.selectedSegmentIndex == 2) {
            if (FrontCenter.switchTo(Mac)) {
                JLToast.makeText("Successfully switched Front Center to Mac input.").show()
            }
            else {
                JLToast.makeText("Failed to switch Front Center to Mac input.").show()
            }
        }
        else if (FrontCenterSwitch.selectedSegmentIndex == 3) {
            if (FrontCenter.switchTo(Podium)) {
                JLToast.makeText("Successfully switched Front Center to Podium input.").show()
            }
            else {
                JLToast.makeText("Failed to switch Front Center to Podium input.").show()
            }
        }
        else if (FrontCenterSwitch.selectedSegmentIndex == 4) {
            if (FrontCenter.switchTo(Camcorder)) {
                JLToast.makeText("Successfully switched Front Center to Camcorder input.").show()
            }
            else {
                JLToast.makeText("Failed to switch Front Center to Camcorder input.").show()
            }
        }
        else {
            return
        }
    }
}

