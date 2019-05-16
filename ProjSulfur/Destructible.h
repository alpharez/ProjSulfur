//
//  Destructible.h
//  ProjSulfur
//
//  Created by Steve Clement on 5/12/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Destructible <NSObject>

@property(nonatomic, readwrite) Boolean isDestroyed;

@end

NS_ASSUME_NONNULL_END
