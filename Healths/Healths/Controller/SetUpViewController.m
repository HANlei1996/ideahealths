//
//  SetUpViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "SetUpViewController.h"
#import "SetUpTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface SetUpViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *setupImage;
@property (weak, nonatomic) IBOutlet UIButton *modificationBtn;
- (IBAction)modBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITableView *SetUpTableView;
@property (strong, nonatomic) NSArray *setupArr;
@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _setupArr = @[@{@"nicknameLabel":@"昵称",@"infoLabel":@"阿凡达"},@{@"nicknameLabel":@"性别",@"infoLabel":@"男"},@{@"nicknameLabel":@"生日",@"infoLabel":@"2046-12-25"},@{@"nicknameLabel":@"身份证号码",@"infoLabel":@"320203204612256666"}];
    _SetUpTableView.tableFooterView = [UIView new];
    
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
//设置表格视图一共有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _setupArr.count;
}


//设置表格视图中每一组由多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetUpTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SetUpTableViewCell" forIndexPath:indexPath];
    NSDictionary *dict = _setupArr[indexPath.section];
    cell.nicknameLabel.text=dict[@"nicknameLabel"];
    cell.infoLabel.text = dict[@"infoLabel"];
    return cell;
}
//设置组的底部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5.f;
    }
    return 1.f;
}
//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}
//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消细胞的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
        switch (indexPath.section) {
            case 0:
                [self performSegueWithIdentifier:@"SetUpToNC" sender:self];
                break;
            case 1:
                [self performSegueWithIdentifier:@"SetUpToXB" sender:self];
                break;
            case 2:
                [self performSegueWithIdentifier:@"SetUpToSR" sender:self];
                break;
                        default:
                [self performSegueWithIdentifier:@"SetUpToSFZHM" sender:self];
                break;
        }
    }

//设置tableview的底部视图
- (void)setFootViewForTableView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, 45)];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    exitBtn.frame = CGRectMake(0, 5, UI_SCREEN_W, 40.f);
    [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
    //设置按钮标题的字体大小
    exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [exitBtn setTitleColor:UIColorFromRGB(221.f, 129.f, 116.f) forState:UIControlStateNormal];
    exitBtn.backgroundColor = [UIColor whiteColor];
    [exitBtn addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:exitBtn];
    
    [_SetUpTableView setTableFooterView:view];
}
//按钮的点击事件
- (void)exitAction: (UIButton *)button{
    //NSLog(@"%@", @"退出");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self exit];
    }];
    UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionA];
    [alert addAction:actionB];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)exit{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//设置组的底部视图颜色为透明
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (IBAction)modBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

@end
