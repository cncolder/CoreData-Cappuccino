
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
    var attr = [[CPJSONSchemaAttributeDescription alloc] init];
    [attr setName:name];
    [attr setEntity:self];
    [attr setRawJSON:aPropertyObject];
    var type = aPropertyObject.type;
    if (type == undefined)
    {
        type = aPropertyObject["enum"];
        if (type != undefined)
        {
            type = "enum";
            [attr setEnumValues:aPropertyObject["enum"]];
        };
    }
    [attr setTypeValue:[self _typeWithJSONSchemaTypeName:type]];
    [attr setClassValue:nil];
    [attr setIsOptional:aPropertyObject.required ? NO : YES];
    [attr setDefaultValue:aPropertyObject["default"] || nil];
    [attr setValueTransformerName:aPropertyObject["format"] || nil];
    [attr setValueFormat:aPropertyObject["format"] || nil];
    [self addProperty:attr];
}

-(int)_typeWithJSONSchemaTypeName:(CPString)aType
{
    var result = JSONSchemaTypeToCoreDataType[aType];
    if (result != undefined)
        return result;
    return CPDUndefinedAttributeType;
};

@end

var JSONSchemaTypeToCoreDataType = {}
JSONSchemaTypeToCoreDataType["string"] = CPDStringAttributeType;
JSONSchemaTypeToCoreDataType["object"] = CPDBinaryDataAttributeType;
JSONSchemaTypeToCoreDataType["enum"]   = CPDBinaryDataAttributeType;

