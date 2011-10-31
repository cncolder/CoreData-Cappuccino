//
//  CPWOStoreType.j
//
//  Created by Raphael Bartolome on 09.10.09.
//

@import <Foundation/Foundation.j>


@implementation CPWOStoreType : CPPersistentStoreType
{
}

+ (CPString)type
{
	return "CPWOStore";
}

+ (Class)storeClass
{
	return [CPWOStore class];
}

@end
