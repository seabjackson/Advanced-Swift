//: Playground - noun: a place where people can play

import UIKit

protocol Setting {
    func settingView() -> UIView
}

let defaultSettings: [String:Setting] = [
    "Airplane Mode": true,
    "Name": "My iPhone",
]

var localizedSettings = defaultSettings
localizedSettings["Name"] = "Mein iPhone"
localizedSettings["Do Not Disturb"] = true
let oldName = localizedSettings.updateValue("My iPhone", forKey: "Name")

