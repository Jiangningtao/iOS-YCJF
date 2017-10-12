//
//  chenghuiViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/27.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "chenghuiViewController.h"
#import "chenghuiCollectionViewCell.h"
#import "YinChengNewsDetailViewController.h"
@interface chenghuiViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *Collect;
@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation chenghuiViewController

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layout];
    if (self.titlestr) {
        self.title = self.titlestr;
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.tabBarController.tabBar.hidden = NO;
        self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
        UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 19)];
        [leftButton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_back_click"] forState:UIControlStateNormal];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];

    }
    
    _Collect.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    _Collect.mj_header.automaticallyChangeAlpha = YES;//自动改变透明度
    [_Collect.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

-(void)loadNewTopics
{
    
    [self.Collect.mj_footer resetNoMoreData];
    //结束下拉刷新
    [self.Collect.mj_footer endRefreshing];
    //    self.page++;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    
    NSLog(@"%@?%@", ycmessage, params);
    [manager POST:ycmessage parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        [self.dataArray removeAllObjects];
        if (NULL_TO_NIL(responseObject[@"data"])) {
            for (NSDictionary * dict in responseObject[@"data"]) {
                [self.dataArray addObject:dict];
            }
        }else{
            UIImageView *imv = [[UIImageView alloc]init];
            imv.image = [UIImage imageNamed:@"pic_zwsj"];
            [self.view addSubview:imv];
            [imv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.offset(0);
                make.centerY.offset(0);
                make.width.offset(155);
                make.height.offset(194);
            }];
        }
        
        [self.Collect reloadData];
        [self.Collect.mj_header endRefreshing];//结束刷新
        //清空页码
        //        self.page = 0;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //        if (self.params != params)return ;
        [self.Collect.mj_header endRefreshing];//结束刷新
    }];
    
}

-(void)leftbtnclicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)layout{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //    layout.itemSize = CGSizeMake(ScreenWidth,100);
    // 设置列的最小间距
    layout.minimumInteritemSpacing = 0;
    // 设置最小行间距
    layout.minimumLineSpacing = 10;
    
    // 设置布局的内边距
    layout.sectionInset = UIEdgeInsetsMake(10,0,10,0);
    // 滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _Collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.titlestr == nil ?  ScreenHeight- 110 : ScreenHeight  ) collectionViewLayout:layout];
    _Collect.backgroundColor =grcolor;
    
    _Collect.dataSource = self;
    _Collect.delegate = self;
    [_Collect registerNib:[UINib nibWithNibName:@"chenghuiCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UserCollectCELLID"];
    [self.view addSubview:self.Collect];
    
}
#pragma mrk -collect

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return self.dataArray.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView cellForItemAtIndexPath:indexPath];
    YinChengNewsDetailViewController * ycNewsDetailVC = [[YinChengNewsDetailViewController alloc] init];
    ycNewsDetailVC.news_id = self.dataArray[indexPath.item][@"news_id"];
    [self.navigationController pushViewController:ycNewsDetailVC animated:YES];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
        return CGSizeMake(_Collect.frame.size.width, 230);
 
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 
        
        
              chenghuiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCollectCELLID" forIndexPath:indexPath];
    cell.backgroundColor =[UIColor whiteColor];
    
    if (self.dataArray.count > 0) {
        NSDictionary * dict = self.dataArray[indexPath.item];
        [cell.yincheng_imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"preview_pic"]] placeholderImage:[UIImage imageNamed:@"pic.png"]];
        cell.yincheng_titLab.text = dict[@"title"];
        cell.yincheng_dateLab.text = dict[@"publish_time"];
    }
    
           return cell;
    
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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

@end
