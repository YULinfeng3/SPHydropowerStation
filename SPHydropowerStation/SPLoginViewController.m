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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation SPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard noti

- (void)keyboardWillShow:(NSNotification *)Notification
{
    WS(weakSelf);
    static CGFloat lastHeight;
    NSDictionary *userInfo = [Notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;

    self.top.constant = -120;
    [UIView animateWithDuration:0.2 delay:0. options:UIViewAnimationOptionCurveLinear animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHide:(NSNotification *)Notification
{
    WS(weakSelf);
    self.top.constant = 30;
    [UIView animateWithDuration:0.2 delay:0. options:UIViewAnimationOptionCurveLinear animations:^{
        
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
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
