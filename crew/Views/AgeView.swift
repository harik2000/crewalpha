//
//  AgeView.swift
//  crew
//
//  Created by Hari Krishna on 12/5/22.
//  AgeView.swift lets the user input in their age, allowing them to fill in their
//  month, day, and year, invalid input is triggered if user attempts to move
//  forward with a birthday that's not atleast 13 years old

import SwiftUI

struct AgeView: View {
    
    ///register data state object to get necessary variables for view
    @StateObject var registerData = RegisterViewModel()
    @State var showError = false

    var body: some View {
        ///Black background for user account flow
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                
                ///header text asking for the user to input in their age
                signUpHeaderText(headerText: Constants.ageHeaderText + " \(registerData.name)")
                    .padding(.bottom, -30)
                signUpHeaderText(headerText: Constants.ageSubHeaderText)
                
                ///age text field
                ageTextField(showError: $showError)

            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .opacity(showError ? 0.0 : 1)
            
            ///show error screen if user name input is invalid
            if showError{
                signUpErrorBanner(showError: $showError, signUpErrorHeaderText: Constants.ageErrorHeaderText, signUpErrorSubHeaderText: Constants.ageErrorSubHeaderText)
            }
        }
        .preferredColorScheme(.light)
        .navigationBarHidden(true)
    }

}


// MARK: textfield during user sign up for inputs
struct ageTextField: View {
    
    @State var month: String = ""
    @State var date: String = ""
    @State var year: String = ""

    enum FocusedField {
        case month, date, year
    }
    
    @FocusState private var fieldFocus: FocusedField?

    @State var tap = false

    @State var showUserNameView = false
    
    @StateObject var registerData = RegisterViewModel()

    @Binding var showError: Bool
    
    init(showError: Binding<Bool>) {
        self._showError = showError
        UIToolbar.appearance().isTranslucent = false
        UIToolbar.appearance().barStyle = .black
        UIToolbar.appearance().clipsToBounds = true
    }

    var body: some View {
        
        HStack {
            
            VStack {
                Text("MONTH")
                .font(.custom("ABCSocial-Bold-Trial", size: 12))
                .foregroundColor(.white)

                TextField("mm", text: $month).modifier(customViewModifier(textColor: .white, alignment: .center, fontSize: 22))
                    .keyboardType(.numberPad)
                    .accentColor(.white)
                    .frame(maxWidth: 65)
                    .focused($fieldFocus, equals: .month)
                    .onChange(of: self.month, perform: { value in
                        if month.count == 2 {
                            switchField(currentField: fieldFocus ?? .month)
                        }
                    })
                    .onReceive(month.publisher.collect()) {
                        self.month = String($0.prefix(2))
                    }
            }
            
            VStack {
                Text("DAY")
                    .font(.custom("ABCSocial-Bold-Trial", size: 12))
                    .foregroundColor(.white)

                TextField("dd", text: $date).modifier(customViewModifier(textColor: .white, alignment: .center, fontSize: 22))
                    .keyboardType(.numberPad)
                    .accentColor(.white)
                    .frame(maxWidth: 55)
                    .focused($fieldFocus, equals: .date)
                    .onChange(of: self.date, perform: { value in
                        if date.count == 2 {
                            switchField(currentField: fieldFocus ?? .month)
                        } else if date.count == 0 {
                            switchFieldRev(currentField: fieldFocus ?? .month)
                        }
                    })
                    .onReceive(date.publisher.collect()) {
                        self.date = String($0.prefix(2))
                    }
            }
            
            VStack {
                Text("YEAR")
                    .font(.custom("ABCSocial-Bold-Trial", size: 12))
                    .foregroundColor(.white)

                TextField("yyyy", text: $year).modifier(customViewModifier(textColor: .white, alignment: .center, fontSize: 22))
                    .keyboardType(.numberPad)
                    .accentColor(.white)
                    .frame(maxWidth: 80)
                    .focused($fieldFocus, equals: .year)
                    .onChange(of: self.year, perform: { value in
                        if year.count == 4 {
                            if date == "" || month == "" || year == "" {
                                withAnimation(.spring()) {
                                    showError.toggle()
                                    fieldFocus = nil
                                }
                            } else {
                                let ageValid = checkDate(date: Int(date)!, month: Int(month)!, year: Int(year)!)
                                if ageValid {
                                    registerData.updateBirthday(month: Int(month)!, day: Int(date)!, year: Int(year)!)
                                    showUserNameView.toggle()
                                } else {
                                    withAnimation(.spring()) {
                                        showError.toggle()
                                        fieldFocus = nil
                                    }
                                }
                            }

                        } else if year.count == 0 {
                            switchFieldRev(currentField: fieldFocus ?? .month)
                        }
                    })
                    .onReceive(year.publisher.collect()) {
                        self.year = String($0.prefix(4))
                    }

                    .toolbar {
                        
                        ToolbarItemGroup(placement: .keyboard) {

                            
                            NavigationLink(destination: UsernameView(), isActive: $showUserNameView) {
                                EmptyView().hidden()
                            }
                            
                            Spacer()

                            Text("e.g. 11/18/2000")
                                .foregroundColor(Color.white)
                                .font(.custom("ABCSocialExtended-Bold-Trial", size: 12))
                                .tracking(1)
                                .opacity(0.75)
                                .padding(.leading, 20)


                            Spacer()
                            
                            VStack {
                                Image("arrowright")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                    .padding(.leading, 2)
                            }
                            .frame(width: 40, height: 40)
                            .background(Color.white)
                            .mask(RoundedRectangle(cornerRadius: 10))
                            .scaleEffect(tap ? 0.8 : 1)
                            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tap)
                            .onTapGesture {
                                
                                print("TAPPED")
                                if date == "" || month == "" || year == "" {
                                    withAnimation(.spring()) {
                                        showError.toggle()
                                        fieldFocus = nil
                                    }
                                } else {
                                    let ageValid = checkDate(date: Int(date)!, month: Int(month)!, year: Int(year)!)
                                    print("is age valid \(ageValid)")
                                    if ageValid {
                                      registerData.updateBirthday(month: Int(month)!, day: Int(date)!, year: Int(year)!)
                                        showUserNameView.toggle()
                                    } else {
                                      withAnimation(.spring()) {
                                        showError.toggle()
                                        fieldFocus = nil
                                      }
                                    }
                                }
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                                tap = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    tap = false
                                }
                            }
                            .padding(.bottom, 3)
         
                          }
                    }
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                fieldFocus = .month
            }
        }
        .onChange(of: showError) { newValue in
            if showError == false {
                fieldFocus = .year
            }
        }
    }
    
    func switchField(currentField: FocusedField){
        switch currentField {
            case .month:
                fieldFocus = .date
            case .date:
                fieldFocus = .year
            case .year:
                fieldFocus = .year
        }
    }
    
    func switchFieldRev(currentField: FocusedField){
        switch currentField {
            case .year:
                fieldFocus = .date
            case .date:
                fieldFocus = .month
            case .month:
                fieldFocus = .month
        }
    }
    
    func checkDate(date: Int, month: Int, year: Int) -> Bool {
        if date < 1 || date > 31 || month < 1 || month > 12 || year < 1900 || year > 2009{
          return false
        }
        return true
    }
    
}
