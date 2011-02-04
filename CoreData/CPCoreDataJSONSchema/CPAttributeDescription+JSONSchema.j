

@implementation CPJSONSchemaAttributeDescription : CPAttributeDescription
{
    CPArray _enumValues @accessors(getter=enumValues);
    CPString _valueFormat @accessors(property=valueFormat);

    id _rawJSON @accessors(property=rawJSON);
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

