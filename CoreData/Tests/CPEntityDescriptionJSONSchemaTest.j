
@import <OJUnit/OJTestCase.j>

@import "CoreData.j"

FILE = require("file");


@implementation CPEntityDescriptionJSONSchemaTest : OJTestCase
{
    var model;
}

-(void)setUp
{
    var urlBase = FILE.join(FILE.dirname(module.path), "data");
    var schemas = [[CPMutableDictionary alloc] init];
    [schemas setObject:FILE.join(urlBase, "mo_schema1.json") forKey:"Type1"];
    model = [CPManagedObjectModel modelWithJSONSchemaURLs:schemas];
}

-(void)testCreateAttributeWithSubentities
{
    var entity = [model entityWithName:"Type1"];
    var prop = [entity createAttributeWithSubentityPath:"object1"];
    [self assertNotNull:prop
                message:"Got no property!"];
    [self assert:[CPMutableDictionary class]
          equals:[prop class]
         message:"Wrong class!"];
    [self assert:"default for attr1"
          equals:[prop objectForKey:"attr1"]];
}

@end

