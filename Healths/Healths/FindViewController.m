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
@interface FindViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>{
    NSInteger  flag;
    NSInteger pageNum;
    NSInteger totalPage;
    BOOL isLast;
NSInteger pageSize;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *ButtonView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *kindBtn;
@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;
//@property (weak, nonatomic) IBOutlet UIView *membraneView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeightConstraint;
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

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNum = 1;
    pageSize = 10;

    _HSArr = [NSMutableArray new];
    _TypeArr  = [NSMutableArray new];

    _KindArr  = [[NSMutableArray alloc]initWithObjects:@"全部分类", nil];
    _CityArr = [[NSArray alloc]initWithObjects:@"全城",@"距离我1千米",@"距离我2千米",@"距离我3千米",nil];
    _DistanceArr = [[NSArray alloc]initWithObjects:@"按距离",@"按人气", nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView)];
       tapGesture.delegate = self;
   // [self.membraneView addGestureRecognizer:tapGesture];
    _tableView.hidden=YES;
    [self naviConfig];
    [self dataInitialize];
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

-(void)clickView{
  //  _membraneView.hidden = YES;
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.tableView]) {
      
        return NO;
        
    }
    return YES;
}

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
        return _KindArr.count;
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
    if(flag == 1){
        if(indexPath.row == 0){
            [self HSRequest];
        }
        if(indexPath.row == 1){
            _distance = @"1000";
            [self JLRequest];
        }
        if(indexPath.row == 2){
            _distance = @"2000";
            [self JLRequest];
        }
        if(indexPath.row == 3){
            _distance = @"3000";
            [self JLRequest];
        }
        _tableView.hidden=YES;
        
    }
    if(flag == 2){
        
        if(indexPath.row == 0){
            [self HSRequest];
        }
        if(indexPath.row == 1){
            _kindId = @"1";
            [self FLClubRequest];
        }
        if(indexPath.row == 2){
            _kindId = @"2";
            [self FLClubRequest];
        }
        if(indexPath.row == 3){
            _kindId = @"3";
            [self FLClubRequest];
        }
        if(indexPath.row == 4){
            _kindId = @"4";
            [self FLClubRequest];
        }
        _tableView.hidden=YES;
    }
    if(flag == 3){
        if(indexPath.row == 0){
            [self HSRequest];
        }
        if(indexPath.row == 1){
            [self TypeClubRequest];
        }
        
        _tableView.hidden=YES;
    }
    
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
    NSLog(@"123= %@%@",model.address,model.clubid);
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

- (void)setRefreshControl{
    
    UIRefreshControl *acquireRef = [UIRefreshControl new];
    [acquireRef addTarget:self action:@selector(acquireRef) forControlEvents:UIControlEventValueChanged];
    acquireRef.tag = 10001;
    [_collectionView addSubview:acquireRef];
    
}

- (void)acquireRef{
    pageNum = 1;
    if(flag == 1){
        
        //_avi = [Utilities getCoverOnView:self.view];
        [self JLRequest];
    }
    if(flag == 2){
        [self FLClubRequest];
    }
    if(flag == 3){
        
        [self TypeClubRequest];
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
    flag = 1;
    // self.HeightConstraint.constant = _CityArr.count *40 ;
    // _membraneView.hidden = NO;
    [_tableView reloadData];
}

- (IBAction)KindAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 2;
    //self.HeightConstraint.constant = _KindArr.count *40 ;
    //_membraneView.hidden = NO;
    [_tableView reloadData];
}

- (IBAction)DistanceAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 3;
    // self.HeightConstraint.constant = _DistanceArr.count *40;
    // _membraneView.hidden = NO;
    [_tableView reloadData];
}




#pragma mark - request
-(void)dataInitialize{
    // [self hotRequest];
    [self TypeRequest];
}

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
            for(int i = 0; i < 4;i++){
                FindModel *model = _TypeArr[i];
                [_KindArr addObject:model.fName];
            }
            
           
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
  //  _membraneView.hidden = YES;
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.300000",@"wei":@"31.570000",@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@0};
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

- (void)JLRequest{
   // _membraneView.hidden = YES;
    
    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.300000",@"wei":@"31.570000",@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@0,@"distance":_distance};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //  NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        NSLog(@"为什么不停止");
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
   // _membraneView.hidden = YES;
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.300000",@"wei":@"31.570000",@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@0,@"featureId":_kindId};
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
    //_membraneView.hidden = YES;
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.300000",@"wei":@"31.570000",@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@1};
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
