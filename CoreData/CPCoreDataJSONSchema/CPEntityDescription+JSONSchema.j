
/*!
    Create a managed object model from a JSON Schema.
*/
@implementation CPEntityDescription (CPEntityDescriptionJSONSchema)

+(id)entityWithJSONSchema:(CPString)schema
{
    return [[CPJSONSchemaEntityDescription alloc] initWithJSONSchema:schema];
}

@end


@implementation CPJSONSchemaEntityDescription : CPEntityDescription
{
    id _rawJSON @accessors(property=rawJSON);
}

-(id)initWithJSONSchema:(CPString)schema
{
    self = [self init];
    if (self)
    {
        //TODO: validate the schema against the JSON schema spec
        // read the schema
        _rawJSON = [schema objectFromJSON];
        [self setName:_rawJSON.title];
        var properties = _rawJSON.properties;
        for (var name in properties)
        {
            var property = properties[name];
            [self addAttributeWithSchemaWithName:name
                                        property:property];
        };
    }
    return self;
}

-(void)addAttributeWithSchemaWithName:(CPString)name
                             property:(id)aPropertyObject
{
    var attr = [CPAttributeDescription attributeWithJSONSchemaObject:aPropertyObject];
    [attr setName:name];
    [attr setEntity:self];
    [self addProperty:attr];
}

@end

