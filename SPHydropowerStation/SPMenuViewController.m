//
//  SPMenuViewController.m
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/11/11.
//  Copyright © 2015年 SP. All rights reserved.
//

#import "SPMenuViewController.h"
#import "MacroDefinition.h"
#import "UDWebViewController.h"
#import "SPAPI.h"

@interface SPMenuCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@end

@implementation SPMenuCell

@end

#pragma mark ----------

@interface SPMenuViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,retain) NSArray* data;
@property (weak, nonatomic) IBOutlet UILabel *projTitleLabel;

@end

@implementation SPMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.data = @[@{@"title":@"综合展示",@"icon":@"1"},
                  @{@"title":@"过程管理",@"icon":@"2"},
                  @{@"title":@"进度管理",@"icon":@"3"},
                  @{@"title":@"安全监测",@"icon":@"4"},
                  @{@"title":@"安全巡查",@"icon":@"5"},
                  @{@"title":@"资源监控",@"icon":@"6"},
                  @{@"title":@"指标分析",@"icon":@"7"},
                  @{@"title":@"混凝土监控",@"icon":@"8"},
                  @{@"title":@"视频管理",@"icon":@"9"},
                  @{@"title":@"系统管理",@"icon":@"10"}];
    
    self.projTitleLabel.text = self.proj.ProjName;
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SPMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SPMenuCell" forIndexPath:indexPath];
    
    NSDictionary* d = [self.data objectAtIndex:indexPath.row];
    cell.titleLabel.text = d[@"title"];
    cell.coverImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",d[@"icon"]]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(((NSInteger)SCREEN_WIDTH - 6) / 3, ((NSInteger)SCREEN_WIDTH - 6) / 3);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UDWebViewController *vc = [[UDWebViewController alloc] init];
    
    NSString* url = [NSString stringWithFormat:@"http://120.24.215.190:108/default.aspx?username=%@&projectid=%@&device=pad",[SPAPI sharedInstance].currentUser.account,self.proj.ProjID];
    vc.url = url;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
