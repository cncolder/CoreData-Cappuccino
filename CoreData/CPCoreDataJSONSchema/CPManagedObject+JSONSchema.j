
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

/*!
    Reset all values to the defaults by converting the default from JSON.
*/
- (void)_resetObjectDataForProperties
{
	_data = [[CPMutableDictionary alloc] init];
	var e = [[_entity properties] objectEnumerator];
	var property;
	while ((property = [e nextObject]) != nil)
    {
		var propName = [property name];
        var value = [property defaultValue];
        if (value != nil)
        {
            value = [CPManagedJSONObject _convertWithJSONObject:value];
        }
		[_data setObject:value forKey:propName];
	}
}

/**
    Replace the object data with data from a JSObject.

    Special transformations:
        Properties with names starting with "_" are renamed to "ESCAPED_..."
        because it is not possible to have property names starting with "_"
        in the entity description created using XCode.
*/
-(void)setJSONObject:(id)JSONObject
{
    [self _setData:[[self class] _convertWithJSONObject:JSONObject]];
}

/**
    Provide the object data as JSObject.
*/
-(id)JSONObject
{
    return [CPManagedJSONObject _JSONObjectWithObjjObject:[self data]];
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

/*!
    Provide a converted object from a JSON-Object.

    Properties are recursively replaced with CPDictionaries.

    Special transformations:
        Properties with names starting with "_" are renamed to "ESCAPED_..."
        because it is not possible to have property names starting with "_"
        in the entity description created using XCode.
*/
+(id)_convertWithJSONObject:(id)JSONObject
{
    if (JSONObject instanceof Array)
    {
        //TODO: convert array content
        return JSONObject;
    }
    if ((typeof JSONObject) == typeof {})
    {
        // provide as a CPDictionary
        var asDictionary = [CPDictionary dictionaryWithJSObject:JSONObject];
        var keys = [[asDictionary allKeys] objectEnumerator];
        var key;
        while ((key = [keys nextObject]) != nil)
        {
            var value = [asDictionary valueForKey:key];
            if ([key characterAtIndex:0] == "_")
            {
                var newKey = [CPString stringWithFormat:@"ESCAPED%s", key];
                [asDictionary setObject:value
                                 forKey:newKey];
                [asDictionary removeObjectForKey:key];
                key = newKey;
            }
            var old = value;
            value = [self _convertWithJSONObject:value];
            if (value !== old)
            {
                [asDictionary setObject:value
                                 forKey:key];
            }
        }
        return asDictionary;
    }
    // no conversion needed
    return JSONObject;
}

+(id)_JSONObjectWithObjjObject:(id)objjObject
{
    if ([objjObject isKindOfClass:[CPArray class]])
    {
        return objjObject;
    }
    if ([objjObject isKindOfClass:[CPDictionary class]])
    {
        var result = {},
            keys = [[objjObject allKeys] objectEnumerator],
            key;
        while ((key = [keys nextObject]) != nil)
        {
            var targetKey = key;
            if ([key rangeOfString:"ESCAPED"].location == 0)
            {
                targetKey = [key substringFromIndex:7];
            }
            var value = [CPManagedJSONObject _JSONObjectWithObjjObject:[objjObject valueForKey:key]];
            result[targetKey] = value;
        }
        return result
    }
    return objjObject;
}

@end

