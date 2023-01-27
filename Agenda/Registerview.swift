//
//  Registerview.swift
//  Agenda
//
//  Created by Apps2T on 10/1/23.
//

import SwiftUI

struct Registerview: View {
    
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var password2: String = ""
    @State var email: String = ""
    @State var shouldShowErrorAlert: Bool = false
    @State var alertText: String = ""
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack{
                Image("calendar")
                    .resizable()
                    .frame(width: 130, height: 130)
                
                Text("REGISTER")
                    .foregroundColor(.gray)
                    .font(.system(size: 38, weight: .bold))
                    .padding(.top, 20)
                
                TextField("Name", text: $name)
                    .frame(height: 44)
                    .padding(.horizontal,10)
                    .background(RoundedRectangle(cornerRadius: 20).stroke(self.name != "" ? Color.gray : greyishColor, lineWidth: 2))
                    .padding(.horizontal,25)
                    .padding(.top, 20)
                
                SecureField("Password", text: $password)
                    .frame(height: 44)
                    .padding(.horizontal,10)
                    .background(RoundedRectangle(cornerRadius: 20).stroke(self.password != "" ? Color.gray : greyishColor, lineWidth: 2))
                    .padding(.horizontal,25)
                    .padding(.top, 20)
                
                SecureField("Repeat Password", text: $password2)
                    .frame(height: 44)
                    .padding(.horizontal,10)
                    .background(RoundedRectangle(cornerRadius: 20).stroke(self.password2 != "" ? Color.gray : greyishColor, lineWidth: 2))
                    .padding(.horizontal,25)
                    .padding(.top, 20)
                
                
                TextField("Email", text: $email)
                    .frame(height: 44)
                    .padding(.horizontal,10)
                    .background(RoundedRectangle(cornerRadius: 20).stroke(self.email != "" ? Color.gray : greyishColor, lineWidth: 2))
                    .padding(.horizontal,25)
                    .padding(.top, 20)
                
                
                
                Spacer()
                
                Button {
                    if email.isEmpty || password.isEmpty || password2.isEmpty || name.isEmpty{
                        shouldShowErrorAlert = true
                        alertText = "Fiels are empty"
                    }else if  password != password2{
                        shouldShowErrorAlert = true
                        alertText = "Passwords dont match"
                    }else{
                        register(email: email, pass: password)
                    }
                    
                } label: {
                    Text("Register")
                        .foregroundColor(.white)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(20)
                }
                .padding(.all, 50)
                .alert("Reg Error", isPresented: $shouldShowErrorAlert, actions: {
                            Button {
                           
                            } label: {
                                Text("Ok")
                            }
                        }) {
                            Text(alertText)
                        }
                
            }
        }
    }
    
    var greyishColor: Color {
        Color.black.opacity(0.7)
    }
    
    private func register(email: String, pass: String) {
        
        //baseUrl + endpoint
        let url = "https://superapi.netlify.app/api/register"
        
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
                if response.statusCode == 200 { // esto daria ok
                    onSuccess()
                } else { // esto daria error
                    onError(error: error?.localizedDescription ?? "Request Error")
                }
            }
        }
    }
    
    func onSuccess() {
        //navegacion hacia atrás
        mode.wrappedValue.dismiss()
    }
    
    func onError(error: String) {
        print(error)
    }
}





struct Registerview_Previews: PreviewProvider {
    static var previews: some View {
        Registerview()
    }
}
