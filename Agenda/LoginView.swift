//
//  LoginView.swift
//  Agenda
//
//  Created by Apps2T on 9/1/23.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var shouldShowRegister: Bool = false
    @State private var shouldShowAgenda: Bool = false
    //MOSTRAR ALERT
    @State var shouldShowErrorAlert: Bool = false
    @State var alertText: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                VStack {
                    Image("calendar")
                        .resizable()
                        .frame(width: 130, height: 130)

                    
                    Text("LOGIN")
                        .foregroundColor(.gray)
                        .font(.system(size: 38, weight: .bold))
                        .padding(.top, 20)
                    
                    
                    TextField("Email", text: $email)
                        .frame(height: 44)
                        .padding(.horizontal,10)
                        .background(RoundedRectangle(cornerRadius: 20).stroke(self.email != "" ? Color.gray : greyishColor, lineWidth: 2))
                        .padding(.horizontal,25)
                        .padding(.top, 20)
                    
                    
                    TextField("Password", text: $password)
                        .frame(height: 44)
                        .padding(.horizontal,10)
                        .background(RoundedRectangle(cornerRadius: 20).stroke(self.password != "" ? Color.gray : greyishColor, lineWidth: 2))
                        .padding(.horizontal,25)
                        .padding(.top, 15)
                    
                    Spacer()
                    
                
                    
                    loginButton(title: "Login")
                    
                    HStack {
                        Text("Haven't got an account yet?")
                            .foregroundColor(.black)
                            .font(.system(size: 17))
                        
                        Spacer()
                        
                        Button {
                            shouldShowRegister = true
                        } label: {
                            Text("Register")
                                .font(.system(size: 17))
                        }
                        .background(
                            NavigationLink(destination: Registerview(), isActive: $shouldShowRegister) {
                                EmptyView()
                            }
                        )
                    }
                    .padding(20)
                    
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
                
    }
    
    func login(email: String, pass: String) {
        
        //baseUrl + endpoint
        let url = "https://superapi.netlify.app/api/login"
        
        //params
        let dictionary: [String: Any] = [
            "user" : email,
            "pass" : pass
        ]
        
        // petición
        NetworkHelper.shared.requestProvider(url: url, params: dictionary) { data, response, error in
            if let error = error {
                onError(error: error.localizedDescription)
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    onSuccess()
                } else {
                    onError(error: error?.localizedDescription ?? "Request Error")
                }
            }
        }
    }
    
    func onSuccess() {
        
        shouldShowAgenda = true
    }
    
    func onError(error: String) {
        print(error)
        shouldShowErrorAlert = true
        alertText = "NoBody with this data"
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension LoginView {
 
//    var loginButton: some View {
//        Button {
//            if email.isEmpty || password.isEmpty {
//                shouldShowErrorAlert = true
//                alertText = "Fields are empty"
//            }else{
//                login(email: email, pass: password)
//            }
//
//        } label: {
//            Text("Login")
//                .foregroundColor(.white)
//                .frame(height: 20)
//                .frame(maxWidth: .infinity)
//                .background(Color.black)
//                .cornerRadius(20)
//                .padding(.horizontal, 21)
//
//        }
//
//    }
    
    var greyishColor: Color {
        Color.black.opacity(0.7)
    }
    
    
    func loginButton(title: String) -> some View {
        Button {
            if email.isEmpty || password.isEmpty {
                shouldShowErrorAlert = true
                alertText = "Fields are empty"
            }else{
                login(email: email, pass: password)
            }
        } label: {
            Text(title)
                .foregroundColor(.white)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .cornerRadius(20)
                .padding(.horizontal, 21)

        }
        .background(
            NavigationLink(destination: AgendaView(), isActive: $shouldShowAgenda) {
                EmptyView()
            }
        )
        .alert("Login Error", isPresented: $shouldShowErrorAlert, actions: {
            Button {
           
            } label: {
                Text("Ok")
            }
        }) {
            Text(alertText)
        }
    }
}
