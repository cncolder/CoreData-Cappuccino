
@implementation CPManagedObject (CPManagedJSONObject)

/*!
    Provide a managed object with raw JSON data.

    The entity must provide a managed object which responds to setJSONObject.
*/
+(id)objectWithJSONObject:(id)JSONObject
                   entity:(CPEntityDescription)aEntity
{
    var result = [aEntity createObject];
    if (result)
    {
        [result setJSONObject:JSONObject];
    }
    return result
}

@end


/*!
    A managed object which works with raw JSON data.
*/
@implementation CPManagedJSONObject : CPManagedObject

+(id)objectWithObject:(CPManagedObject)object
{
    return [[self alloc] initWithObject:object];
}

-(id)initWithObject:(CPManagedObject)object
{
    self = [super initWithEntity:[object entity]];
    if (self)
    {
        var props = [[self entity] propertyNames];
        var i=0;
        for (;i < [props count]; i++)
        {
            var name = props[i];
            [self setValue:[object valueForKey:name] forKey:name];
        }
    }
    return self;
}

/**
    Replace the object data with data from a JSObject.

    Special transformations:
        Properties with names starting with "_" are renamed to "ESCAPED_..."
        because it is not possible to have property names starting with "_"
        in the entity description created using XCode.
*/
-(void)setJSONObject:(id)jsonObject
{
    var asDictionary = [CPDictionary dictionaryWithJSObject:jsonObject];
    var keys = [[asDictionary allKeys] objectEnumerator];
    var key;
    while ((key = [keys nextObject]) != nil)
    {
        if ([key characterAtIndex:0] == "_")
        {
            var newKey = [CPString stringWithFormat:@"ESCAPED%s", key];
            [asDictionary setObject:[asDictionary valueForKey:key]
                             forKey:newKey];
            [asDictionary removeObjectForKey:key];
        }
    }
    // Use the data untransformed.
    [self _setData:asDictionary];
}

/**
    Provide the object data as JSObject.
*/
-(id)JSONObject
{
    var result = {};
    var asDictionary = [CPDictionary dictionaryWithDictionary:[self data]];
    var keys = [[asDictionary allKeys] objectEnumerator];
    var key;
    while ((key = [keys nextObject]) != nil)
    {
        var targetKey = key;
        if ([key rangeOfString:"ESCAPED"].location == 0)
        {
            var targetKey = [key substringFromIndex:7];
        }
        var value = [asDictionary valueForKey:key];
        if (   value != nil
            && value["isa"] != undefined
            && [value isKindOfClass:[CPNull class]]
           )
            result[targetKey] = nil;
        else
            result[targetKey] = [asDictionary valueForKey:key];
    }
    return result;
}

-(void)setRawData:(CPDictionary)aDictionary
{
    [self _setData:aDictionary];
}

/**
    Update the object with data from a JSObject.

    Doesn't remove existing attributes, just replaces existing data with data
    from the JSON object.
*/
-(void)updateWithJSONObject:(id)jsonObject
{
    var asDictionary = [CPDictionary dictionaryWithJSObject:jsonObject];
    var existing = [self data];
    var keys = [[asDictionary allKeys] objectEnumerator];
    var key;
    while ((key = [keys nextObject]) != nil)
    {
        var newKey = key;
        if ([key characterAtIndex:0] == "_")
        {
            newKey = [CPString stringWithFormat:@"ESCAPED%s", key];
        }
        [existing setObject:[asDictionary valueForKey:key]
                     forKey:newKey];
    }
}

@end

