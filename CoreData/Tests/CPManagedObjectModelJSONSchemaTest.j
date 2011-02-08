
@import <OJUnit/OJTestCase.j>

@import "CoreData.j"

FILE = require("file");


@implementation CPManagedObjectModelJSONSchemaTest : OJTestCase
{
}

-(void)testInitWithoutSchema
{
    var schemas = [CPDictionary dictionary];
    var model = [CPManagedObjectModel modelWithJSONSchemaURLs:schemas];
    [self assertNotNull:model];
}


-(void)testInitWithSchemaFromURL
{
    var urlBase = FILE.join(FILE.dirname(module.path), "data");
    var schemas = [[CPMutableDictionary alloc] init];
    [schemas setObject:FILE.join(urlBase, "schema1.json") forKey:"Application"];
    [schemas setObject:FILE.join(urlBase, "schema2.json") forKey:"Contract"];
    var model = [CPManagedObjectModel modelWithJSONSchemaURLs:schemas];
    [self assertNotNull:model];
    var entity = [model entityWithName:"Application"];
    [self assertNotNull:entity
                message:"Entity \"Application\" not found in model!"];
    [self assert:"kind, id, name, created, subschema, periods"
          equals:[entity propertyNames].join(", ")];
    var attr;
    var attrs = [entity attributesByName];
    attr = [attrs valueForKey:"created"];
    [self assert:"sl:rfc3339"
          equals:[attr valueTransformerName]];
    var entity = [model entityWithName:"Contract"];
    [self assertNotNull:entity
                message:"Entity \"Contract\" not found in model!"];
    [self assert:"kind, periods, created, contractor, id, name"
          equals:[entity propertyNames].join(", ")];
}


-(void)testSubschema
{
    var urlBase = FILE.join(FILE.dirname(module.path), "data");
    var schemas = [[CPMutableDictionary alloc] init];
    [schemas setObject:FILE.join(urlBase, "schema1.json") forKey:"Application"];
    var model = [CPManagedObjectModel modelWithJSONSchemaURLs:schemas];
    [self assertNotNull:model];
    var entity = [model entityWithName:"Application"];
    [self assertNotNull:entity
                message:"Entity \"Application\" not found in model!"];
    var sub = [entity subentityWithName:"subschema"];
    [self assertNotNull:sub
                message:"Subentity not found!"];
    var attr;
    var attrs = [entity attributesByName];
    attr = [attrs valueForKey:"subschema"];
    [self assert:"CoreDataJSONSchema_object"
          equals:[attr valueTransformerName]];
}

@end

