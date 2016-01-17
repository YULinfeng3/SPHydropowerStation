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
#import "SPMenuSelectionViewController.h"

@interface SPMenuCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@end

@implementation SPMenuCell

@end

#pragma mark ----------

@interface SPMenuViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,retain) NSArray* originData;
@property (nonatomic,retain) NSArray* data;
@property (weak, nonatomic) IBOutlet UILabel *projTitleLabel;

@end

@implementation SPMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.projTitleLabel.text = self.proj.ProjName;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.originData = [SPAPI loadMenuItems];
    [self processData];
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

- (void)processData{
    // 过滤不显示的
    NSMutableArray* temp = [NSMutableArray array];
    for (SPMenuItem* item in self.originData) {
        if (item.show) {
            [temp addObject:item];
        }
    }
    self.data = [NSArray arrayWithArray:temp];
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SPMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SPMenuCell" forIndexPath:indexPath];
    
    if (indexPath.row == self.data.count) {
        // 最后一个
        cell.titleLabel.text = @"";
        cell.coverImageView.image = [UIImage imageNamed:@"add"];
        return cell;
    }
    
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
    
    if (indexPath.row == self.data.count) {
        // 最后一个
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SPMenuSelectionViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"SPMenuSelectionViewController"];
        viewController.menuList = self.originData;
        WS(weakSelf);
        [viewController setMenuEditCompletion:^(NSArray *menuItems) {
            weakSelf.originData = menuItems;
            [weakSelf processData];
        }];
        [self.navigationController pushViewController:viewController animated:YES];
        
        return;
    }
    
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
    
    SPMenuItem* item = [self.data objectAtIndex:indexPath.row];
    NSString* url = [NSString stringWithFormat:@"http://120.24.215.190:108/default.aspx?username=%@&projectid=%@&device=pad",[SPAPI sharedInstance].currentUser.account,self.proj.ProjID];
    
    if ([item.title isEqualToString:@"混凝土监控"]) {
        url = [NSString stringWithFormat:@"http://120.24.215.190:108/default.aspx?username=%@&projectid=%@&device=pad&menuid=huanningtujiankong",[SPAPI sharedInstance].currentUser.account,self.proj.ProjID];
    }else if ([item.title isEqualToString:@"视频监控"]) {
        url = [NSString stringWithFormat:@"http://120.24.215.190:108/default.aspx?username=%@&projectid=%@&device=pad&menuid=shipinguanli",[SPAPI sharedInstance].currentUser.account,self.proj.ProjID];
    }else if ([item.title isEqualToString:@"综合展示"]){
        url = [NSString stringWithFormat:@"http://120.24.215.190:108/default.aspx?username=%@&projectid=%@&device=pad&menuid=zonghezhanshi",[SPAPI sharedInstance].currentUser.account,self.proj.ProjID];
    }else if ([item.title isEqualToString:@"大数据分析"]){
        url = [NSString stringWithFormat:@"http://120.24.215.190:108/default.aspx?username=%@&projectid=%@&device=pad&menuid=dsjfx",[SPAPI sharedInstance].currentUser.account,self.proj.ProjID];
    }else if ([item.title isEqualToString:@"资源监控"]){
        url = [NSString stringWithFormat:@"http://120.24.215.190:108/default.aspx?username=%@&projectid=%@&device=pad&menuid=ziyuanjiankong",[SPAPI sharedInstance].currentUser.account,self.proj.ProjID];
    }
    
    
    vc.url = url;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
