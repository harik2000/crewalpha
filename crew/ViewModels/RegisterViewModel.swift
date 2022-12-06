//
//  RegisterViewModel.swift
//  crew
//
//  Created by Hari Krishna on 12/1/22.
//  RegisterViewModel.swift interfaces between the views when the user is not signed in
//  Handles phone number verification, checking if user already has an account, otherwise
//  signs up with all the user attributes

import SwiftUI

class RegisterViewModel : ObservableObject {
    
    // MARK: storing user attributes locally on device before account is created in backend
    @AppStorage("phoneNumber") var phoneNumber = "" ///10 digit phone number
    @AppStorage("phoneCode") var phoneCode = "" ///6 digit phone code
    @AppStorage("name") var name = "" ///name of user
    @AppStorage("birthday") var birthday = "" ///birthday of user
    @AppStorage("username") var username = "" ///username of user
    @AppStorage("image_Data") var image_Data = Data(count: 0) ///profile of user

    // MARK: indicates whether phone verification code has been sent
    @AppStorage("sentPhoneCode") var sentPhoneCode = false ///6 digit phone code
    
    // MARK: phone code auth success 0 is default 1 is success 2 is failure
    @Published var phoneAuthCode = 0
    
    // MARK: phone code verify loading false is not verifying, true is verifying
    @Published var phoneCodeVerifyLoadingIndicator = false
    
    // MARK: temp phone numbers and codes that will work
    @State var validPhoneNumbersAndCodes: [String:String] = ["+16505551234": "123456"]
    
    // MARK: twilio / heroku phone code verify api from config.plist
    static let path = Bundle.main.path(forResource: "Config", ofType: "plist")
    static let config = NSDictionary(contentsOfFile: path!)
    private var baseURLString = config!["serverUrl"] as! String
    
    
    // MARK: update user phone number and send 6 digit code to be verified after
    func updatePhoneNumber(phoneNumber: String) {
        self.phoneNumber = "+1" + phoneNumber
        self.sentPhoneCode = false
        
        //send the code by calling twilio api if it doesn't exist in the dict
        if validPhoneNumbersAndCodes[self.phoneNumber] == nil {
            self.sendVerificationCode("1", phoneNumber)
        } else {
            self.sentPhoneCode = true //toggles that phone code has been sent if phone number is in the dict
        }
    }
    
    // MARK: update user phone code and verify if this is the correct code that has been sent with twilio
    func updatePhoneCode(phoneCode: String) {
        self.phoneCode = phoneCode
        
        //verify the code by calling twilio api if it doesn't exist in the dict
        if validPhoneNumbersAndCodes[self.phoneNumber] == nil {
            self.phoneCodeVerifyLoadingIndicator = true
            validateCode("1", phoneNumber, phoneCode)
        } else {
            for (tempPhoneNumber, tempPhoneCode) in validPhoneNumbersAndCodes {
                if tempPhoneNumber == self.phoneNumber && tempPhoneCode == self.phoneCode {
                    self.phoneAuthCode = 1
                } else {
                    self.phoneAuthCode = 2
                }
            }
        }
    }
    
    // MARK: reset phone code flag to 0 after wrong code has been inputted
    func resetPhoneCode() {
        self.phoneAuthCode = 0
    }
    
    // MARK: update the name of user
    func updateName(name: String) {
        self.name = name
    }
    
    //MARK: update the age & bday of user
    func updateBirthday(month: Int, day: Int, year: Int){

        var monthString = ""
        var dayString = ""
        
        if month < 10 {
            monthString = "0" + String(month)
        } else {
            monthString = String(month)
        }
        
        if day < 10 {
            dayString = "0" + String(day)
        } else {
            dayString = String(day)
        }
        
        self.birthday = monthString + "/" + dayString + "/" + String(year)
          
    }
    
    // MARK: update the username of user
    func updateUsername(username: String) {
        self.username = username
    }
    
    // MARK: reset profile photo of user
    func resetImage() {
      self.image_Data = Data(count: 0)
    }
    
    /// TWILIO API CALLS BELOW
    
    // MARK: sends 6 digit code by calling twilio's verify api
    func sendVerificationCode(_ countryCode: String, _ phoneNumber: String) {
        print("Country Code: \(countryCode)")
        print("Phone Number: \(phoneNumber)")
        let parameters = [
            "via": "sms",
            "country_code": countryCode,
            "phone_number": phoneNumber
        ]
        
        let path = "start"
        let method = "POST"
        
        let urlPath = "\(baseURLString)/\(path)"
        var components = URLComponents(string: urlPath)!
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        
        let url = components.url!

        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        let session: URLSession = {
            let config = URLSessionConfiguration.default
            return URLSession(configuration: config)
        }()
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let data = data {
                do {
                    print(data)
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                    
                    print(jsonSerialized!) //successfully sends code here
                    
                }  catch let error as NSError {
                    
                    print("JSON failed: \(error)")
                    
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self.sentPhoneCode = true //toggles that phone code has been sent
            }
        }
        task.resume()
    }
    
    // MARK: verify that user inputted 6 digit code is the correct code sent by twilio api
    func validateCode(_ countryCode: String, _ phoneNumber: String, _ verificationCode: String) {

        print("validate code phone number is \(phoneNumber)")

        VerifyAPI.validateVerificationCode(countryCode, phoneNumber, verificationCode) { checked in
            if (checked.success) {
                self.phoneAuthCode = 1 //correct 6 digit code
                self.phoneCodeVerifyLoadingIndicator = false //set verify phone code loading indicator to false
            } else {
                self.phoneAuthCode = 2 //incorrect 6 digit code
                self.phoneCodeVerifyLoadingIndicator = false //set verify phone code loading indicator to false
            }
        }
    }
    
}
