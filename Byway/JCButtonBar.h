//
//  JCButtonBar.h
//  Byway
//
//  Created by Joseph Constantakis on 5/27/14.
//  Copyright (c) 2014 Joseph Constan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCButtonBar;

@protocol JCButtonBar <UIScrollViewDelegate>

@optional
- (void)buttonBar:(JCButtonBar *)buttonBar didTapButton:(UIButton *)button withTitle:(NSString *)title;

@end

@interface JCButtonBar : UIScrollView

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic, readonly) NSMutableArray *selectedTitles;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIColor *selectedTitleColor;
@property (weak, nonatomic) id<JCButtonBar> delegate;

@end
