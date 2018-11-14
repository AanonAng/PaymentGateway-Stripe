//
//  ViewController.h
//  PaymentGateway
//
//  Created by Aaron Ang on 04/10/2018.
//  Copyright © 2018 AaronAng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Stripe/STPPaymentContext.h>
#import "MyAPIClient.h"

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, STPPaymentContextDelegate>

@end

