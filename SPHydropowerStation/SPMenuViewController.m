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
#import "SPProjDetailViewController.h"
#import "SPMenuItem.h"

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
    
//    NSArray* data = @[@{@"title":@"切换项目",@"icon":@"qhxm"},
//                      @{@"title":@"电站3D",@"icon":@"2"},
//                      @{@"title":@"项目监控",@"icon":@"1"},
//                      @{@"title":@"资源监控",@"icon":@"5"},
//                      @{@"title":@"混凝土监控",@"icon":@"6"},
//                      @{@"title":@"碾压监控",@"icon":@"4"},
//                      @{@"title":@"验收管理",@"icon":@"10"},
//                      @{@"title":@"视频监控",@"icon":@"7"},
//                      @{@"title":@"现场巡检",@"icon":@"8"},
//                      @{@"title":@"安全监测",@"icon":@"9"},
//                      @{@"title":@"档案管理",@"icon":@"dagl"},
//                      @{@"title":@"施工面貌",@"icon":@"sgmm"}];
    NSArray* data = @[@{@"title":@"切换项目",@"icon":@"qhxm"},
                      @{@"title":@"综合展示",@"icon":@"2"},
                      @{@"title":@"工程简介",@"icon":@"1"},
                      @{@"title":@"厂房3D",@"icon":@"5"},
                      @{@"title":@"资源监控",@"icon":@"6"},
                      @{@"title":@"混凝土监控",@"icon":@"6"},
                      @{@"title":@"大数据分析",@"icon":@"4"},
                      @{@"title":@"系统管理",@"icon":@"10"}];
    
    NSMutableArray* menuList = [NSMutableArray array];
    for (NSDictionary* item in data) {
        SPMenuItem* model = [SPMenuItem menuWithJSON:item];
        [menuList addObject:model];
    }
    self.data = [NSArray arrayWithArray:menuList];
    
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
    
    SPMenuItem* d = [self.data objectAtIndex:indexPath.row];
    cell.titleLabel.text = d.title;
    cell.coverImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",d.imageName]];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(((NSInteger)SCREEN_WIDTH - 10) / 4, ((NSInteger)SCREEN_WIDTH - 10) / 4 - 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else if(indexPath.row == 2){
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SPProjDetailViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"SPProjDetailViewController"];
        viewController.proj = self.proj;
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
    
    UDWebViewController *vc = [[UDWebViewController alloc] init];
    
    NSString* url = [NSString stringWithFormat:@"http://120.24.215.190:108/default.aspx?username=%@&projectid=%@&device=pad",[SPAPI sharedInstance].currentUser.account,self.proj.ProjID];
    
    if (indexPath.row == 5) {
        url = [NSString stringWithFormat:@"http://120.24.215.190:108/default.aspx?username=%@&projectid=%@&device=pad&menuid=huanningtujiankong",[SPAPI sharedInstance].currentUser.account,self.proj.ProjID];
    }
//    else if (indexPath.row == 7){
//        url = [NSString stringWithFormat:@"http://120.24.215.190:108/default.aspx?username=%@&projectid=%@&device=pad&menuid=shipinguanli",[SPAPI sharedInstance].currentUser.account,self.proj.ProjID];
//    }
    
    
    vc.url = url;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
