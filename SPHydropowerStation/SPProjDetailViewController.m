//
//  SPProjDetailViewController.m
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/12/8.
//  Copyright © 2015年 SP. All rights reserved.
//

#import "SPProjDetailViewController.h"
#import "MacroDefinition.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SPAPI.h"
#import "CATMessageView.h"
#import "SPImageDetailViewController.h"

@interface SPImageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView* imageView;

@end

@implementation SPImageCell

- (void)awakeFromNib{
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

@end

#pragma mark ----------

@interface SPProjDetailViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel* projNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* districtLabel;
@property (weak, nonatomic) IBOutlet UILabel* typeLabel;
@property (weak, nonatomic) IBOutlet UILabel* introductionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SPProjDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureUI];
    
    if (!self.proj.imageList) {
        [self loadData];
    }
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

#pragma mark -

- (void)configureUI{
    self.topView.layer.cornerRadius = 5;
    self.topView.layer.borderWidth = 1;
    self.topView.layer.borderColor = RGBACOLOR(155, 155, 155, 1).CGColor;
    
    self.bottomView.layer.cornerRadius = 5;
    self.bottomView.layer.borderWidth = 1;
    self.bottomView.layer.borderColor = RGBACOLOR(155, 155, 155, 1).CGColor;
    
    self.projNameLabel.text = self.proj.ProjName;
    self.districtLabel.text = self.proj.District;
    self.typeLabel.text = self.proj.ProjType;
    self.introductionLabel.text = self.proj.Introduction;
}

- (void)loadData{
    WS(weakSelf);
    [[SPAPI sharedInstance] getProjImagesWithId:self.proj.ProjID succeed:^(NSArray* imageList){
        weakSelf.proj.imageList = imageList;
        [weakSelf.collectionView reloadData];
    } failed:^(NSError *error) {
        [CATMessageView showWithMessage:@"获取照片失败"];
    }];
}

#pragma mark - UI Actions

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.proj.imageList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SPImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SPImageCell" forIndexPath:indexPath];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.proj.imageList[indexPath.row]]];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(((NSInteger)SCREEN_WIDTH - 80) / 3, ((NSInteger)SCREEN_WIDTH - 80) / 3 - 40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SPImageDetailViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"SPImageDetailViewController"];
    viewController.imageUrl = self.proj.imageList[indexPath.row];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
