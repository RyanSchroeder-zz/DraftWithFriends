//
//  RepositoryBase.h
//  WestCoastCamps
//
//  Created by Trent Ellingsen on 11/21/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RepositoryCompletionBlock)(id failureObject, id object);

@interface RepositoryBase : NSObject

@end
