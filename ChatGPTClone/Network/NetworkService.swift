import Foundation

class NetworkService {
    static let shared = NetworkService()

    private let model = "gpt-3.5-turbo"

    private let apiKey = ""
    private let baseURL = "https://api.openai.com/v1/chat/completions"

    func getChatCompletion(messages: [Message],completion: @escaping (Result<String, Error>) -> Void) {
      
        let messageDictArray = messages.map { $0.asDictionary() }

        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "NetworkServiceError", code: 1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"//HTTP RESTapi
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")//auth type Bearer
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")//Headers added


        let requestBody: [String: Any] =  [
            "model": model,
            "messages": messageDictArray,
            "temperature": 0
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
            
                        guard let data = data else {
                            completion(.failure(NSError(domain: "NetworkServiceError", code: 2, userInfo: nil)))
                            return
                        }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                if let choices = json?["choices"] as? [[String: Any]],
                   let assistantResponse = choices.first?["message"] as? [String: Any],
                   let content = assistantResponse["content"] as? String,
                   let role = assistantResponse["role"] as? String {
               
                    let assistantMessage = Message(role: role, content: content)
                    completion(.success("\(assistantMessage.content)"))
                    
                } else {
                    completion(.failure(NSError(domain: "NetworkServiceError", code: 3, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
