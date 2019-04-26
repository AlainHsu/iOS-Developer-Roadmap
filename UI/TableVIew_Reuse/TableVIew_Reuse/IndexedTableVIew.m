
//
//  IndexedTableVIew.m
//  TableVIew_Reuse
//
//  Created by Alain Hsu on 2019/4/23.
//  Copyright © 2019 alain.hsu. All rights reserved.
//

#import "IndexedTableVIew.h"
#import "ViewReusePool.h"

@interface IndexedTableVIew () {
    UIView *_containerView;
    ViewReusePool *_reusePool;
}
@end

@implementation IndexedTableVIew

- (void)reloadData {
    [super reloadData];
    
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = [UIColor whiteColor];
        
        [self.superview insertSubview:_containerView aboveSubview:self];
    }
    
    if (_reusePool == nil) {
        _reusePool = [ViewReusePool new];
    }
    
    [_reusePool reset];
    
    [self reloadIndexedBar];
}

- (void)reloadIndexedBar {
    NSArray <NSString *> * arrayTitles = nil;
    if ([self.indexedDataSource respondsToSelector:@selector(indexTitlesForIndexTableView:)]) {
        arrayTitles = [self.indexedDataSource indexTitlesForIndexTableView:self];
    }
    
    if (!arrayTitles || arrayTitles.count <= 0) {
        [_containerView setHidden:YES];
        return;
    }
    
    NSInteger count = arrayTitles.count;
    CGFloat buttonWidth = 60;
    CGFloat buttonHeight = self.frame.size.height / count;
    
    for (int i = 0; i < [arrayTitles count]; i ++) {
        NSString *title = [arrayTitles objectAtIndex:i];
        
        UIButton *button = (UIButton *)[_reusePool dequeueReusableView];
        if (button == nil) {
            button = [[UIButton alloc] initWithFrame:CGRectZero];
            button.backgroundColor = [UIColor whiteColor];
            
            [_reusePool addUsingView:button];
            NSLog(@"Create a new Button");
            
        }else {
            NSLog(@"Button is reused");
        }
        
        [_containerView addSubview:button];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button setFrame:CGRectMake(0, i *buttonHeight, buttonWidth, buttonHeight)];
    }
    
    [_containerView setHidden:NO];
    _containerView.frame = CGRectMake(self.frame.origin.x + self.frame.size.width - buttonWidth, self.frame.origin.y, buttonWidth, self.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
