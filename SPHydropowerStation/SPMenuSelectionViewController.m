//
//  SPMenuSelectionViewController.m
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/12/8.
//  Copyright © 2015年 SP. All rights reserved.
//

#import "SPMenuSelectionViewController.h"
#import "SPMenuItem.h"
#import "SPAPI.h"

@interface SPMenuSelectionViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPMenuSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView = [UIView new];
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

#pragma mark - Util

- (void)loadData{
    
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSubmit:(id)sender {
    // 保存
    [SPAPI saveMenuItems:self.menuList];
    if (self.menuEditCompletion) {
        self.menuEditCompletion(self.menuList);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MenuSelectionCell"];
    
    SPMenuItem* d = [self.menuList objectAtIndex:indexPath.row];
    cell.textLabel.text = d.title;
    
    UIImage* image = [UIImage imageNamed:d.imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.imageView.image = image;
//    cell.imageView.backgroundColor = [UIColor blueColor];
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (d.show) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        return;
    }
    
    SPMenuItem* d = [self.menuList objectAtIndex:indexPath.row];
    d.show = !d.show;
    [self.tableView reloadData];
}

@end
