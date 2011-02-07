
@implementation CPAttributeDescription (CPJSONSchemaAttributeDescription)

+(id)attributeWithJSONSchemaObject:(id)schema
                     attributeName:(CPString)aName
                            entity:(CPEntityDescription)aEntity
{
    var type = schema.type;
    type = type !== undefined && type || "object";
    var CDClass = [CPJSONSchemaAttributeDescription _classWithJSONSchemaTypeName:type];
    return [[CDClass alloc] initWithJSONSchemaObject:schema
                                                name:aName
                                              entity:aEntity];
}

@end


@implementation CPJSONSchemaAttributeDescription : CPAttributeDescription
{
    CPArray _enumValues @accessors(getter=enumValues);
    CPString _valueFormat @accessors(property=valueFormat);

    id _rawJSON @accessors(property=rawJSON);
}

/*!
    Provide the Attribute class from the JSON schema type.
*/
+(int)_classWithJSONSchemaTypeName:(CPString)aType
{
    var result = JSONSchemaTypeToCoreDataType[aType][1];
    if (result != undefined)
        return result;
    return CPDUndefinedAttributeType;
};

/*!
    Provide the CoreData type from the JSON schema type.
*/
+(int)_typeWithJSONSchemaTypeName:(CPString)aType
{
    var result = JSONSchemaTypeToCoreDataType[aType][0];
    if (result != undefined)
        return result;
    return CPDUndefinedAttributeType;
};

-(id)initWithJSONSchemaObject:(id)aPropertyObject
                         name:(CPString)aName
                       entity:(CPEntityDescription)aEntity
{
    self = [super init];
    if (self)
    {
        [self setName:aName];
        [self setEntity:aEntity];
        [self setRawJSON:aPropertyObject];
        var type = aPropertyObject.type;
        if (type === undefined)
        {
            type = aPropertyObject["enum"];
            if (type !== undefined)
            {
                type = "enum";
                [self setEnumValues:aPropertyObject["enum"]];
            };
        }
        type = type !== undefined && type || "object";
        [self setTypeValue:[[self class] _typeWithJSONSchemaTypeName:type]];
        [self setClassValue:nil];
        [self setIsOptional:aPropertyObject.required ? NO : YES];
        [self setDefaultValue:aPropertyObject["default"] || nil];
        var format = aPropertyObject["format"] || [CPString stringWithFormat:"CoreDataJSONSchema_%s", type];
        [self setValueTransformerName:format];
        [self setValueFormat:format];
        if (type == "object")
        {
            // create a subschema
            var sub = [aEntity addSubentityWithSchema:aPropertyObject
                                         forAttribute:aName];
            // and the transformer for the new entity
            var fullName = [CPCoreDataJSONSchemaObjectTransformer registerWithEntity:sub];
            [self setValueTransformerName:fullName];
        }
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

@end


/*!
    A transformer for the JSON schema type object.

    On read it returns a managed object with a entity description based on the
    properties defined in the schema.
*/
@implementation CPCoreDataJSONSchemaObjectTransformer : CPValueTransformer
{
    CPEntityDescription _entity @accessors(property=entity);
}

+ (void)initialize
{
    if (self !== [CPCoreDataJSONSchemaObjectTransformer class])
        return;

    var transformer = [[CPCoreDataJSONSchemaObjectTransformer alloc] init];
    [CPValueTransformer setValueTransformer:transformer
                                    forName:@"CoreDataJSONSchema_object"];
}

+(CPString)registerWithEntity:(CPEntityDescription)aEntity
{
    var names = [CPMutableArray array];
    var e = aEntity;
    while (e)
    {
        [names addObject:[e name]];
        e = [e parentEntity];
    }
    names.reverse();
    var baseName = names.join('_');
    var name = [CPString stringWithFormat:"CoreDataJSONSchema_%s", baseName];
    var transformer = [CPValueTransformer valueTransformerForName:name];
    if (!transformer)
    {
        transformer = [[CPCoreDataJSONSchemaObjectTransformer alloc] init];
    }
    [transformer setEntity:aEntity];
    [CPValueTransformer setValueTransformer:transformer
                                    forName:name];
    return name;
}

+(BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)reverseTransformedValue:(id)aValue
{
    return [aValue JSONObject];
}

- (id)transformedValue:(id)aValue
{
    if (aValue.isa !== undefined)
    {
        return aValue;
    }
    var result = [_entity createObject];
    [result setJSONObject:aValue];
    return result
}

@end

// "initialize" of a class will be called when the class is used the first time.
// Because the class is only be used by searching the registrations
// "initialize" will never be call.
[CPCoreDataJSONSchemaObjectTransformer class];


var JSONSchemaTypeToCoreDataType = {}
JSONSchemaTypeToCoreDataType["string"] = [CPDStringAttributeType,
                                          CPJSONSchemaAttributeDescription
                                         ];
JSONSchemaTypeToCoreDataType["object"] = [CPDTransformableAttributeType,
                                          CPJSONSchemaAttributeDescription
                                         ];
JSONSchemaTypeToCoreDataType["enum"]   = [CPDBinaryDataAttributeType,
                                          CPJSONSchemaAttributeDescription
                                         ];
JSONSchemaTypeToCoreDataType["array"]  = [CPDTransformableAttributeType,
                                          CPJSONSchemaAttributeDescription
                                         ];

