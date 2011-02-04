
@import <OJUnit/OJTestCase.j>

@import "Tools.j"


@implementation CPEntityDescriptionTest : OJTestCase
{
    CPEntityDescription entity;
}

-(void)setUp
{
    var entity = [[CPEntityDescription alloc] init];
    var attr = [[CPAttributeDescription alloc] init];
    [attr setName:"transform"];
    [attr setTypeValue:CPDTransformableAttributeType];
    [attr setValueTransformerName:"SWSTestValueTransformer"];
    [entity addProperty:attr];
}

-(void)testTransformationWithoutRegisteredTransformer
{
    [self assert:"value"
            equals:[entity transformValue:"value"
                              forProperty:"transform"]];
}

-(void)testReverseTransformationWithoutRegisteredTransformer
{
    [self assert:"value"
            equals:[entity reverseTransformValue:"value"
                                     forProperty:"transform"]];
}

-(void)testTransformationWithRegisteredTransformer
{
    [CPValueTransformer setValueTransformer:[[SWSTestValueTransformer alloc] init]
                                    forName:@"SWSTestValueTransformer"];
    [self assert:"Transformed:value"
            equals:[entity transformValue:"value"
                              forProperty:"transform"]];
}

-(void)testTransformationWithRegisteredTransformer
{
    [CPValueTransformer setValueTransformer:[[SWSTestValueTransformer alloc] init]
                                    forName:@"SWSTestValueTransformer"];
    [self assert:"Reverse:value"
            equals:[entity reverseTransformValue:"value"
                                     forProperty:"transform"]];
}

@end


@implementation SWSTestValueTransformer : CPValueTransformer

+(BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)reverseTransformedValue:(id)aValue
{
    return [CPString stringWithFormat:"Reverse:%@", aValue];
}

- (id)transformedValue:(id)aValue
{
    return [CPString stringWithFormat:"Transformed:%@", aValue];
}

@end

