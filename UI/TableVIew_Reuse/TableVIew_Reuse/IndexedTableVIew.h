//
//  IndexedTableVIew.h
//  TableVIew_Reuse
//
//  Created by Alain Hsu on 2019/4/23.
//  Copyright © 2019 alain.hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IndexedTableViewDataSource <NSObject>

- (NSArray <NSString *> *)indexTitlesForIndexTableView:(UITableView *)tableview;

@end

@interface IndexedTableVIew : UITableView

@property (nonatomic, weak) id <IndexedTableViewDataSource> indexedDataSource;

@end

NS_ASSUME_NONNULL_END
