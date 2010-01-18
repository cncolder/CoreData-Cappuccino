//
//  CPSet+CPDSerialization.j
//
//  Created by Raphael Bartolome on 15.01.10.
//

@import <Foundation/CPObject.j>


@implementation CPSet (CPDSerialization)


/*
 * ************
 *	XML format
 * ************
 */
+ (id)deserializeFromXML:(CPData) data withContext:(CPDContext) aContext
{
	var errorString;
	var resultSet = [[CPMutableSet alloc] init];
	var arrayFromPlist = [CPPropertyListSerialization propertyListFromData:data
															format:CPPropertyListXMLFormat_v1_0 errorDescription:errorString];
	return [CPSet deserializeFromArrayWithDictionaries:arrayFromPlist withContext:aContext];
}

- (CPData)serializeToXML:(BOOL) containsAllProperties
{	
	var errorString;
	var result = [CPPropertyListSerialization dataFromPropertyList:[self serializeToArrayWithDictionaries:containsAllProperties] 
															format:CPPropertyListXMLFormat_v1_0 errorDescription:errorString];
									
	return result;
}



/*
 * *****************
 *	280NPLIST format
 * *****************
 */
+ (id)deserializeFrom280NPLIST:(CPData) data withContext:(CPDContext) aContext
{
	var errorString;
	var resultSet = [[CPMutableSet alloc] init];
	var arrayFromPlist = [CPPropertyListSerialization propertyListFromData:data
															format:CPPropertyList280NorthFormat_v1_0 errorDescription:errorString];
															
	return [CPSet deserializeFromArrayWithDictionaries:arrayFromPlist withContext:aContext];
}


- (CPData)serializeTo280NPLIST:(BOOL) containsAllProperties
{	
	var errorString;
	var result = [CPPropertyListSerialization dataFromPropertyList:[self serializeToArrayWithDictionaries:containsAllProperties] 
															format:CPPropertyList280NorthFormat_v1_0 errorDescription:errorString];
									
	return result;
}


/*
 * ************
 *	JSON format
 * ************
 */
+ (id)deserializeFromJSON:(id) aArray withContext:(CPDContext) aContext
{
	var resultSet =  [[CPMutableSet alloc] init];
		
	var i = 0;
	for (i = 0; i < aArray.length; i++) 
	{
		var aObject = aArray[i];
		[resultSet addObject:[CPDObject deserializeFromJSON:aObject withContext:aContext]];
	}
															
	return resultSet;
}


- (CPString)serializeToJSON:(BOOL) containsAllProperties
{	
	var result = [CPString JSONFromObject:[[self serializeToArrayWithDictionaries:containsAllProperties] toJSObject]];									
	CPLog.trace("data: " + result);
	return result;
}


/*
 * ******************
 *	Dictionary format
 * ******************
 */
+ (id)deserializeFromArrayWithDictionaries:(CPArray) aArray withContext:(CPDContext) aContext
{
	var resultSet = [[CPMutableSet alloc] init];

	var objectEnum = [aArray objectEnumerator];
	var aDictionary;
	
	while(aDictionary = [objectEnum nextObject])
	{
		
		if([aDictionary isKindOfClass:[CPDictionary class]])
		{		
			[resultSet addObject:[CPDObject deserializeFromDictionary:aDictionary withContext:aContext]];
		}
		else
		{
			CPLog.error("*** Unexpected Object of type '" + [aDictionary className] + "' found in set deserialization for CoreData ***");
		}
	}
	
	return resultSet;
}


- (CPArray)serializeToArrayWithDictionaries:(BOOL) containsAllProperties
{
	var arrayFromContent = [[CPMutableArray alloc] init];
	
	var contentArray = [self allObjects];
	var objectEnum = [contentArray objectEnumerator];
	var aCPDObject;
	
	while(aCPDObject = [objectEnum nextObject])
	{
		if([aCPDObject isKindOfClass:[CPDObject class]])
		{
			[arrayFromContent addObject:[aCPDObject serializeToDictionary:containsAllProperties]];
		}
		else
		{
			CPLog.error("*** Unexpected Object of type '" + [aCPDObject className] + "' found in set serialization for CoreData ***");
		}
	}
	
	return arrayFromContent;
}


- (JSObject)toJSObject
{
	var result = [CPMutableArray new];
	
	var contentEnum = [[self allObjects] objectEnumerator];
	var aObject;
	
	while(aObject = [contentEnum nextObject])
	{
		if([aObject isKindOfClass:[CPDictionary class]] 
			|| [aObject isKindOfClass:[CPArray class]] 
			|| [aObject isKindOfClass:[CPSet class]])
		{
			[result addObject:[aObject toJSObject]];
		}
		else
		{
			[result addObject:aObject];
		}
	}
	return result;
}
@end