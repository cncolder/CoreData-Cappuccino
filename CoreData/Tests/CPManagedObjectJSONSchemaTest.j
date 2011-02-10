
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

-(void)testCreateStringAttribute
{
    var entity = [model entityWithName:"Type1"];
    var obj = [entity createObject];
    [self assert:"default for string1"
          equals:[obj valueForKey:"string1"]]
    [obj setValue:"v1" forKey:"string1"];
    [self assert:"v1"
          equals:[obj valueForKey:"string1"]]
}

-(void)testCreateEnumAttribute
{
    var entity = [model entityWithName:"Type1"];
    var obj = [entity createObject];
    [self assert:"tomorrow"
          equals:[obj valueForKey:"enum1"]]
    [obj setValue:"today" forKey:"enum1"];
    [self assert:"today"
          equals:[obj valueForKey:"enum1"]]
}

-(void)testCreateObjectAttribute
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

-(void)testCreateArrayAttribute
{
    var entity = [model entityWithName:"Type1"];
    var obj = [entity createObject];
    [self assertTrue:[[obj valueForKey:"array1"] isKindOfClass:[CPArray class]]
             message:"Not an array!"]
    [obj setValue:[CPArray arrayWithObjects:"1", "2"] forKey:"array1"];
    [self assertTrue:[[obj valueForKey:"array1"] isKindOfClass:[CPArray class]]];
    [self assert:"1, 2"
          equals:[obj valueForKey:"array1"].join(', ')]
}

-(void)testSetJSONDataString
{
    var entity = [model entityWithName:"Type1"];
    var obj = [entity createObject];
    var JSON = {"string1":"From JSON"};
    [obj setJSONObject:JSON];
    [self assert:"From JSON"
          equals:[obj valueForKey:"string1"]]
}

-(void)testSetJSONDataSubobject
{
    var entity = [model entityWithName:"Type1"];
    var obj = [entity createObject];
    var JSON = {"string1":"From JSON",
                "object1":{"attr1":"attr1 from JSON"}
               };
    [obj setJSONObject:JSON];
    [self assert:[CPManagedJSONObject class]
          equals:[[obj valueForKey:"object1"] class]
         message:"Wrong class from subobject!"];
    [self assert:"attr1 from JSON"
          equals:[obj valueForKeyPath:"object1.attr1"]];
}

-(void)testSetJSONDataMissingProperties
{
    var entity = [model entityWithName:"Type1"];
    var obj = [entity createObject];
    var JSON = {};
    [obj setJSONObject:JSON];
    [self assertNull:[obj valueForKey:"missing"]
             message:"Expected null for missing string!"];
    [self assertNull:[obj valueForKey:"missingArray"]
             message:"Expected null for missing array!"];
    [self assertNull:[obj valueForKeyPath:"array1.missing"]
             message:"Expected null for missing string in subobject!"];
}

-(void)testGetJSONDataSubobject
{
    var entity = [model entityWithName:"Type1"];
    var obj = [entity createObject];
    [self assert:"{\"string1\":\"default for string1\",\"enum1\":\"tomorrow\",\"object1\":{\"attr1\":\"default for attr1\",\"transform\":\"untransformed\"},\"array1\":[]}"
          equals:[[CPData dataWithJSONObject:[obj JSONObject]] rawString]];
}

-(void)testTransformInSubobjectWithoutTransformer
{
    var entity = [model entityWithName:"Type1"];
    var obj = [entity createObject];
    [self assert:"untransformed"
          equals:[obj valueForKeyPath:"object1.transform"]]
}

-(void)testTransformInSubobjectWithTransformer
{
    [CPValueTransformer setValueTransformer:[[TestSimpleTransformer alloc] init]
                                    forName:@"TestTransformer"];
    var entity = [model entityWithName:"Type1"];
    var obj = [entity createObject];
    [self assert:"Transformed:untransformed"
          equals:[obj valueForKeyPath:"object1.transform"]]
}

@end


@implementation TestSimpleTransformer : CPValueTransformer

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

