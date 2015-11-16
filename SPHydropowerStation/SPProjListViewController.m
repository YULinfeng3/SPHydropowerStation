//
//  SPProjListViewController.m
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/11/11.
//  Copyright © 2015年 SP. All rights reserved.
//

#import "SPProjListViewController.h"
#import "SPAPI.h"
#import "SPProjCell.h"
#import "CATMessageView.h"
#import "SPProj.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MacroDefinition.h"
#import "SPMenuViewController.h"

@interface SPProjListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSArray* projList;

@end

@implementation SPProjListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadTableView];
    [self loadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SPMenuViewController"]) {
        SPMenuViewController* viewController = segue.destinationViewController;
        viewController.proj = sender;
    }
}

- (void)loadData{
    WS(weakSelf);
    [[SPAPI sharedInstance] projListWithSucceed:^(NSArray *projList) {
        weakSelf.projList = projList;
        [weakSelf.tableView reloadData];
    } failed:^(NSError *error) {
        [CATMessageView showWithMessage:@"获取项目失败"];
    }];
}

- (void)loadTableView{
    self.tableView.tableFooterView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    self.tableView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SPProjCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SPProjCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.projList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPProjCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SPProjCell"];
    
    SPProj* proj = self.projList[indexPath.row];
    [cell bindData:proj];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPProj* proj = self.projList[indexPath.row];
    return [tableView fd_heightForCellWithIdentifier:@"SPProjCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell bindData:proj];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SPProj* proj = self.projList[indexPath.row];
    [self performSegueWithIdentifier:@"SPMenuViewController" sender:proj];
}

@end
