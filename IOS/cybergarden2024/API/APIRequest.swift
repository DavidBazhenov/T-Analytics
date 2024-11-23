//
//  APIRequest.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.11.2024.
//

import Alamofire
import RxSwift
import Alamofire
import RxSwift

protocol APIRequest {
    var httpMethod: HTTPMethod { get }
    var encoding: ParameterEncoding? { get }
    var requestURL: String { get }
    var parameters: [String: Any]? { get }
}

extension APIRequest {
    var encoding: ParameterEncoding? {
        return nil
    }

    func request(headers: HTTPHeaders = APIConfiguration.headers) -> Observable<Result<[String: Any]?, Error>>{
        return Observable.create { observer in
            let encoding: ParameterEncoding = self.encoding ?? (self.httpMethod == .get ? URLEncoding.default : JSONEncoding.default)

            let request = AF.request(
                self.requestURL,
                method: self.httpMethod,
                parameters: self.parameters,
                encoding: encoding,
                headers: headers
            )

            request.responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let success = json["success"] as? Bool {
                            if success {
                                let responseData = json["data"] as? [String: Any]
                                observer.onNext(.success(responseData))
                            } else if let error = json["error"] as? String{
                                observer.onNext(.failure(NSError.getErrorWithDescription(error)))
                            } else {
                                observer.onNext(.failure(NSError.getErrorWithDescription("Unknown response format")))
                            }
                        } else {
                            observer.onNext(.failure(NSError.getErrorWithDescription("Failed to parse response")))
                        }
                    } catch {
                        observer.onNext(.failure(NSError.getErrorWithDescription("Error decoding response: \(error.localizedDescription)")))
                    }
                case .failure(let error):
                    observer.onNext(.failure(NSError.getErrorWithDescription(error.localizedDescription)))
                }
                observer.onCompleted()
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
}
