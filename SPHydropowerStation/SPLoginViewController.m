//
//  SPLoginViewController.m
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/11/11.
//  Copyright © 2015年 SP. All rights reserved.
//

#import "SPLoginViewController.h"
#import "SPAPI.h"
#import "MBProgressHUD.h"
#import "CATMessageView.h"
#import "MacroDefinition.h"

@interface SPLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation SPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UI Action

- (IBAction)onLogin:(id)sender {
    NSString* username = self.usernameField.text;
    NSString* password = self.passwordField.text;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WS(weakSelf);
    [[SPAPI sharedInstance] loginWithUsername:username password:password succeed:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf performSegueWithIdentifier:@"SPProjListViewController" sender:nil];
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CATMessageView showWithMessage:@"登录失败"];
    }];
}

@end
