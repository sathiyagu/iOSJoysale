//
//  UICollectionViewWaterfallCell.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "CHTCollectionViewWaterfallCell.h"
#import "AppDelegate.h"

@implementation CHTCollectionViewWaterfallCell
@synthesize ItemImage;
@synthesize PlaceholderImage;
@synthesize PostedTime;
@synthesize productType;
@synthesize priceLbl;
@synthesize productTitleLbl;
@synthesize productLocation;
@synthesize indexpathRow;
@synthesize lineView;

#pragma mark - Accessors

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        AppDelegate * delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

        ItemImage = [[UIImageView alloc]init];
        PlaceholderImage =[[UIImageView alloc]init];
        productType = [[UILabel alloc] init];
        PostedTime = [[UILabel alloc] init];
        priceLbl = [[UILabel alloc] init];
        productTitleLbl = [[UILabel alloc] init];
        productLocation = [[UILabel alloc] init];
        lineView = [[UIView alloc] init];
        
        [productType setFont:[UIFont fontWithName:appFontRegular size:12]];
        [PostedTime setFont:[UIFont fontWithName:appFontRegular size:13]];
        [priceLbl setFont:[UIFont fontWithName:appFontBold size:14]];
        [productTitleLbl setFont:[UIFont fontWithName:appFontRegular size:14]];
        [productLocation setFont:[UIFont fontWithName:appFontRegular size:12]];
        
        [productType setTextColor:whitecolor];
        [PostedTime setTextColor:whitecolor];
        [priceLbl setTextColor:AppTextColor];
        [productTitleLbl setTextColor:AppTextColor];
        [productLocation setTextColor:ThirdryTextColor];
        
        [productType setBackgroundColor:clearcolor];
        [PostedTime setBackgroundColor:clearcolor];
        [priceLbl setBackgroundColor:clearcolor];
        [productTitleLbl setBackgroundColor:clearcolor];
        [productLocation setBackgroundColor:clearcolor];
        [lineView setBackgroundColor:lineviewColor];
        [PlaceholderImage setImage:[UIImage imageNamed:@"ItemTransparentImg.png"]];
        [ItemImage setContentMode:UIViewContentModeScaleAspectFill];
        ItemImage.layer.masksToBounds=YES;
        
        if([delegate.languageSelected isEqualToString:@"Arabic"]){
            [priceLbl setTextAlignment:NSTextAlignmentRight];
            [productTitleLbl setTextAlignment:NSTextAlignmentRight];
            [productLocation setTextAlignment:NSTextAlignmentRight];
        }else{
            [priceLbl setTextAlignment:NSTextAlignmentLeft];
            [productTitleLbl setTextAlignment:NSTextAlignmentLeft];
            [productLocation setTextAlignment:NSTextAlignmentLeft];
        }
        [PostedTime setTextAlignment:NSTextAlignmentRight];

        [productType setTextAlignment:NSTextAlignmentCenter];
        productType.layer.cornerRadius=2;
        productType.layer.masksToBounds=YES;
        productType.numberOfLines=2;
        self.contentView.layer.cornerRadius =3;
        self.contentView.layer.masksToBounds= YES;
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:ItemImage];
        [self.contentView addSubview:PlaceholderImage];
        [self.contentView addSubview:productType];
        [self.contentView addSubview:PostedTime];
        [self.contentView addSubview:priceLbl];
        [self.contentView addSubview:productTitleLbl];
        [self.contentView addSubview:productLocation];
        [self.contentView addSubview:lineView];
        
    }
    return self;
}

@end
