//
//  LezaiSegmentalView.h
//  LeZai
//
//  Created by 颜超 on 14-6-23.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LezaiSegmentalViewDelegate <NSObject>
- (void)selectIndex:(int)index;
@end

@interface LezaiSegmentalView : UIView

@property (nonatomic, weak) id<LezaiSegmentalViewDelegate> delegate;
@property (nonatomic, readonly) int selectedIndex;
- (id)initWithImage:(UIImage *)norlmalImage
  andHighlightImage:(UIImage *)highlightImage
          andTitles:(NSArray *)arr;
@end
