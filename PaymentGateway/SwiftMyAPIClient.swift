//
//  SwiftMyAPIClient.swift
//  PaymentGateway
//
//  Created by Aaron Ang on 10/10/2018.
//  Copyright © 2018 AaronAng. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

@objc class SwiftMyAPIClient: NSObject, STPEphemeralKeyProvider {
    
    @objc static let sharedClient = SwiftMyAPIClient()
    var baseURL: URL = URL(string: "https://customintergation.herokuapp.com/")!
    @objc var currency: String = ""
    
    @objc func completeCharge(_ result: STPPaymentResult,
                        amount: Int,
                        completion: @escaping STPErrorBlock) {
        let url = self.baseURL.appendingPathComponent("charge")
        let params: [String: Any] = [
            "source": result.source.stripeID,
//            "currency":"MYR",
            "amount": amount,
            "metadata": [
                // example-ios-backend allows passing metadata through to Stripe
                "charge_request_id": "B3E611D1-5FA1-4410-9CEC-00958A5126CB",
            ],
            ]
        //        params["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod)
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
        }
    }
    
    @objc func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        if self.currency == "USD" {
            self.baseURL = URL(string: "https://customintergation.herokuapp.com/")!
        } else {
            self.baseURL = URL(string: "https://customintergrate-uk.herokuapp.com/")!
        }
        let url = self.baseURL.appendingPathComponent("ephemeral_keys")
        Alamofire.request(url, method: .post, parameters: [
            "api_version": apiVersion,
            ])
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
}
