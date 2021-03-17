import Foundation

enum CarError{
    
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case InvalidJSON
}
enum RESTOperation {
    case save
    case update
    case delete
}

class REST {
    
    private static let basePath = "https://605119cd53460900176712ec.mockapi.io/carangas"
    
    /*
     basePath é a URL padão da nossa API
     
     configuration é a configuração da sessão,
     a config é o que usamos para usar os metodos de configuração
     .default é o tipo padrao de configuração
     
     allowsCellularAccess é se da pra usar dados moveis para acessar
     httpAditionalHeaders é o que vem de nome do cabeçalho
     timeoutIntervalForRequest é o temo maximo de requisiç ao antes de dar erro
     httpMaximumConnectionsPerHost maximo de conexao, como downloads e coisas assim
     */
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["Content-Type":"application/json" ]
        config.timeoutIntervalForRequest = 30.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    
    private static let session = URLSession(configuration: configuration )
    
    class func loadBrands(onComplete: @escaping ([Brand]?) -> Void) {
        
        guard let url = URL(string: "https://fipeapi.appspot.com/api/1/carros/marcas.json" ) else {
            onComplete(nil)
            
            return
        }
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error == nil{
                
                guard let response = response as? HTTPURLResponse else {
                    onComplete(nil)
                    return}
                if response.statusCode == 200{
                    
                    guard let data = data else {
                        
                        return}
                    do{
                        let brands = try JSONDecoder().decode([Brand].self, from: data)
                        onComplete(brands)
                        
                        
                    }catch{
                        print("Salve primo")
                        onComplete(nil)                    }
                    
                }else{
                    print("Algum status inválido pelo servidor!!")
                    onComplete(nil)
                }
            }else{
                
                onComplete(nil)
            }
        }
        dataTask.resume()
        
    }
    
    
    class func loadCars(onComplete: @escaping ([Cars]) -> Void, onError: @escaping (CarError) -> Void){
        
        guard let url = URL(string: basePath) else {
            onError(.url)
            
            return
        }
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error == nil{
                
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return}
                if response.statusCode == 200{
                    
                    guard let data = data else {
                        
                        return}
                    do{
                        let cars = try JSONDecoder().decode([Cars].self, from: data)
                        onComplete(cars)
                        
                        
                    }catch{
                        print("Salve primo")
                        onError(.InvalidJSON)
                    }
                    
                }else{
                    print("Algum status inválido pelo servidor!!")
                    onError(.responseStatusCode(code: response.statusCode))
                }
            }else{
                
                onError(.taskError(error: error!))
            }
        }
        dataTask.resume()
        
    }
    
    //Metodo post agora. para poder postar um carro novo
    
    class func save(car: Cars, onComplete: @escaping (Bool) -> Void){
        applyOperation(car: car, operation: .save, onComplete: onComplete)
    }
    
    class func update(car: Cars, onComplete: @escaping (Bool) -> Void){
        applyOperation(car: car, operation: .update, onComplete: onComplete)
    }
    
    class func delete(car: Cars, onComplete: @escaping (Bool) -> Void){
        applyOperation(car: car, operation: .delete, onComplete: onComplete)
    }
    
    private class func applyOperation(car: Cars, operation: RESTOperation, onComplete: @escaping (Bool) -> Void){
      
        let urlString = basePath + "/" + (car._id ?? "")
        print(urlString)
        guard let url = URL(string: urlString ) else {
            onComplete(false)
            
            return
        }
        var request = URLRequest(url: url)
        var httpMethod: String = ""
        
        switch operation{
        case .save:
            httpMethod = "POST"
        case .update:
            httpMethod = "PUT"
        case .delete:
            httpMethod = "DELETE"
        }
        request.httpMethod = httpMethod
        
        guard let json = try? JSONEncoder().encode(car) else{
            onComplete(false)
            
            return
        }
        request.httpBody = json
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil{
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else{
                    onComplete(false)
                    return
                }
                onComplete(true)
            }
            else{
                
                onComplete(false)
                
            }
        }
        dataTask.resume()
    }
        
    
    
}


