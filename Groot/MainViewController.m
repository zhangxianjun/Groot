//
//  MainViewController.m
//  Groot
//
//  Created by ZXJ on 2017/5/20.
//  Copyright © 2017年 maodenden. All rights reserved.
//

#import "MainViewController.h"
#import "Define.h"

static NSString *cellID = @"cellID";

@interface MainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *cameraCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *cameraFlowLayout;

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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell.contentView addSubview:[self contentView:self.dataSource[indexPath.row]]];
    return cell;
}

- (UIView *)contentView:(NSString *)string {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZXJ_SW, 44)];
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.textColor = [UIColor blueColor];
    label.text = string;
    [view addSubview:label];
    return view;
}

- (void)setupUI {
    self.cameraCollectionView.collectionViewLayout = self.cameraFlowLayout;
    
    [self.view addSubview:self.cameraCollectionView];
}

#pragma mark - lazy
- (UICollectionView *)cameraCollectionView {
    if (_cameraCollectionView == nil) {
        _cameraCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ZXJ_SW, ZXJ_SH)];
        _cameraCollectionView.backgroundColor = [UIColor whiteColor];
        [_cameraCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return _cameraCollectionView;
}

- (UICollectionViewFlowLayout *)cameraCollectionViewLayout {
    if (_cameraFlowLayout == nil) {
        _cameraFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _cameraFlowLayout.itemSize = CGSizeMake(ZXJ_SW, 100);
    }
    return _cameraFlowLayout;
}

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = @[@"简单录制", @"中级录制", @"高级录制", @"完整版录制", @"GPU录制"];
    }
    return _dataSource;
}
@end
