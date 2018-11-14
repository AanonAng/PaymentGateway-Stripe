//
//  PayViewController.h
//  PaymentGateway
//
//  Created by Aaron Ang on 12/10/2018.
//  Copyright © 2018 AaronAng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, STPBackendResult) {
    STPBackendResultSuccess,
    STPBackendResultFailure,
};

typedef void (^STPSourceSubmissionHandler)(STPBackendResult status, NSError *error);
typedef void (^STPPaymentIntentCreationHandler)(STPBackendResult status, NSString *clientSecret, NSError *error);

@interface PayViewController : UIViewController

@property (copy, nonatomic)NSString *receiverAccount;
@property (copy, nonatomic)NSString *currency;
@property (assign, nonatomic)int price;

@end

NS_ASSUME_NONNULL_END
