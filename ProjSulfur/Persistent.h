//
//  Persistent.h
//  ProjSulfur
//
//  Created by Steve Clement on 5/13/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Persistent <NSObject>

-(void)load;
-(void)save;

@end

NS_ASSUME_NONNULL_END
