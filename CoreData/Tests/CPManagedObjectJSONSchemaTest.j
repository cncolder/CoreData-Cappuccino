
@import <OJUnit/OJTestCase.j>

@import "CoreData.j"

FILE = require("file");


@implementation CPManagedObjectJSONSchemaTest : OJTestCase
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

-(void)testStringAttribute
{
    var entity = [model entityWithName:"Type1"];
    var obj = [entity createObject];
    [self assert:"default for string1"
          equals:[obj valueForKey:"string1"]]
    [obj setValue:"v1" forKey:"string1"];
    [self assert:"v1"
          equals:[obj valueForKey:"string1"]]
}

-(void)testEnumAttribute
{
    var entity = [model entityWithName:"Type1"];
    var obj = [entity createObject];
    [self assert:"tomorrow"
          equals:[obj valueForKey:"enum1"]]
    [obj setValue:"today" forKey:"enum1"];
    [self assert:"today"
          equals:[obj valueForKey:"enum1"]]
}

-(void)testObjectAttribute
{
    var entity = [model entityWithName:"Type1"];
    var obj = [entity createObject];
    var obj1 = [obj valueForKey:"object1"];
    [self assertNotNull:obj1
                message:"Couldn't get value for \"object1\""];
    [self assert:"default for attr1"
          equals:[obj1 valueForKey:"attr1"]];
    [self assert:"default for attr1"
          equals:[obj valueForKeyPath:"object1.attr1"]];
}

-(void)testArrayAttribute
{
    var entity = [model entityWithName:"Type1"];
    var obj = [entity createObject];
    [self assert:null
          equals:[obj valueForKey:"array1"]]
    [obj setValue:[CPArray arrayWithObjects:"1", "2"] forKey:"array1"];
    [self assertTrue:[[obj valueForKey:"array1"] isKindOfClass:[CPArray class]]];
    [self assert:"1, 2"
          equals:[obj valueForKey:"array1"].join(', ')]
}

@end

