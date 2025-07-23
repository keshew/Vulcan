import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    let baseURL = "https://volcanoreacher.site/app.php"

    struct APIResponse<T: Decodable>: Decodable {
        let success: String?
        let error: String?
        let message: String?
        let user_id: String?
        let user: T?
    }

    // MARK: - Регистрация
    func register(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let params: [String: Any] = [
            "method": "register",
            "email": email,
            "password": password
        ]

        request(params: params) { (result: Result<APIResponse<User>, Error>) in
            switch result {
            case .success(let response):
                if let userId = response.user_id {
                    completion(.success(userId))
                } else if let errorMsg = response.error {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : errorMsg])))
                } else {
                    completion(.failure(NSError(domain:"", code:0, userInfo: [NSLocalizedDescriptionKey : "Unknown error"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Логин
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let params: [String: Any] = [
            "method": "login",
            "email": email,
            "password": password
        ]

        request(params: params) { (result: Result<APIResponse<User>, Error>) in
            switch result {
            case .success(let response):
                if let user = response.user {
                    completion(.success(user))
                } else if let errorMsg = response.error {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : errorMsg])))
                } else {
                    completion(.failure(NSError(domain:"", code:0, userInfo: [NSLocalizedDescriptionKey : "Unknown error"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Удаление аккаунта
    func deleteAccount(userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let params: [String: Any] = [
            "method": "delete",
            "user_id": userId
        ]
        

        request(params: params) { (result: Result<APIResponse<User>, Error>) in
            switch result {
            case .success(let response):
                if let message = response.message {
                    completion(.success(message))
                } else if response.success != nil {
                    completion(.success("Account deleted"))
                } else if let errorMsg = response.error {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : errorMsg])))
                } else {
                    completion(.failure(NSError(domain:"", code:0, userInfo: [NSLocalizedDescriptionKey : "Unknown error"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Универсальный запрос
    private func request<T: Decodable>(params: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain:"", code:0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let body = try JSONSerialization.data(withJSONObject: params, options: [])
            urlRequest.httpBody = body
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(NSError(domain:"", code:0, userInfo: [NSLocalizedDescriptionKey: "No data"]))) }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
}

// MARK: - User модель, соответствующая JSON из API
struct User: Decodable {
    let user_id: String
    let email: String
    // Другие поля если есть
}
