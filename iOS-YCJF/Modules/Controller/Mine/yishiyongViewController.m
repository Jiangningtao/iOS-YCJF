//
//  yishiyongViewController.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/22.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "yishiyongViewController.h"
#import "jaingjuanCollectionViewCell.h"
#import "myjjModel.h"
@interface yishiyongViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *FourBtnCollect;
@property (nonatomic ,strong)NSDictionary *params;
/***<#注释#> ***/
@property (nonatomic ,assign)NSUInteger page;
@property (nonatomic ,strong)NSMutableArray *Modelarr;
@end

@implementation yishiyongViewController
-(NSMutableArray *)Modelarr{
    if (!_Modelarr) {
        _Modelarr = [NSMutableArray array];
    }
    return _Modelarr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self loadNewTopics];
    self.view.backgroundColor = grcolor;
    [self layout];
    
    // Do any additional setup after loading the view.
}
-(void)loadNewTopics{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    params[@"pageSize"] = @"10";
    params[@"pageIndex"] = @"1";
    params[@"is_used"] = @"1";
    self.page = 1;
    
    self.params = params;
    [WWZShuju initlizedData:myjjurl paramsdata:params dicBlick:^(NSDictionary *info) {
        if (self.params != params)return ;
        NSLog(@"---奖劵已使用-----%@",info);
        self.Modelarr = [myjjModel mj_objectArrayWithKeyValuesArray:info[@"data"]];
        UIImageView *imv = [[UIImageView alloc]init];
        if (self.Modelarr.count ==0) {
            imv.image = [UIImage imageNamed:@"pic_zwsj"];
            [self.view addSubview:imv];
            [imv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.offset(0);
                make.top.offset(100);
                make.width.offset(155);
                make.height.offset(194);
            }];
        }else{
            self.FourBtnCollect.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
        }
        [self.FourBtnCollect reloadData];
        
    }];
    
}

- (void)loadMoreTopics
{
    //消除尾部"没有更多数据"的状态
    [self.FourBtnCollect.mj_footer resetNoMoreData];
    //结束上拉刷新
    [self.FourBtnCollect.mj_header endRefreshing];
    self.page++;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    params[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    params[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    params[@"version"] = @"v1.0.3";
    params[@"os"] = @"ios";
    params[@"is_used"] = @"1";
    NSInteger page = self.page;
    params[@"pageSize"] = @"10";
    params[@"pageIndex" ]=@(page);
    
    self.params = params;
    [WWZShuju initlizedData:myjjurl paramsdata:params dicBlick:^(NSDictionary *info) {
        if (self.params != params)return ;
        NSLog(@"---奖劵已过期-----%@",info);
        [self.Modelarr addObjectsFromArray:[myjjModel mj_objectArrayWithKeyValuesArray:info[@"data"]]];
        
        if ([info[@"data"] count] == 0) {
            self.FourBtnCollect.mj_footer.state = MJRefreshStateNoMoreData;
            //设置页码
            self.page = page;
        }
        
        [self.FourBtnCollect reloadData];
        
    }];
    
}


-(void)layout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(ScreenWidth-20,105);
    // 设置列的最小间距
    flowLayout.minimumInteritemSpacing = 12;
    // 设置最小行间距
    flowLayout.minimumLineSpacing = 12;
    // 设置布局的内边距
    flowLayout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    // 滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _FourBtnCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 16, ScreenWidth,ScreenHeight-120) collectionViewLayout:flowLayout];
    _FourBtnCollect.backgroundColor = grcolor;
    _FourBtnCollect.dataSource = self;
    _FourBtnCollect.delegate = self;
    [_FourBtnCollect registerNib:[UINib nibWithNibName:@"jaingjuanCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"custumecell"];
    [self.view addSubview:self.FourBtnCollect];
}

#pragma mrk -collect
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.Modelarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    jaingjuanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"custumecell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
//    cell.imgView.image = [UIImage imageNamed:@"huise"];
//    cell.biaojiimgV.image = [UIImage imageNamed:@"pic_yishiyong"];
    cell.xuxianView.alpha = 0;
    cell.model = self.Modelarr[indexPath.item];
    return cell;
    
    
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
