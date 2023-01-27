//
//  AddEventView.swift
//  Agenda
//
//  Created by Apps2T on 20/1/23.
//

import SwiftUI

struct AddEventView: View {
    
    @State var dateSelected: Date = Date()
    @State private var eventName: String = ""
    
    @Binding var shouldShowNewEvent: Bool
    var completion: () -> () = {}
    
    var body: some View {
        Text("Add new event")
        
        VStack {
            TextField("Event Name", text: $eventName)
                .frame(height: 44)
                .padding(.horizontal,10)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal,25)
                .padding(.top, 50)
            
            DatePicker("", selection: $dateSelected, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .background(Color.white)
                .cornerRadius(5)
                .padding(.horizontal, 10)
            
            Button {
                addEvent(eventName: eventName, dateSelected: dateSelected)
            } label: {
                Text("Add event")
                    .foregroundColor(.white)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(20)
            }
            .padding(.all, 50)
            
            Button {
                completion()
                shouldShowNewEvent = false
            } label: {
                Text("Go back")
            }
            
        }
    }
    func postEvent() {
    }
    
    func addEvent(eventName: String, dateSelected: Date) {
        
        //let dataCon = Int(dateSelected.timeIntervalSince1970)
        //baseUrl + endpoint
        let url = "https://superapi.netlify.app/api/eventos"
        let dataConv = convertDateToInt(date: dateSelected)
        
        //params
        let dictionary: [String: Any] = [
            "name" : eventName,
            "date" : dataConv
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
    
    func convertDateToInt(date:Date)-> Int{
        return Int(date.timeIntervalSince1970)
    }
    func onSuccess(){
        completion()
        shouldShowNewEvent = false
    }
    
    func onError(error: String) {
        print(error)
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(shouldShowNewEvent: .constant(true))
    }
}
