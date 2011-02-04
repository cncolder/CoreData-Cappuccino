
@implementation CPAttributeDescription (CPJSONSchemaAttributeDescription)

+(id)attributeWithJSONSchemaObject:(id)schema
{
    return [[CPJSONSchemaAttributeDescription alloc] initWithJSONSchemaObject:schema];
}

@end


@implementation CPJSONSchemaAttributeDescription : CPAttributeDescription
{
    CPArray _enumValues @accessors(getter=enumValues);
    CPString _valueFormat @accessors(property=valueFormat);

    id _rawJSON @accessors(property=rawJSON);
}

-(id)initWithJSONSchemaObject:(id)aPropertyObject
{
    self = [super init];
    if (self)
    {
        [self setRawJSON:aPropertyObject];
        var type = aPropertyObject.type;
        if (type == undefined)
        {
            type = aPropertyObject["enum"];
            if (type != undefined)
            {
                type = "enum";
                [self setEnumValues:aPropertyObject["enum"]];
            };
        }
        [self setTypeValue:[self _typeWithJSONSchemaTypeName:type]];
        [self setClassValue:nil];
        [self setIsOptional:aPropertyObject.required ? NO : YES];
        [self setDefaultValue:aPropertyObject["default"] || nil];
        [self setValueTransformerName:aPropertyObject["format"] || nil];
        [self setValueFormat:aPropertyObject["format"] || nil];
    }
    return self;
}

-(void)setEnumValues:(id)values
{
    _enumValues = [CPArray arrayWithObjects:values
                                      count:values.length];
}

- (BOOL)acceptValue:(id)aValue
{
    var result = [super acceptValue:aValue];
    //TODO: use valueFormat to check the value
    return result
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

