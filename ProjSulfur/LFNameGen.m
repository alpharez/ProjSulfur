//
//  LFNameGen.m
//  ProjSulfur
//
//  Created by Steve Clement on 5/9/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

// got this from:
// https://codereview.stackexchange.com/questions/14649/objective-c-cf-random-name-generator

#import "LFNameGen.h"

@implementation LFNameGen

@synthesize grammar = _grammar;

- (id)init {
    @throw [NSException exceptionWithName: @"NameGeneratorInit"
                                   reason: @"-init is not allowed, use -initWithGrammar: instead"
                                 userInfo: nil];
}

- (id)initWithGrammar:(NSString *)plistName
{
    self = [super init];
    if (self) {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
        self.grammar = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        
        id object = [self.grammar objectForKey:@"grammar"];
        if (![object isKindOfClass:[NSString class]]) {
            NSLog(@"initWithGrammar: Not a grammar plist");
            self = nil;
        }
        
        NSString *ver = object;
        if (![ver isEqualToString:@"NG.CF.1"]) {
            NSLog(@"initWithGrammar: plist version is wrong");
            self = nil;
        }
    }
    return self;
}

- (NSString*)name {
    return [self replaceKey:@"name"];
}

-(NSString*)replaceKey:(NSString*)input
{
    NSString *output = @"";
    NSArray *parts = [input componentsSeparatedByString:@","];
    
    if ([parts count] > 1) {
        for(NSString *part in parts) {
            output = [output stringByAppendingString:[self replaceKey:part]];
        }
    } else {
        id object = [self.grammar objectForKey:input];
        if ([object isKindOfClass:[NSString class]]) {
            output = [self replaceKey:object];
        }
        else if ([object isKindOfClass:[NSArray class]]) {
            NSUInteger randomIndex = arc4random() % [object count];
            output = [self replaceKey:[object objectAtIndex:randomIndex]];
        }
        else {
            output = input;
        }
    }
    
    return output;
}

@end
