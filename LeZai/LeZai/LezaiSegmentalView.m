//
//  LezaiSegmentalView.m
//  LeZai
//
//  Created by 颜超 on 14-6-23.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "LezaiSegmentalView.h"

@implementation LezaiSegmentalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithImage:(UIImage *)norlmalImage
  andHighlightImage:(UIImage *)highlightImage
          andTitles:(NSArray *)arr
{
    self = [super init];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFrame:CGRectMake(0, 0, 320, 40)];
        _selectedIndex = 0;
        for (int i = 0; i < [arr count]; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0 + (i * 80), 0, 80, 40)];
            [button setImage:norlmalImage forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:highlightImage forState:UIControlStateSelected];
            [self addSubview:button];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
            [titleLabel setText:arr[i]];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [titleLabel setFont:[UIFont systemFontOfSize:14]];
            [titleLabel setTextColor:[UIColor colorWithRed:29.0/255.0 green:161.0/255.0 blue:230.0/255.0 alpha:1.0]];
            [button addSubview:titleLabel];
            if (i == 0) {
                button.selected = YES;
            }
        }
    }
    return self;
}

- (void)allButtonUnSelect
{
    for (id view in [self subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view setSelected:NO];
        }
    }
}

- (void)buttonClicked:(id)sender
{
    if (_selectedIndex == [sender tag]) {
        return;
    }
    _selectedIndex = [sender tag];
    [self allButtonUnSelect];
    [sender setSelected:YES];
    if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(selectIndex:)])
        {
            [self.delegate selectIndex:_selectedIndex];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
