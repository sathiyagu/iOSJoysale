//
//  UICollectionViewWaterfallCell.h
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHTCollectionViewWaterfallCell : UICollectionViewCell
@property (nonatomic, retain)  UIImageView *ItemImage;
@property (nonatomic, retain) UIImageView *PlaceholderImage;
@property (nonatomic, retain)  UILabel *PostedTime;
@property (nonatomic, retain)  UILabel *productType;
@property (nonatomic ,retain) UILabel *priceLbl;
@property (nonatomic, retain)  UILabel *productTitleLbl;
@property (nonatomic, retain)  UILabel *productLocation;
@property (nonatomic, retain)  UIView *lineView;
@property (nonatomic) int indexpathRow;
@end
