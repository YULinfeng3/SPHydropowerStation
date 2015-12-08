//
//  SPImageDetailViewController.m
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/12/8.
//  Copyright © 2015年 SP. All rights reserved.
//

#import "SPImageDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SPImageDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SPImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
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

#pragma mark - UI Actions

- (IBAction)onBack:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
