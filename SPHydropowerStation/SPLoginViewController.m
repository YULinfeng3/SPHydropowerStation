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
#import "SPMenuViewController.h"
#import "SPProjListViewController.h"
#import "SPAppInfo.h"
#import "CATAlertView.h"

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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[SPAPI sharedInstance] appInfoSucceed:^(SPAppInfo *info) {
        if (![info.version isEqualToString:[SPAPI sharedInstance].appVersion]) {
            // 提示
            NSMutableString* msg = [NSMutableString string];
            for (NSString* item in info.updatedescribe) {
                [msg appendFormat:@"%@\n",item];
            }
            [msg appendFormat:@"下载地址：%@",info.apppath];
            NSString* title = [NSString stringWithFormat:@"有新版本 (v%@)",info.version];
            
            CATAlertView *alert = [[CATAlertView alloc] initWithTitle:title Message:msg Hidden:NO touchBlock:^(id sender, NSInteger index) {
                if (index == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:info.apppath]];
                }
            } cancelButtonTitle:@"取消" andButtonsTitles:@"去下载", nil];
            [alert show];

        }
        
        [SPAPI sharedInstance].appVersion = info.version;
    } failed:^(NSError *error) {
    }];
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
        
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SPProjListViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"SPProjListViewController"];
        
        if ([SPAPI sharedInstance].currentUser.defaultProj) {
            viewController.proj = [SPAPI sharedInstance].currentUser.defaultProj;
            [weakSelf.navigationController pushViewController:viewController animated:NO];
        }else{
            [weakSelf.navigationController pushViewController:viewController animated:YES];
        }
//        [weakSelf performSegueWithIdentifier:@"SPProjListViewController" sender:nil];
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CATMessageView showWithMessage:@"登录失败"];
    }];
}

@end
