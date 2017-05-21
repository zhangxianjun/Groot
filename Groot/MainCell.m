//
//  MainCell.m
//  Groot
//
//  Created by ZXJ on 2017/5/21.
//  Copyright © 2017年 maodenden. All rights reserved.
//

#import "MainCell.h"

@interface MainCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation MainCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)setNameString:(NSString *)nameString {
    _nameString = nameString;
    self.nameLabel.text = nameString;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}
@end
