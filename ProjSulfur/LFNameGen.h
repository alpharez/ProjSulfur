//
//  LFNameGen.h
//  ProjSulfur
//
//  Created by Steve Clement on 5/9/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFNameGen : NSObject

@property (nonatomic,strong) NSDictionary *grammar;
-(NSString*)replaceKey:(NSString*)input;
-(id)initWithGrammar:(NSString *)plistName;
-(NSString*)name;
@end

NS_ASSUME_NONNULL_END
