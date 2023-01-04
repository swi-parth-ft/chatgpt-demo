//
//  ApiCaller.swift
//  chatgpt demo
//
//  Created by Parth Antala on 2023-01-01.
//
import OpenAISwift
import Foundation

final class ApiCaller {
    static let shared = ApiCaller()
    
    @frozen enum Constants {
        static let key = "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"
    }
        private var client: OpenAISwift?
        private init() {}
        
        public func setup() {
            self.client = OpenAISwift (authToken: "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")
        }
        public func getResponse(input: String,
                                completion: @escaping (Result<String, Error>) -> Void) {
            client?.sendCompletion(with: input, model: .codex(.davinci), completionHandler: { result in
                switch result{
                case .success (let model):
                    let output = model.choices.first?.text ?? ""
                    completion(.success(output))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
}
