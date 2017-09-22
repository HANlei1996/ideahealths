//
//  FindViewController.m
//  Healths
//
//  Created by admin on 2017/9/11.
//  Copyright © 2017年 com. All rights reserved.
//

#import "FindViewController.h"
#import "CollectionViewCell.h"
#import "FindModel.h"
#import "XLTableViewCell.h"
#import "ClubDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MJRefresh.h"
@interface FindViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>{
    NSInteger  flag;
    NSInteger pageNum;
    NSInteger totalPage;
    BOOL isLast;
    NSInteger index;
    NSInteger index1;
    NSInteger index2;
    NSInteger pageSize;
    UIView *mcView;
    UIView *kindview;
    UIView *denview;
    // UIView *mcView;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *ButtonView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *kindBtn;
@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Height;
- (IBAction)CityAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)KindAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)DistanceAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong,nonatomic)UIActivityIndicatorView *avi;
@property (strong,nonatomic)NSMutableArray *HSArr;
@property (strong,nonatomic)NSMutableArray *TypeArr;
@property (strong,nonatomic)NSArray *CityArr;
@property (strong,nonatomic)NSMutableArray  *KindArr;
@property (strong,nonatomic)NSArray *DistanceArr;
@property (strong,nonatomic)NSString *distance;
@property (strong,nonatomic)NSString *kindId;
@property (strong,nonatomic)NSString *Type;
//@property(nonatomic, strong)NSMutableArray *selectedArray;//是否被点击

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNum = 1;
    pageSize = 10;
    index=0;
    index1=0;
    index2=0;
    _distance = @"0";
    _kindId = @"0";
    _Type = @"0";
    //关闭下拉
    _tableView.scrollEnabled = NO;
    //设置蒙层
    mcView = [[UIView alloc] initWithFrame:CGRectMake(0, 272, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    mcView.backgroundColor = [UIColor blackColor];
    mcView.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:mcView];
    kindview = [[UIView alloc] initWithFrame:CGRectMake(0, 310, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    kindview.backgroundColor = [UIColor blackColor];
    kindview.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:kindview];
    denview = [[UIView alloc] initWithFrame:CGRectMake(0, 190, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    denview.backgroundColor = [UIColor blackColor];
    denview.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:denview];
    
    
    //[[UIApplication sharedApplication].keyWindow addSubview:_tableView];
    mcView.hidden=YES;
    kindview.hidden=YES;
    denview.hidden=YES;
    //_tableView.layer.zPosition = 1;
    //_ButtonView.layer.zPosition=2;
    //交互
    mcView.userInteractionEnabled = YES;
    kindview.userInteractionEnabled = YES;
    denview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
    UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event1:)];
    UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event2:)];
    [mcView addGestureRecognizer:tapGesture];
    [kindview addGestureRecognizer:tapGesture1];
    [denview addGestureRecognizer:tapGesture2];
    [tapGesture setNumberOfTapsRequired:1];
    
    //////////////////////////////////
    _HSArr = [NSMutableArray new];
    _TypeArr  = [NSMutableArray new];
    
   // _KindArr  = [[NSMutableArray alloc]initWithObjects:@"全部分类",nil];
    _CityArr = [[NSArray alloc]initWithObjects:@"全城",@"距离我2千米",@"距离我3千米",@"距离我4千米",nil];
    _DistanceArr = [[NSArray alloc]initWithObjects:@"按距离",@"按人气", nil];
    
    
    _tableView.hidden=YES;
    [self naviConfig];
    [self dataInitialize];
    // [self addHeader];
}
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.collectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加5条假数据
        //        for (int i = 0; i<5; i++) {
        //            [vc.fakeColors insertObject:MJRandomColor atIndex:0];
        //        }
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.collectionView reloadData];
            // 结束刷新
            [vc.collectionView headerEndRefreshing];
        });
    }];
    
}







- (void)event:(UITapGestureRecognizer *)action{
    _tableView.hidden=YES;
    mcView.hidden=YES;
    
    index=0;
    
    //action.view ;
}
- (void)event1:(UITapGestureRecognizer *)action{
    _tableView.hidden=YES;
    kindview.hidden=YES;
    
    index1=0;
    
    //action.view ;
}
- (void)event2:(UITapGestureRecognizer *)action{
    _tableView.hidden=YES;
    denview.hidden=YES;
    
    index2=0;
    
    //action.view ;
}


- (void)viewWillAppear:(BOOL)animated{
    //[self dataInitialize];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfig{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationItem.title = @"发现";
    //设置导航条的颜色（风格颜色）
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:100/255.0 blue:255/255.0 alpha:1.0]];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
}


/*- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
 
 if ([touch.view isDescendantOfView:self.tableView]) {
 
 return NO;
 
 }
 return YES;
 }
 */
-(void)dataInitialize{
    
    [self TypeRequest];
}
#pragma mark - request


- (void)TypeRequest{
    
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡"};
    [RequestAPI requestURL:@"/clubController/getNearInfos" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        
        [_avi stopAnimating];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *features = responseObject[@"result"][@"features"];
            NSArray *featureForm = features[@"featureForm"];
            for(NSDictionary *dict in featureForm){
                FindModel *model = [[FindModel alloc]initWithclubDictionary:dict];
                [_TypeArr addObject:model];
                
            }
            [_KindArr removeAllObjects];
            _KindArr  = [[NSMutableArray alloc]initWithObjects:@"全部分类", nil];

            for(int i = 0; i < 4;i++){
                FindModel *model = _TypeArr[i];
                [_KindArr addObject:model.fName];
            }
            
            [self addHeader];
            [self HSRequest];
            
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}

- (void)HSRequest{
    // mcView.hidden = YES;
    _avi = [Utilities getCoverOnView:self.view];
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:@{@"city":@"无锡",@"jing":@"120.300000",@"wei":@"31.570000",@"page":@(pageNum),@"perPage":@(pageSize),@"Type":_Type}];
    
    if (![_distance isEqualToString:@"0"]) {
        [para setObject:_distance forKey:@"distance"];
    }
    if (![_kindId isEqualToString:@"0"]) {
        [para setObject:_kindId forKey:@"featureId"];
    }
    
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        // NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSLog(@"responseObject=%@",responseObject);
            NSDictionary *result = responseObject[@"result"];
            NSArray *array = result[@"models"];
            NSDictionary  *pageDict =result[@"pagingInfo"];
            totalPage = [pageDict[@"totalPage"]integerValue];
            
            if(pageNum == 1){
                [_HSArr removeAllObjects];
            }
            for(NSDictionary *dict in array){
                FindModel *model = [[FindModel alloc]initWithDictionary:dict];
                [_HSArr addObject:model];
                
            }
            [self addHeader];
            [_collectionView reloadData];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        
    }];
    
}

/*- (void)JLRequest{
 //  mcView.hidden = YES;
 
 NSDictionary *para =  @{@"city":@"无锡",@"jing":@120.300,@"wei":@31.570,@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@0,@"distance":_distance};
 [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
 //  NSLog(@"responseObject:%@", responseObject);
 [_avi stopAnimating];
 UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
 [ref endRefreshing];
 
 if([responseObject[@"resultFlag"] integerValue] == 8001){
 NSDictionary *result = responseObject[@"result"];
 NSArray *array = result[@"models"];
 NSDictionary  *pageDict =result[@"pagingInfo"];
 totalPage = [pageDict[@"totalPage"]integerValue];
 
 if(pageNum == 1){
 [_HSArr removeAllObjects];
 }
 
 for(NSDictionary *dict in array){
 FindModel *model = [[FindModel alloc]initWithDictionary:dict];
 
 [_HSArr addObject:model];
 
 
 }
 [self addHeader];
 [_collectionView reloadData];
 
 }else{
 //业务逻辑失败的情况下
 NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
 [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
 }
 
 } failure:^(NSInteger statusCode, NSError *error) {
 [_avi stopAnimating];
 UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
 [ref endRefreshing];
 [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
 }];
 
 }
 
 - (void)FLClubRequest{
 // mcView.hidden = YES;
 _avi = [Utilities getCoverOnView:self.view];
 NSDictionary *para =  @{@"city":@"无锡",@"jing":@120.300,@"wei":@31.570,@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@0,@"featureId":_kindId};
 [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
 //  NSLog(@"responseObject:%@", responseObject);
 [_avi stopAnimating];
 if([responseObject[@"resultFlag"] integerValue] == 8001){
 NSDictionary *result = responseObject[@"result"];
 NSArray *array = result[@"models"];
 [_HSArr removeAllObjects];
 for(NSDictionary *dict in array){
 FindModel *model = [[FindModel alloc]initWithDictionary:dict];
 
 [_HSArr addObject:model];
 
 }
 [self addHeader];
 [_collectionView reloadData];
 }else{
 //业务逻辑失败的情况下
 NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
 [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
 }
 
 } failure:^(NSInteger statusCode, NSError *error) {
 [_avi stopAnimating];
 [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
 }];
 
 }
 
 
 - (void)TypeClubRequest{
 //  mcView.hidden = YES;
 _avi = [Utilities getCoverOnView:self.view];
 NSDictionary *para =  @{@"city":@"无锡",@"jing":@120.300,@"wei":@31.570,@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@1};
 [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
 
 [_avi stopAnimating];
 if([responseObject[@"resultFlag"] integerValue] == 8001){
 NSDictionary *result = responseObject[@"result"];
 NSArray *array = result[@"models"];
 [_HSArr removeAllObjects];
 for(NSDictionary *dict in array){
 FindModel *model = [[FindModel alloc]initWithDictionary:dict];
 
 [_HSArr addObject:model];
 
 }
 [self addHeader];
 [_collectionView reloadData];
 }else{
 //业务逻辑失败的情况下
 NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
 [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
 }
 
 } failure:^(NSInteger statusCode, NSError *error) {
 [_avi stopAnimating];
 [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
 }];
 
 }
 */
#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(flag == 1){
        
        _tableView.hidden=NO;
        
        return _CityArr.count;
        
    }
    if(flag == 2){
        
        _tableView.hidden=NO;
        return 5;
        
    }
    if(flag == 3){
        
        _tableView.hidden=NO;
        return _DistanceArr.count;
        
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    if(flag == 1){
        
        cell.kindLbl.text = _CityArr[indexPath.row];
    }
    if(flag == 2){
        cell.kindLbl.text = _KindArr[indexPath.row];
        
    }
    if(flag == 3){
        cell.kindLbl.text = _DistanceArr[indexPath.row];
    }
    return cell;
    
}
//设置每一组中每一行被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(flag == 1)
    {
        if(indexPath.row == 0){
            
            mcView.hidden=YES;
            
            
        }
        if(indexPath.row == 1){
            
            
            mcView.hidden=YES;
            
            
        }
        if(indexPath.row == 2){
            
            mcView.hidden=YES;
            
            
        }
        if(indexPath.row == 3){
            
            mcView.hidden=YES;
            
            
        }
        _tableView.hidden=YES;
        index=0;
        switch (indexPath.row) {
            case 0:
                mcView.hidden=YES;
                
                // [self HSRequest];
                _distance = @"0";
                _cityBtn.titleLabel.text = @"全城";
                break;
            case 1:
                mcView.hidden=YES;
                
                //[self HSRequest];
                _distance = @"2000";
                _cityBtn.titleLabel.text = @"2km";
                break;
            case 2:
                mcView.hidden=YES;
                
                // [self HSRequest];
                _distance = @"3000";
                _cityBtn.titleLabel.text = @"3km";
                break;
            case 3:
                mcView.hidden=YES;
                
                //[self HSRequest];
                _distance = @"4000";
                _cityBtn.titleLabel.text = @"4km";
                break;
            default:
                mcView.hidden=YES;
                
                // [self HSRequest];
                _distance = @"0";
                _cityBtn.titleLabel.text = @"全城";
                break;
        }
    }
    
    if(flag == 2){
        
        if(indexPath.row == 0){
            
            kindview.hidden=YES;
            
            
        }
        if(indexPath.row == 1){
            
            kindview.hidden=YES;
            
            
        }
        if(indexPath.row == 2){
            
            kindview.hidden=YES;
            
            
        }
        if(indexPath.row == 3){
            
            kindview.hidden=YES;
            
            
            
        }
        if(indexPath.row == 4){
            
            kindview.hidden=YES;
            
            
            
        }
        index1=0;
        _tableView.hidden=YES;
        
        switch (indexPath.row) {
            case 0:
                
                _kindId = @"0";
                _kindBtn.titleLabel.text=@"全部分类";
                break;
            case 1:
                
                _kindId = @"1";
                _kindBtn.titleLabel.text=@"动感单车";
                break;
            case 2:
                
                _kindId = @"2";
                _kindBtn.titleLabel.text=@"力量器械";
                break;
            case 3:
                
                _kindId = @"3";
                 _kindBtn.titleLabel.text=@"瑜伽/普拉提";
                break;
            case 4:
                
                _kindId = @"4";
                 _kindBtn.titleLabel.text=@"有氧运动";
                break;
            default:
                
                _kindId = @"0";
                 _kindBtn.titleLabel.text=@"全部分类";
                break;
        }
    }
    
    if(flag == 3){
        if(indexPath.row == 0){
            
            denview.hidden=YES;
            
            
        }
        if(indexPath.row == 1){
            
            denview.hidden=YES;
            
            
        }
        index2=0;
        denview.hidden=YES;
        _tableView.hidden=YES;
    }
    switch (indexPath.row) {
        case 0:
            _Type = @"0";
            _distanceBtn.titleLabel.text=@"按距离";
            break;
        case 1:
            _Type = @"1";
            _distanceBtn.titleLabel.text=@"按人气";
            break;
        default:
            _Type = @"0";
            _distanceBtn.titleLabel.text=@"按距离";
            break;
    }
    [self dataInitialize];
}



- (void)setRefreshControl{
    
    UIRefreshControl *acquireRef = [UIRefreshControl new];
    [acquireRef addTarget:self action:@selector(TypeRequest) forControlEvents:UIControlEventValueChanged];
    acquireRef.tag = 10001;
    [_collectionView addSubview:acquireRef];
    
}

#pragma mark - collectionView
//每组有多少个items
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _HSArr.count;
}
//每个items长什么样
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    FindModel * model = _HSArr[indexPath.item];
    cell.label1.text = model.name;
    cell.label2.text = model.address;
    NSLog(@"%@%@",model.address,model.clubid);
    cell.label3.text = [NSString stringWithFormat:@"%@米",model.distance];
    NSURL *URL = [NSURL URLWithString:model.image];
    [cell.image sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@""]];
    
    return cell;
    
}
//设置每个cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((UI_SCREEN_W - 5)/2,185);
    
}
//最小的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
    
}

/*- (void)setRefreshControl{
 
 UIRefreshControl *acquireRef = [UIRefreshControl new];
 [acquireRef addTarget:self action:@selector(acquireRef) forControlEvents:UIControlEventValueChanged];
 acquireRef.tag = 10001;
 [_collectionView addSubview:acquireRef];
 
 }
 */
- (void)acquireRef{
    pageNum = 1;
    if(flag == 1){
        
        _avi = [Utilities getCoverOnView:self.view];
        [self HSRequest];
    }
    if(flag == 2){
        [self HSRequest];
    }
    if(flag == 3){
        
        [self HSRequest];
    }else{
        [self HSRequest];
    }
}


//细胞将要出现时调用
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.row == _HSArr.count -1){
        if(pageNum != totalPage){
            pageNum ++;
            [self HSRequest];
            
        }
    }
    
}

#pragma mark - Action
- (IBAction)CityAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag=1;
    self.Height.constant = _CityArr.count*40 ;
    mcView.hidden=NO;
    
    index+=1;
    if(index==2){
        _tableView.hidden=YES;
        kindview.hidden=YES;
        mcView.hidden=YES;
        denview.hidden=YES;
        index=0;
    }else{
        index1=0;
        index2=0;
        _tableView.hidden=NO;
        kindview.hidden=YES;
        denview.hidden=YES;
        [_tableView reloadData];
        
        
    }
    
    
    
}

- (IBAction)KindAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 2;
    index1+=1;
    self.Height.constant = _KindArr.count*40  ;
    kindview.hidden=NO;
    if(index1==2){
        _tableView.hidden=YES;
        mcView.hidden=YES;
        kindview.hidden=YES;
        denview.hidden=YES;
        index1=0;
    }else{
        index=0;
        index2=0;
        _tableView.hidden=NO;
        mcView.hidden=YES;
        denview.hidden=YES;
        [_tableView reloadData];
        
    }
    
}

- (IBAction)DistanceAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 3;
    index2+=1;
    self.Height.constant = _DistanceArr.count *40;
    denview.hidden=NO;
    if(index2==2){
        _tableView.hidden=YES;
        mcView.hidden=YES;
        denview.hidden=YES;
        kindview.hidden=YES;
        index2=0;
    }else{
        mcView.hidden=YES;
        index1=0;
        index=0;
        _tableView.hidden=NO;
        kindview.hidden=YES;
        [_tableView reloadData];
        
    }
    
}






-(void) collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CollectionViewCell *cell = (CollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    self.collectionView.delaysContentTouches = false;
    [cell setBackgroundColor:[UIColor lightGrayColor]];
    
    
    
}

- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CollectionViewCell *cell = (CollectionViewCell*)[colView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1.0]];
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ClubDetailViewController *purchaseVC=[Utilities getStoryboardInstance:@"Detail" byIdentity:@"clubdetail"];
    //NSLog(@"%ld,%ld",(long)indexPath.row,(long)indexPath.item);
    //purchaseVC.detail=_detail;
    [[StorageMgr singletonStorageMgr] removeObjectForKey:@"expId"];
    FindModel *model = _HSArr[indexPath.item];
    //NSLog(@"model.id = %@",model.clubid);
    
    [[StorageMgr singletonStorageMgr] addKey:@"expId" andValue:model.clubid];
    [self.navigationController pushViewController:purchaseVC animated:YES];
    [_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    //return;
    
    
    
    
    
    
    //
    //
    //
    //
}

@end
