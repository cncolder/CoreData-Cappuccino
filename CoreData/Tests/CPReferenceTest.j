
@import <OJUnit/OJTestCase.j>
@import "../CPReference.j"


@implementation CPReferenceTest : OJTestCase

-(void)testReferenceWithObject
{
    var ref = [CPReference referenceWithObject:[ReferenceTestClass new]];
    [self assert:1
          equals:[ref aMethod:1]];
}

-(void)testReferenceWithClass
{
    var ref = [CPReference referenceWithClass:ReferenceTestClass];
    [self assert:1
          equals:[ref aMethod:1]];
}

-(void)testReferenceSetObject
{
    var ref = [CPReference new];
    [ref setObject:[ReferenceTestClass new]];
    [self assert:1
          equals:[ref aMethod:1]];
}

-(void)testReferenceIsNil
{
    var ref = [CPReference new];
    [self assertTrue:[ref isNil]];
}

-(void)testReferenceIsNotNil
{
    var ref = [CPReference new];
    [ref setObject:[ReferenceTestClass new]];
    [self assertFalse:[ref isNil]];
}

-(void)testSendMessageToNil
{
    var ref = [CPReference new];
    [self assertNull:[ref aMethod:1]];
}

@end


@implementation ReferenceTestClass : CPObject

-(id)aMethod:(id)aValue
{
    return aValue;
}

@end

