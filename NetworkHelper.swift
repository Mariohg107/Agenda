//
//  NetworkHelper.swift
//  Agenda
//
//  Created by Apps2T on 20/1/23.
//

import Foundation

class NetworkHelper {
    
    enum RequestType: String {
        case POST
        case GET
    }
    

    static let shared = NetworkHelper()
   
    private func requestApi(request: URLRequest, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        //nos guardamos la constante task que nos devuelve la función dataTask pasandole el objeto request que hemos creado en la función de abajo requestProvider
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // usamos el completion para pasar los datos, recordemos que esto es un pasa bolas. ORDEN: Aquí recogemos data, response y error -> se los pasamos a requestProvider -> se los pasamos la función que tendremos en el viewModel donde utilizaremos data para convertirlo al objeto, response para comprobar el status (200, 400, etc...) y error en caso de que lo haya nos dará una descripción de este
            completion(data, response, error)
        }
        //iniciamos la petición
        task.resume()
    }
    
    //MARK: - Public Methods
    
    // se comunica con la función requestApi, capa Provider
    func requestProvider(url: String, type: RequestType = .POST, params: [String: Any]? = nil, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) -> Void {
        
        // convertimos la url de tipo String a tipo URL
        let url = URL(string: url)
        
        //comprobamos que no sea nil, y nos guardamos la variable unwrapped como "urlNotNil", si es nil se sale de la func y no continua
        guard let urlNotNil = url else { return }
        
        // instanciamos el objecto URLRequest pasandole la url
        var request = URLRequest(url: urlNotNil)
        
        //le pasamos el type del enum pasado a String (recordemos que .rawvalue lo pasa de tipo RequestType a tipo String)
        request.httpMethod = type.rawValue
        
        // comprobamos que los params no son nulos, si no lo son los conververtimos Data con JSONSerialization y los se los pasamos a httpBody. Si fuesen nil no entraria dentro del bloque de código
        if let dictionary = params {
            let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
            request.httpBody = data
        }
        
        //añadimos los headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //llamamos a la función requestApi
        requestApi(request: request) { data, response, error in
            // Esta sentencia se utiliza porque las peticiones se hacen en background y los cambios que necesitaremos hacer en la View deberán ser obligatoriamente en el hilo principal (Main Thread)
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }
    }
    
}
