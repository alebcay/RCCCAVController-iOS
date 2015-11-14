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

let API_SERVER_CONTROLLER_URL = "http://192.168.1.37"

internal class API {
    class func makeCall(cmd : String) -> Bool {
        let response = Just.get(API_SERVER_CONTROLLER_URL + "/rcccav/" + cmd)
        if (response.ok) {
            print(String(response))
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

internal class Projector : Hashable, Equatable {
    let name : String
    let value : String
    let id : Int
    var on = false
    var frozen = false
    var hashValue: Int {
        return self.value.hashValue
    }
    init(desiredName : String, desiredId : Int, desiredValue : String) {
        name = desiredName
        id = desiredId
        value = desiredValue
    }
    func switchTo(inputSource : Input) -> Bool {
        return API.makeCall("video/vga_matrix_switch/S" + String(inputSource.id) + "_" + String(self.id))
    }
    
    func turnOn() -> Bool {
        return API.makeCall("video/" + self.value + "/ON")
    }
    
    func turnOff() -> Bool {
        return API.makeCall("video/" + self.value + "/OFF")
    }
    
    func freeze() -> Bool {
        return API.makeCall("video/" + self.value + "/FREEZE_ON")
    }
    
    func unfreeze() -> Bool {
        return API.makeCall("video/" + self.value + "/FREEZE_OFF")
    }
}

func == (lhs: Projector, rhs: Projector) -> Bool {
    return lhs.value == rhs.value
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
        FrontLeftRightBackSwitch.selectedSegmentIndex = UISegmentedControlNoSegment
        FrontCenterSwitch.selectedSegmentIndex = UISegmentedControlNoSegment
        PowerSwitch.addTarget(self, action: Selector("powerIsChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        FreezeAllSwitch.addTarget(self, action: Selector("freezeAllIsChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        FrontLeftRightBackSwitch.addTarget(self, action: Selector("frontLeftRightIsChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        FrontCenterSwitch.addTarget(self, action: Selector("frontCenterIsChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        print("OK. App is ready.")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var FrontLeft   = Projector(desiredName: "Front Left", desiredId: 1, desiredValue: "projector_front_left")
    var FrontRight  = Projector(desiredName: "Front Right", desiredId: 1, desiredValue: "projector_front_right")
    var BackCenter  = Projector(desiredName: "Back Center", desiredId: 1, desiredValue: "projector_back_center")
    var FrontCenter = Projector(desiredName: "Front Center", desiredId: 2, desiredValue: "projector_front_center")
    
    let Mac            = Input(desiredName: "Mac", desiredId: 1)
    let Podium         = Input(desiredName: "Podium", desiredId: 2)
    let Camcorder      = Input(desiredName: "Camcorder", desiredId: 3)
    let Laptop         = Input(desiredName: "Laptop", desiredId: 4)
    
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
        FreezeAllSwitch.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    @IBOutlet weak var FrontLeftRightBackSwitch: UISegmentedControl!
    
    func frontLeftRightIsChanged(FrontLeftRightBackSwitch: UISegmentedControl) {
        if (FrontLeftRightBackSwitch.selectedSegmentIndex == 0) {
            if (FrontLeft.switchTo(Mac) && FrontRight.switchTo(Mac) && BackCenter.switchTo(Mac)) {
                JLToast.makeText("Successfully switched Front Left/Right to Mac input.").show()
            }
            else {
                JLToast.makeText("Failed to switch Front Left/Right to Mac input.").show()
            }
        }
        else if (FrontLeftRightBackSwitch.selectedSegmentIndex == 1) {
            if (FrontLeft.switchTo(Podium) && FrontRight.switchTo(Podium) && BackCenter.switchTo(Podium)) {
                JLToast.makeText("Successfully switched Front Left/Right to Podium input.").show()
            }
            else {
                JLToast.makeText("Failed to switch Front Left/Right to Podium input.").show()
            }
        }
        else if (FrontLeftRightBackSwitch.selectedSegmentIndex == 2) {
            if (FrontLeft.switchTo(Camcorder) && FrontRight.switchTo(Camcorder) && BackCenter.switchTo(Camcorder)) {
                JLToast.makeText("Successfully switched Front Left/Right to Camcorder input.").show()
            }
            else {
                JLToast.makeText("Failed to switch Front Left/Right to Camcorder input.").show()
            }
        }
        else if (FrontLeftRightBackSwitch.selectedSegmentIndex == 3) {
            if (FrontLeft.switchTo(Laptop) && FrontRight.switchTo(Laptop) && BackCenter.switchTo(Laptop)) {
                JLToast.makeText("Successfully switched Front Left/Right to Laptop input.").show()
            }
            else {
                JLToast.makeText("Failed to switch Front Left/Right to Laptop input.").show()
            }
        }
        else {
            return
        }
        FrontLeftRightBackSwitch.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    @IBOutlet weak var FrontCenterSwitch: UISegmentedControl!
    
    func frontCenterIsChanged(FrontCenterSwitch: UISegmentedControl) {
        if (FrontCenterSwitch.selectedSegmentIndex == 0) {
            if (FrontLeft.switchTo(Mac) && FrontRight.switchTo(Mac) && BackCenter.switchTo(Mac)) {
                JLToast.makeText("Successfully switched Front Left/Right to Mac input.").show()
            }
            else {
                JLToast.makeText("Failed to switch Front Left/Right to Mac input.").show()
            }
        }
        else if (FrontCenterSwitch.selectedSegmentIndex == 1) {
            if (FrontLeft.switchTo(Podium) && FrontRight.switchTo(Podium) && BackCenter.switchTo(Podium)) {
                JLToast.makeText("Successfully switched Front Left/Right to Podium input.").show()
            }
            else {
                JLToast.makeText("Failed to switch Front Left/Right to Podium input.").show()
            }
        }
        else if (FrontCenterSwitch.selectedSegmentIndex == 2) {
            if (FrontLeft.switchTo(Camcorder) && FrontRight.switchTo(Camcorder) && BackCenter.switchTo(Camcorder)) {
                JLToast.makeText("Successfully switched Front Left/Right to Camcorder input.").show()
            }
            else {
                JLToast.makeText("Failed to switch Front Left/Right to Camcorder input.").show()
            }
        }
        else if (FrontCenterSwitch.selectedSegmentIndex == 3) {
            if (FrontLeft.switchTo(Laptop) && FrontRight.switchTo(Laptop) && BackCenter.switchTo(Laptop)) {
                JLToast.makeText("Successfully switched Front Left/Right to Laptop input.").show()
            }
            else {
                JLToast.makeText("Failed to switch Front Left/Right to Laptop input.").show()
            }
        }
        else {
            return
        }
        FrontCenterSwitch.selectedSegmentIndex = UISegmentedControlNoSegment
    }
}

