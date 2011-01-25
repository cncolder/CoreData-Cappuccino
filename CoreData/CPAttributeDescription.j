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

TypeNames = {
    CPDUndefinedAttributeType : "CPDUndefinedAttributeType",
    CPDIntegerAttributeType : "CPDIntegerAttributeType",
    CPDInteger16AttributeType : "CPDInteger16AttributeType",
    CPDInteger32AttributeType : "CPDInteger32AttributeType",
    CPDInteger64AttributeType : "CPDInteger64AttributeType",
    CPDDecimalAttributeType : "CPDDecimalAttributeType",
    CPDDoubleAttributeType : "CPDDoubleAttributeType",
    CPDFloatAttributeType : "CPDFloatAttributeType",
    CPDStringAttributeType : "CPDStringAttributeType",
    CPDBooleanAttributeType : "CPDBooleanAttributeType",
    CPDDateAttributeType : "CPDDateAttributeType",
    CPDBinaryDataAttributeType : "CPDBinaryDataAttributeType",
    CPDTransformableAttributeType : "CPDTransformableAttributeType"
}


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
    return TypeNames[_typeValue] || TypeNames[CPDUndefinedAttributeType];
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
