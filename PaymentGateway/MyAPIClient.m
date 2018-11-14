//
//  MyAPIClient.m
//  PaymentGateway
//
//  Created by Aaron Ang on 08/10/2018.
//  Copyright © 2018 AaronAng. All rights reserved.
//

#import "MyAPIClient.h"

@interface MyAPIClient ()

@property (strong, nonatomic) NSURL *baseURL;

@end

@implementation MyAPIClient


- (MyAPIClient *)myAPIClient {
    MyAPIClient *myAPIClient = [MyAPIClient sharedInstance];
    return myAPIClient;
}

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (AFHTTPSessionManager *)manager {
    static AFHTTPSessionManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    
    return manager;
}

- (NSURL *)baseURL {
    return [NSURL URLWithString: @"https://customintergation.herokuapp.com/"];
}

- (void)completeCharge:(STPPaymentResult *)result amount:(int)amount completionBlock:(STPErrorBlock)completionBlock {
    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"charge"];
    
    NSDictionary *metadataDict = [NSDictionary dictionaryWithObject:@"B3E611D1-5FA1-4410-9CEC-00958A5126CB" forKey:@"charge_request_id"];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"source"] = result.source.stripeID;
    params[@"amount"] = [NSNumber numberWithInt:amount];
    params[@"metadata"] = metadataDict;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager POST:url.absoluteString
       parameters:params
         progress:nil
          success:^(NSURLSessionDataTask *task, id responseObject) {
              NSLog(@"success");
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              completionBlock(error);
          }];
    
    //-------------
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    request.HTTPMethod = @"POST";
//    NSString *postBody = [NSString stringWithFormat:
//                          @"source=%@&amount=%d&metadata[charge_request_id]=%@",
//                          result.source.stripeID,
//                          amount,
//                          // example-ios-backend allows passing metadata through to Stripe
//                          @"B3E611D1-5FA1-4410-9CEC-00958A5126CB"
//                          ];
//    NSData *data = [postBody dataUsingEncoding:NSUTF8StringEncoding];

//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
//
//
//    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
//                                                               fromData:jsonData
//                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//                                                          if (!error && httpResponse.statusCode != 200) {
//                                                              error = [NSError errorWithDomain:StripeDomain
//                                                                                          code:STPInvalidRequestError
//                                                                                      userInfo:@{NSLocalizedDescriptionKey: @"There was an error connecting to your payment backend."}];
//                                                          }
//                                                          if (error) {
//                                                              completionBlock(error);
//                                                          }
//                                                      }];
//
//    [uploadTask resume];
    // ---------------
//    AFHTTPSessionManager *manager = [MyAPIClient manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
//    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//
//    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url.absoluteString parameters:nil error:nil];
//
//    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
//    [req setHTTPBody:jsonData];
//
//    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        if (!error) {
//
//        } else {
//            completionBlock(error);
//        }
//    }] resume];
}


- (void)createCustomerKeyWithAPIVersion:(NSString *)apiVersion completion:(STPJSONResponseCompletionBlock)completion {
    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"ephemeral_keys"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url.absoluteString
       parameters:@{@"api_version": apiVersion}
         progress:nil
          success:^(NSURLSessionDataTask *task, id responseObject) {
              completion(responseObject, nil);
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              completion(nil, error);
          }];
    
//    AFHTTPSessionManager *manager = [MyAPIClient manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
//    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//
//    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:ephemeralUrl parameters:@{@"api_version" : apiVersion} error:nil];
//
//    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSLog(@"%@", responseObject);
//
//        if (error) {
//            completion(nil, error);
//        } else {
//            completion(responseObject, nil);
//        }
//
//    }] resume];
    
}

@end
