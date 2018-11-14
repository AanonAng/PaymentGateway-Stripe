//
//  ViewController.m
//  PaymentGateway
//
//  Created by Aaron Ang on 04/10/2018.
//  Copyright © 2018 AaronAng. All rights reserved.
//

#import "ViewController.h"
#import "PaymentGateway-Swift.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *currencyTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (strong, nonatomic) NSMutableArray *currencies;
@property (strong, nonatomic) STPCustomerContext *customerContext;
@property (strong, nonatomic) STPPaymentContext *paymentContext;

@end

@implementation ViewController

//- (instancetype)init {
//    self = [super initWithNibName:nil bundle:nil];
//    if (self) {
//        self.customerContext = [[STPCustomerContext alloc] initWithKeyProvider: [MyAPIClient sharedInstance]];
//        self.paymentContext = [[STPPaymentContext alloc] initWithCustomerContext:self.customerContext];
//        self.paymentContext.delegate = self;
//        self.paymentContext.hostViewController = self;
//        self.paymentContext.paymentAmount = 5000;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currencies = [NSMutableArray arrayWithObjects:@"USD", @"GBP", nil];
    [self setPickerViewToCurrencyTextField];
    self.currencyTextField.text = self.currencies[1];
//    [self setupPaymentContext];
}

- (void)setupPaymentContext {
    SwiftMyAPIClient *api = [SwiftMyAPIClient sharedClient];
    api.currency = self.currencyTextField.text;
    
    STPPaymentConfiguration *config = [STPPaymentConfiguration sharedConfiguration];
    if ([self.currencyTextField.text isEqualToString:self.currencies[0]]) {
        [config setPublishableKey:@"pk_test_zIznPBsAy9rNywuiE6ScYDhY"];
    } else {
        [config setPublishableKey:@"pk_test_WpBej2TUPXgqUclBxlupbMRP"];
    }

    [config setCreateCardSources:YES];
    
    self.customerContext = [[STPCustomerContext alloc] initWithKeyProvider: [SwiftMyAPIClient sharedClient]];
    STPPaymentContext *paymentContext = [[STPPaymentContext alloc] initWithCustomerContext:self.customerContext configuration:config theme:STPTheme.defaultTheme];
    
    STPUserInformation *userInformation = [[STPUserInformation alloc] init];
    paymentContext.prefilledInformation = userInformation;
    paymentContext.paymentCurrency = @"GBP";
    
    if (self.priceTextField.text.length != 0) {
        paymentContext.paymentAmount = [self.priceTextField.text intValue];
    }
//    if (self.currencyTextField.text.length != 0) {
//        paymentContext.paymentCurrency = self.currencyTextField.text;
//    }
    
//        paymentContext.paymentAmount = 300;
//        paymentContext.paymentCurrency = @"GBP";
    
    self.paymentContext = paymentContext;
    self.paymentContext.delegate = self;
    paymentContext.hostViewController = self;
}

- (void)setPickerViewToCurrencyTextField {
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    [self.currencyTextField setInputView:picker];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.currencies.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.currencies[row];
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.currencyTextField resignFirstResponder];
    self.currencyTextField.text = self.currencies[row];
}


#pragma mark - STPPaymentContextDelegate

- (void)paymentContext:(STPPaymentContext *)paymentContext didCreatePaymentResult:(STPPaymentResult *)paymentResult completion:(STPErrorBlock)completion {
    [[SwiftMyAPIClient sharedClient] completeCharge:paymentResult amount:(int)self.paymentContext.paymentAmount completion:completion];
//    [[MyAPIClient sharedInstance] completeCharge:paymentResult amount:(int)self.paymentContext.paymentAmount completionBlock:completion];
}

- (void)paymentContext:(STPPaymentContext *)paymentContext
   didFinishWithStatus:(STPPaymentStatus)status
                 error:(NSError *)error {
    switch (status) {
        case STPPaymentStatusSuccess:
            //            [self showReceipt];
            NSLog(@"didFinishWithStatus Success");
        case STPPaymentStatusError:
            //            [self showError:error];
            NSLog(@"didFinishWithStatus Failed: %@", error);
        case STPPaymentStatusUserCancellation:
            return; // Do nothing
    }
}

-(void)paymentContextDidChange:(STPPaymentContext *)paymentContext {
//    self.activityIndicator.animating = paymentContext.loading;
//    self.paymentButton.enabled = paymentContext.selectedPaymentMethod != nil;
//    self.paymentLabel.text = paymentContext.selectedPaymentMethod.label;
//    self.paymentIcon.image = paymentContext.selectedPaymentMethod.image;
}

- (void)paymentContext:(STPPaymentContext *)paymentContext didFailToLoadWithError:(NSError *)error {
    NSLog(@"didFailToLoadWithError Failed: %@", error);
}

//- (void)paymentContext:(STPPaymentContext *)paymentContext
//    didUpdateShippingAddress:(STPAddress *)address
//                  completion:(STPShippingMethodsCompletionBlock)completion {
//    PKShippingMethod *upsGround = [PKShippingMethod new];
//    upsGround.label = @"UPS Ground";
//    upsGround.detail = @"Arrives in 3-5 days";
//    upsGround.identifier = @"ups_ground";
//    PKShippingMethod *fedEx = [PKShippingMethod new];
//    fedEx.amount = [NSDecimalNumber decimalNumberWithString:@"5.99"];
//    fedEx.label = @"FedEx";
//    fedEx.detail = @"Arrives tomorrow";
//    fedEx.identifier = @"fedex";
//    if ([address.country isEqualToString:@"US"]) {
//        completion(STPShippingStatusValid, nil, @[upsGround, fedEx], upsGround);
//    }
//    else {
//        completion(STPShippingStatusInvalid, nil, nil, nil);
//    }
//}

#pragma mark - Action

- (IBAction)choosePaymentMethodButtonTapped:(UIButton *)sender {
    [self setupPaymentContext];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.paymentContext pushPaymentMethodsViewController];
    });
//    [self.paymentContext pushPaymentMethodsViewController];
}

- (IBAction)payButtonTapped:(UIButton *)sender {
    [self.paymentContext requestPayment];
}

@end
