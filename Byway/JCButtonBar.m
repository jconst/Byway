//
//  JCButtonBar.m
//  Byway
//
//  Created by Joseph Constantakis on 5/27/14.
//  Copyright (c) 2014 Joseph Constan. All rights reserved.
//

#import "JCButtonBar.h"
#import "UIView+FrameAccessor.h"

@implementation JCButtonBar

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self initializeProperties];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self initializeProperties];
    }
    return self;
}

- (void)initializeProperties
{
    self.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:self.height / 2.0];
    self.selectedTitleColor = [UIColor colorWithRed:0.298 green:0.735 blue:0.974 alpha:1.000];
    self.titleColor = [UIColor colorWithRed:0.042 green:0.164 blue:0.079 alpha:1.000];

    self.showsHorizontalScrollIndicator = NO;
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    CGFloat x = 20.0;
    for (NSString *title in titles) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = self.font;
        [button setTitleColor:self.titleColor         forState:UIControlStateNormal];
        [button setTitleColor:self.selectedTitleColor forState:UIControlStateSelected];
        [button setTitle:title                        forState:UIControlStateNormal];
        [button sizeToFit];
        button.origin = CGPointMake(x, 0);
        [self addSubview:button];
        x += button.width + 10.0;
    }
    self.contentSize = CGSizeMake(x + 10.0, self.height);
}

- (void)didTapButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(buttonBar:didTapButton:withTitle:)]) {
        [self.delegate buttonBar:self didTapButton:button withTitle:button.titleLabel.text];
    }
    button.selected = !button.selected;
    if (button.selected) {
        [_selectedTitles addObject:button.titleLabel.text];
    } else {
        [_selectedTitles removeObject:button.titleLabel.text];
    }
}

@end
