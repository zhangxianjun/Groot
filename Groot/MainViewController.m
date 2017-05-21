//
//  MainViewController.m
//  Groot
//
//  Created by ZXJ on 2017/5/20.
//  Copyright © 2017年 maodenden. All rights reserved.
//

#import "MainViewController.h"
#import "Define.h"
#import "MainCell.h"

#import "LowViewController.h"



static NSString *cellID = @"cellID";

@interface MainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *cameraCollectionView;

@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.nameString = self.dataSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            LowViewController *controller = [[LowViewController alloc] init];
            [self.navigationController pushViewController:controller animated:NO];
        }
            break;
            
        case 1:
        {
            
        }
            break;
            
        case 2:
        {
            
        }
            break;
            
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)setupUI {
    [self.view addSubview:self.cameraCollectionView];
}

#pragma mark - lazy
- (UICollectionView *)cameraCollectionView {
    if (_cameraCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(ZXJ_SW, 88);
        _cameraCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ZXJ_SW, ZXJ_SH) collectionViewLayout:layout];
        _cameraCollectionView.backgroundColor = [UIColor whiteColor];
        [_cameraCollectionView registerClass:[MainCell class] forCellWithReuseIdentifier:cellID];
        
        _cameraCollectionView.delegate = self;
        _cameraCollectionView.dataSource = self;
    }
    return _cameraCollectionView;
}


- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = @[@"简单录制", @"中级录制", @"高级录制", @"完整版录制", @"GPU录制"];
    }
    return _dataSource;
}
@end
