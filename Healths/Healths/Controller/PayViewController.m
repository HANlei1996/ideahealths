//
//  PayViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "PayViewController.h"

@interface PayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tykLabel;
@property (weak, nonatomic) IBOutlet UILabel *dmLabel;
@property (weak, nonatomic) IBOutlet UILabel *djLabel;
@property (weak, nonatomic) IBOutlet UILabel *jgLabel;
@property (weak, nonatomic) IBOutlet UIView *numLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSArray * arr;
- (IBAction)jiajianBtn:(UIStepper *)sender forEvent:(UIEvent *)event;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self uiLayout];
    [self dataInitialize];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(purchaseResultAction:) name:@"AlipayResult" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 这个方法专门做导航条的控制
-(void)naviConfig{
    //设置导航条标题文字
    self.navigationItem.title=@"体验券支付";
    //为导航条右上角创建一个按钮
    UIBarButtonItem *right= [[UIBarButtonItem alloc]initWithTitle:@"支付" style:UIBarButtonItemStylePlain target:self action:@selector(payAction)];
    self.navigationItem.rightBarButtonItem = right;
    
}
-(void)uiLayout{
    _tykLabel.text=_detail.eName;
    _dmLabel.text=_detail.eClubName;
    _djLabel.text=[NSString stringWithFormat:@"%@元",_detail.currentPrice];
    _jgLabel.text=[NSString stringWithFormat:@"%@元",_detail.currentPrice];
    
    self.tableView.tableFooterView=[UIView new];
    //将表格视图设置为“细胞中”
    self.tableView.editing=YES;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    //用代码来选中表格视图中的某个细胞
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
}

/*-(void)uiLayout{
    _nameLabel.text=_activity.name;
    _contentLabel.text=_activity.content;
    _priceLabel.text=[NSString stringWithFormat:@"%@元",_activity.applyFee]
    ;
    self.tableView.tableFooterView=[UIView new];
    //将表格视图设置为“细胞中”
    self.tableView.editing=YES;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    //用代码来选中表格视图中的某个细胞
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
}*/
-(void)dataInitialize{
    _arr=@[@"支付宝支付",@"微信支付",@"银联支付"];
    
}
-(void)payAction{
    switch(self.tableView.indexPathForSelectedRow.row){
        case 0:{
            NSString *tradeNo=[GBAlipayManager generateTradeNO];
            [GBAlipayManager alipayWithProductName:_detail.eName amount:_detail.currentPrice tradeNO:tradeNo notifyURL:nil productDescription:[NSString stringWithFormat:@"%@的活动报名费",_detail.eName] itBPay:@"30"];
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            
        }
            break;
        default:
            break;
    }
    
}

/*-(void)payAction{
    switch(self.tableView.indexPathForSelectedRow.row){
        case 0:{
            NSString *tradeNo=[GBAlipayManager generateTradeNO];
            [GBAlipayManager alipayWithProductName:_activity.name amount:_activity.applyFee tradeNO:tradeNo notifyURL:nil productDescription:[NSString stringWithFormat:@"%@的活动报名费",_activity.name] itBPay:@"30"];
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            
        }
            break;
        default:
            break;
    }
    
}*/

-(void)purchaseResultAction:(NSNotification *)note{
    NSString *result=note.object;
    if([result isEqualToString:@"9000"]) {
        //成功
        UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"支付成功" message:@"恭喜你，你成功完成报名" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }else{
        //失败
        [Utilities popUpAlertViewWithMsg:[result isEqualToString:@"4000"] ? @"未能成功支付，请确保账户余额充足": @"你已取消订单" andTitle:@"支付失败:" onView:self];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - table view 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell" forIndexPath:indexPath];
    cell.textLabel.text=_arr[indexPath.row];
    
    return cell;
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"支付方式";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //遍历表格视图中所有选中状态下的细胞
    for(NSIndexPath *eachIP in tableView.indexPathsForSelectedRows){
        //当选中的细胞不是当前正在按的这个细胞情况下
        if(eachIP != indexPath){
            //将细胞从选中状态改为不选中状态
            [tableView deselectRowAtIndexPath:eachIP animated:YES];
        }
    }
}


- (IBAction)jiajianBtn:(UIStepper *)sender forEvent:(UIEvent *)event {
}
@end
