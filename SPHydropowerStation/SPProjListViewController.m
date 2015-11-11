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

@interface SPProjListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSArray* projList;

@end

@implementation SPProjListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self loadTableView];
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

- (void)loadData{
    [[SPAPI sharedInstance] projListWithSucceed:^(NSArray *projList) {
        self.projList = projList;
    } failed:^(NSError *error) {
        [CATMessageView showWithMessage:@"获取项目失败"];
    }];
}

- (void)loadTableView{
    [self.tableView registerNib:[UINib nibWithNibName:@"SPProjCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SPProjCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.projList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPProjCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SPProjCell"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

@end
