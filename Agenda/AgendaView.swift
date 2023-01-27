//
//  AgendaView.swift
//  Agenda
//
//  Created by Apps2T on 19/1/23.
//

import SwiftUI

struct EventResponseModel: Decodable {
    let name: String?
    let date: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        case date
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let date = try? values.decodeIfPresent(Int.self, forKey: .date) {
            self.date = date
        } else if let date = try? values.decodeIfPresent(String.self, forKey: .date) {
            self.date = Int(date)
        } else if let _ = try? values.decodeIfPresent(Float.self, forKey: .date) {
            self.date = nil
        } else {
            self.date = try values.decodeIfPresent(Int.self, forKey: .date)
        }
        
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}


struct EventPresentationModel: Identifiable {
    
    let id = UUID()
    let name: String
    let date: Int
}


struct AgendaView: View {
    @State var dateSelected: Date = Date()
    @State var events: [EventPresentationModel] = []
    @State var shouldShowNewEvent = false
    
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    Text("Agenda")
                        .foregroundColor(.black)
                        .font(.system(size: 30, weight: .bold))
                    
                    
                    DatePicker("", selection: $dateSelected, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .background(Color.white)
                        .cornerRadius(5)
                        .padding(.horizontal, 10)
                }
                .padding(.bottom, 5)
                
                ScrollView {
                    LazyVStack(spacing: 1) {
                        ForEach(events) { event in
                            HStack {
                                let timeInterval = TimeInterval(event.date)
                                let dataConv = Date(timeIntervalSince1970: timeInterval)
                                Text(event.name)
                                Spacer()
                                Text("\(dataConv.formatted())")
                            }
                            .padding(.horizontal, 5)
                            .frame(height: 40)
                            .background(Color.white)
                            .padding(.horizontal, 10)
                        }
                    }
                }
                .padding(.bottom, 5)
                
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        
        .sheet(isPresented: $shouldShowNewEvent, content: {
            AddEventView(shouldShowNewEvent: $shouldShowNewEvent){
                getEvents()
            }
        })
        
        .toolbar {
            Button {
                shouldShowNewEvent = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 15))
                
            }
            
        }
        .onAppear {
            getEvents()
        }
        
        .onChange(of: dateSelected){ _ in
            let newDate = Int(dateSelected.timeIntervalSince1970)
        }
    }
    
    
    func getEvents() {
        
        let url = "https://superapi.netlify.app/api/db/eventos"
        
        
        NetworkHelper.shared.requestProvider(url: url, type: .GET) { data, response, error in
            if let error = error {
                onError(error: error.localizedDescription)
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 { // esto daria ok
                    onSuccess(data: data)
                } else { // esto daria error
                    onError(error: error?.localizedDescription ?? "Request Error")
                }
            }
        }
    }
    
    
    func onSuccess(data: Data) {
        do {
            
            let eventsNotFiltered = try JSONDecoder().decode([EventResponseModel?].self, from: data)
            
            self.events = eventsNotFiltered.compactMap({ eventNotFiltered in
                
                guard let date = eventNotFiltered?.date else { return nil }
                
                return EventPresentationModel(name: eventNotFiltered?.name ?? "Empty Name", date: date)
            })
        } catch {
            self.onError(error: error.localizedDescription)
        }
        
    }
    
    func onError(error: String) {
        print(error)
    }
}

struct AgendaView_Previews: PreviewProvider {
    static var previews: some View {
        AgendaView()
    }
}
