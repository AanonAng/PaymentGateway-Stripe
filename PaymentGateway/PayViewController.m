//
//  PayViewController.m
//  PaymentGateway
//
//  Created by Aaron Ang on 12/10/2018.
//  Copyright © 2018 AaronAng. All rights reserved.
//

#import "PayViewController.h"
#import <Stripe/Stripe.h>
#import "Constant.h"

@interface PayViewController () <STPPaymentCardTextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) STPPaymentCardTextField *paymentTextField;
@property (weak, nonatomic) UIScrollView *scrollView;

@end

@implementation PayViewController

- (void)loadView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.delegate = self;
    scrollView.alwaysBounceVertical = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view = scrollView;
    self.scrollView = scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Do any additional setup after loading the view.
    UIBarButtonItem *buyButton = [[UIBarButtonItem alloc] initWithTitle:@"Pay" style:UIBarButtonItemStyleDone target:self action:@selector(pay)];
    buyButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = buyButton;
    
    STPPaymentCardTextField *paymentTextField = [[STPPaymentCardTextField alloc] init];
    paymentTextField.delegate = self;
    paymentTextField.cursorColor = [UIColor purpleColor];
    self.paymentTextField = paymentTextField;
    [self.view addSubview:paymentTextField];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat padding = 15;
    CGFloat width = CGRectGetWidth(self.view.frame) - (padding*2);
    self.paymentTextField.frame = CGRectMake(padding, padding, width, 44);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.paymentTextField becomeFirstResponder];
}

- (void)paymentCardTextFieldDidChange:(nonnull STPPaymentCardTextField *)textField {
    self.navigationItem.rightBarButtonItem.enabled = textField.isValid;
}

- (void)pay {
    if (![self.paymentTextField isValid]) {
        return;
    }
    if (![Stripe defaultPublishableKey]) {
        [self showAlert:@"Please set a Stripe Publishable Key in Constants.m"];
        return;
    }
    [[STPAPIClient sharedClient] createTokenWithCard:self.paymentTextField.cardParams
                                          completion:^(STPToken *token, NSError *error) {
                                              if (error) {
                                                  [self showAlert:error.localizedDescription];
                                              }
                                              [self createBackendChargeWithSource:token.tokenId completion:^(STPBackendResult result, NSError *error) {
                                                  if (error) {
                                                      [self showAlert:error.localizedDescription];
                                                      return;
                                                  }
                                                  [self showAlert:@"Payment successfully created"];
                                              }];
                                          }];
}

- (void)createBackendChargeWithSource:(NSString *)sourceID completion:(STPSourceSubmissionHandler)completion {
    if (!BackendBaseURL) {
        NSError *error = [NSError errorWithDomain:StripeDomain
                                             code:STPInvalidRequestError
                                         userInfo:@{NSLocalizedDescriptionKey: @"You must set a backend base URL in Constants.m to create a charge."}];
        completion(STPBackendResultFailure, error);
        return;
    }
    
    // This passes the token off to our payment backend, which will then actually complete charging the card using your Stripe account's secret key
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
//    NSString *urlString = [BackendBaseURL stringByAppendingPathComponent:@"create_charge"];
    NSString *urlString = @"http://stripe.michaelangelo.ninja/charge";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
//    NSString *postBody = [NSString stringWithFormat:
//                          @"source=%@&amount=%@&currency=%@",
//                          sourceID,
//                          @1199,
//                          // example-ios-backend allows passing metadata through to Stripe
//                          @"MYR"];
    NSString *postBody = [NSString stringWithFormat:
                          @"source=%@&amount=%@&currency=%@&description=%@",
                          sourceID,
                          @3399,
                          // example-ios-backend allows passing metadata through to Stripe
                          @"usd",@"iOS Testing usd"];
    // &metadata[charge_request_id]=%@
    // @"B3E611D1-5FA1-4410-9CEC-00958A5126CB"
    //&description=%@
    //,
//    @"iOS Testing"
    NSData *data = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                               fromData:data
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                          NSLog(@"error %@", error.localizedDescription);
                                                          if (!error && httpResponse.statusCode != 200) {
                                                              error = [NSError errorWithDomain:StripeDomain
                                                                                          code:STPInvalidRequestError
                                                                                      userInfo:@{NSLocalizedDescriptionKey: @"There was an error connecting to your payment backend."}];
                                                          }
                                                          if (error) {
                                                              completion(STPBackendResultFailure, error);
                                                          }
                                                          else {
                                                              completion(STPBackendResultSuccess, error);
                                                          }
                                                      }];
    
    [uploadTask resume];
}

- (void)showAlert:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
