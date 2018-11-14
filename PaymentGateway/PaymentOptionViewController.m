//
//  PaymentOptionViewController.m
//  PaymentGateway
//
//  Created by Aaron Ang on 12/10/2018.
//  Copyright © 2018 AaronAng. All rights reserved.
//

#import "PaymentOptionViewController.h"
#import "PaymentOptionCell.h"
#import "ViewController.h"
#import "CustomViewController.h"

@interface PaymentOptionViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PaymentOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PaymentOptionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PaymentOptionCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell updateDisplay:@"Standard Integration"];
    } else {
        [cell updateDisplay:@"Custom Integration"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ViewController *standardVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        [self.navigationController pushViewController:standardVC animated:YES];
    } else {
        CustomViewController *standardVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomViewController"];
        [self.navigationController pushViewController:standardVC animated:YES];
    }
}


@end
