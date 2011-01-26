
@import <OJUnit/OJTestCase.j>

@import "../CPManagedObjectID.j"


@implementation CPManagedObjectIDTest : OJTestCase
{
}

-(void)testProperties
{
    var moID = [[CPManagedObjectID alloc] initWithEntity:nil
                                                globalID:"global1"
                                             isTemporary:YES];
    [self assert:"global1"
            equals:[moID globalID]];
    [self assertTrue:[moID isTemporary]];
}

@end

