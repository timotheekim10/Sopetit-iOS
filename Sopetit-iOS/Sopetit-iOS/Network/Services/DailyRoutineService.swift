//
//  DailyRoutineService.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 2024/01/12.
//

import Foundation

import Alamofire

final class DailyRoutineService: BaseService {
    
    static let shared = DailyRoutineService()
    
    private override init() {}
}

extension DailyRoutineService {
    func getRoutineListAPI(completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = URLConstant.dailyURL
        let header: HTTPHeaders = NetworkConstant.hasTokenHeader
        let dataRequest = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                
                guard let data = response.data else {
                    completion(.networkFail)
                    return
                }

                let networkResult = self.judgeStatus(by: statusCode,
                                                     data,
                                                     DataClass.self)
                completion(networkResult)

            case .failure:
                completion(.networkFail)
            }
        }
    }
}
