//
//  KMCTableCellNode.h
//  KMCGeigerCounter
//
//  Created by Jonathan Ong on 20/11/14.
//  Copyright (c) 2014 Kevin Conner. All rights reserved.
//

#import "ASCellNode.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class KMCTableItem;

@interface KMCComplexTableCellNode : ASCellNode

- (instancetype)initWithItem:(KMCTableItem *)item;
@end
