//
//  CustomViewController.m
//  PaymentGateway
//
//  Created by Aaron Ang on 12/10/2018.
//  Copyright © 2018 AaronAng. All rights reserved.
//

#import "CustomViewController.h"
#import "PayViewController.h"

@interface CustomViewController ()
@property (weak, nonatomic) IBOutlet UITextField *receiverAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *currencyTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)PayButtonTapped:(UIButton *)sender {
    PayViewController *payVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayViewController"];
    payVC.receiverAccount = self.receiverAccountTextField.text;
    payVC.currency = self.currencyTextField.text;
    payVC.price = [self.priceTextField.text intValue];
    [self.navigationController pushViewController:payVC animated:YES];
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
