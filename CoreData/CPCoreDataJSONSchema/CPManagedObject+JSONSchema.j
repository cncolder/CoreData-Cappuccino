
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
	_data = [_entity initialData];
}

/**
    Replace the object data with data from a JSObject.
*/
-(void)setJSONObject:(id)JSONObject
{
    [self _setData:[CPManagedJSONObject _objjObjectWithJSONObject:JSONObject
                                                        forEntity:[self entity]]];
}

/**
    Provide the object data as JSObject.
*/
-(id)JSONObject
{
    return [CPManagedJSONObject _JSONObjectWithObjjObject:[self data]
                                               withEntity:[self entity]];
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
        [existing setObject:[asDictionary valueForKey:key]
                     forKey:key];
    }
}

/*!
    Provide a objective-j object from a JSON-Object.
*/
+(CPObject)_objjObjectWithJSONObject:(id)JSONObject
                           forEntity:(CPEntityDescription)aEntity
{
    return [self _objjObjectWithJSONObject:JSONObject
                                 forEntity:aEntity
                               forProperty:nil];
}

+(CPObject)_objjObjectWithJSONObject:(id)JSONObject
                           forEntity:aEntity
                         forProperty:(CPString)propName
{
    if (JSONObject == nil)
    {
        return JSONObject;
    }
    if (JSONObject instanceof Array)
    {
        for (var i=0; i < JSONObject.length; i++)
        {
            var old = [JSONObject objectAtIndex:i];
            var value = [CPManagedJSONObject _objjObjectWithJSONObject:old
                                                             forEntity:aEntity
                                                           forProperty:propName];
            if (value !== old)
            {
                [JSONObject replaceObjectAtIndex:i
                                      withObject:value];
            }

        }
        return JSONObject;
    }
    if ((typeof JSONObject) == typeof {})
    {
        var result = nil;
        // provide as a managed object
        if (propName)
        {
            // we must use the subentity for the property
            //TODO: what shall we do if we have no subentity
            aEntity = [aEntity subentityWithName:propName];
            result = [aEntity createObject];
        }
        else
        {
            // the root object must be a dictionary
            result = [CPMutableDictionary dictionary];
        }
        var e = [[aEntity properties] objectEnumerator];
        var property;
        while ((property = [e nextObject]) != nil)
        {
            var key = [property name];
            var value = JSONObject[key];
            if (value === undefined)
            {
                value = [property defaultValue];
            }
            value = [CPManagedJSONObject _objjObjectWithJSONObject:value
                                                         forEntity:aEntity
                                                       forProperty:key];
            [result setValue:value
                      forKey:key];
        }
        return result;
    }
    // no conversion needed
    return JSONObject;
}

+(id)_JSONObjectWithObjjObject:(id)objjObject
                    withEntity:(CPEntityDescription)aEntity
{
    return [CPManagedJSONObject _JSONObjectWithObjjObject:objjObject
                                               withEntity:aEntity
                                              forProperty:nil];
}

+(id)_JSONObjectWithObjjObject:(id)objjObject
                    withEntity:aEntity
                   forProperty:(CPString)propName
{
    if ([objjObject isKindOfClass:[CPArray class]])
    {
        if (objjObject.length == 0)
        {
            var property = [aEntity propertyWithName:propName];
            if ([property isOptional])
            {
                objjObject = nil;
            }
        }
        else
        {
            aEntity = [aEntity subentityWithName:propName];
            for (var i=0; i < objjObject.length; i++)
            {
                var old = [objjObject objectAtIndex:i],
                    value = [CPManagedJSONObject _JSONObjectWithObjjObject:old
                                                                withEntity:aEntity
                                                               forProperty:propName];
                if (value !== old)
                {
                    [objjObject replaceObjectAtIndex:i
                                          withObject:value];
                }

            }
        }
        return objjObject;
    }
    if ([objjObject isKindOfClass:[CPDictionary class]])
    {
        if (propName)
        {
            // we must use the subentity for the property
            //TODO: what shall we do if we have no subentity
            aEntity = [aEntity subentityWithName:propName];
        }
        var result = {},
            e = [[aEntity properties] objectEnumerator],
            property;
        while ((property = [e nextObject]) != nil)
        {
            var key = [property name];
            var value = [objjObject valueForKey:key];
            if (value === undefined || value == nil)
            {
                if ([property isOptional])
                {
                    value = nil;
                }
                else
                {
                    value = [property defaultValue];
                }
            }
            if (![property isOptional] || value != nil)
            {
                value = [CPManagedJSONObject _JSONObjectWithObjjObject:value
                                                            withEntity:aEntity
                                                           forProperty:key];
                if (![property isOptional] || value != nil)
                {
                    result[key] = value;
                }
            }
        }
        return result
    }
    if ([objjObject isKindOfClass:[CPManagedJSONObject class]])
    {
        return [objjObject JSONObject];
    }
    return objjObject;
}

@end

