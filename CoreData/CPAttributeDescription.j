//
//  CPAttributeDescription.j
//
//  Created by Raphael Bartolome on 15.10.09.
//

@import <Foundation/Foundation.j>
@import "CPPropertyDescription.j"


CPDUndefinedAttributeType = 0;
CPDIntegerAttributeType = 100;
CPDInteger16AttributeType = 200;
CPDInteger32AttributeType = 300;
CPDInteger64AttributeType = 400;
CPDDecimalAttributeType = 500;
CPDDoubleAttributeType = 600;
CPDFloatAttributeType = 700;
CPDStringAttributeType = 800;
CPDBooleanAttributeType = 900;
CPDDateAttributeType = 1000;
CPDBinaryDataAttributeType = 1100;
CPDTransformableAttributeType = 1200;

TypeNames = {}
TypeNames[CPDUndefinedAttributeType] = "CPDUndefinedAttributeType";
TypeNames[CPDIntegerAttributeType] = "CPDIntegerAttributeType";
TypeNames[CPDInteger16AttributeType] = "CPDInteger16AttributeType";
TypeNames[CPDInteger32AttributeType] = "CPDInteger32AttributeType";
TypeNames[CPDInteger64AttributeType] = "CPDInteger64AttributeType";
TypeNames[CPDDecimalAttributeType] = "CPDDecimalAttributeType";
TypeNames[CPDDoubleAttributeType] = "CPDDoubleAttributeType";
TypeNames[CPDFloatAttributeType] = "CPDFloatAttributeType";
TypeNames[CPDStringAttributeType] = "CPDStringAttributeType";
TypeNames[CPDBooleanAttributeType] = "CPDBooleanAttributeType";
TypeNames[CPDDateAttributeType] = "CPDDateAttributeType";
TypeNames[CPDBinaryDataAttributeType] = "CPDBinaryDataAttributeType";
TypeNames[CPDTransformableAttributeType] = "CPDTransformableAttributeType";


@implementation CPAttributeDescription : CPPropertyDescription
{
    CPString _classValue;
    int      _typeValue @accessors(property=typeValue);
    id       _defaultValue @accessors(property=defaultValue);
    CPString _valueTransformerName @accessors(property=valueTransformerName);
}

- (void)setClassValue:(CPString) aClassValue
{
    _classValue = aClassValue;
}

- (Class) classValue
{
    var classType = CPClassFromString(_classValue);
    if(classType != nil)
    {
        return classType;
    }
    return [CPObject class];
}

- (CPString) classValueName
{
    return _classValue
}

- (CPString) typeName
{
    if (_typeValue)
    {
        var name = TypeNames[_typeValue];
        if (name != undefined)
            return name;
    }
    return TypeNames[CPDUndefinedAttributeType];
}

- (BOOL)acceptValue:(id) aValue
{
    return [aValue isKindOfClass:[self classValue]];
}

- (CPString)stringRepresentation
{
    var result = "\n";
    result = result + "\n";
    result = result + "-CPAttributeDescription-";
    result = result + "\n";
    result = result + "name:" + [self name] + ";";
    result = result + "\n";
    result = result + "type:" + [self typeValue] + ";";
    result = result + "\n";
    result = result + "optional:" + [self isOptional] + ";";
    return result;
}

@end
