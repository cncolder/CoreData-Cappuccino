
@import <OJUnit/OJTestCase.j>

@import "Tools.j"


@implementation CPManagedJSONObjectTest : OJTestCase
{
    var model;
    var original;
}

-(void)setUp
{
    var urlBase = FILE.join(FILE.dirname(module.path), "data");
    var schemas = [[CPMutableDictionary alloc] init];
    [schemas setObject:FILE.join(urlBase, "mo_schema1.json") forKey:"Type1"];
    model = [CPManagedObjectModel modelWithJSONSchemaURLs:schemas];
    var entity = [model entityWithName:"Type1"];
    original = [entity createObject];
}

-(void)testDoNotCloneLocalID
{
    var objectID = [original objectID];
    var clone = [original clone];
    [self assertTrue:[[original objectID] localID] != [[clone objectID] localID]];
}

-(void)testCloneGlobalID
{
    var objectID = [original objectID];
    [objectID setGlobalID:"myGlobalID"];
    var clone = [original clone];
    [self assertNotNull:clone];
    [self assert:"myGlobalID"
          equals:[[clone objectID] globalID]];
}

-(void)testCloneData
{
    [original setJSONObject:{"string1":"Name"}];
    var clone = [original clone];
    [self assertNotNull:clone];
    [self assert:"Name"
          equals:[clone valueForKey:"string1"]];
}

@end

