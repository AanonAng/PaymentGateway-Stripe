//
//  MyAPIClient.h
//  PaymentGateway
//
//  Created by Aaron Ang on 08/10/2018.
//  Copyright © 2018 AaronAng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <Stripe/Stripe.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAPIClient : NSObject <STPEphemeralKeyProvider>

+ (instancetype)sharedInstance;

- (void)completeCharge:(STPPaymentResult *)result amount:(int)amount completionBlock:(void (^)(NSError *))completionBlock;

@end

NS_ASSUME_NONNULL_END
