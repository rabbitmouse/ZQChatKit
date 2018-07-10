//
//  ZQMenuCollectionLayout.m
//  ZQChatTableView
//
//  Created by 朱志勤 on 2018/7/10.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQMenuCollectionLayout.h"

@interface ZQMenuCollectionLayout()
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attrs;
@property (nonatomic, assign) CGFloat maxW;
@end

@implementation ZQMenuCollectionLayout

- (void)prepareLayout {
    if (self.collectionView == nil) {
        return;
    }
    
    CGFloat witdh = (self.collectionView.bounds.size.width - self.minimumInteritemSpacing * 3 - self.sectionInset.left - self.sectionInset.right) / 4;
    CGFloat height = (self.collectionView.bounds.size.height - self.minimumLineSpacing - self.sectionInset.top - self.sectionInset.bottom) / 2;
    NSInteger sectionCount = self.collectionView.numberOfSections;
    NSInteger prepage = 0;
    
    for (int i = 0; i < sectionCount; ++i) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < itemCount; ++j) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            NSInteger page = j / 8;
            NSInteger index = j % 8;
            
            CGFloat Y = self.sectionInset.top + (height + self.minimumLineSpacing) * (index / 4);
            CGFloat X = (prepage + page) * self.collectionView.bounds.size.width + self.sectionInset.left + (witdh + self.minimumInteritemSpacing) * (index % 4);
            attr.frame = CGRectMake(X, Y, witdh, height);
            
            [self.attrs addObject:attr];
        }
        
        prepage += (itemCount - 1) / (2 * 4) + 1;
    }
    
    self.maxW = prepage * self.collectionView.bounds.size.width;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrs;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.maxW, 0);
}

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)attrs {
    if (!_attrs) {
        _attrs = [NSMutableArray array];
    }
    return _attrs;
}

@end
