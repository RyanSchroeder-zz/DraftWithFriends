//
//  ServiceBase.h
//  WestCoastCamps
//
//  Created by Trent Ellingsen on 11/21/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ServiceCompletionBlock)(id failureObject, id object);

@interface ServiceBase : NSObject

@end
