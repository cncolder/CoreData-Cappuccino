
@import <OJUnit/OJTestCase.j>

@import "CoreData.j"


@implementation CPManagedObjectModelJSONSchemaTest : OJTestCase
{
}

-(void)testInitWithoutSchema
{
    var schemas = [CPArray array];
    var model = [CPManagedObjectModel modelWithJSONSchemas:schemas];
    [self assertNotNull:model];
}

-(void)testInitWithSchema
{
    var schemas = [CPArray array];
    [schemas addObject:
"{" +
"  \"properties\":{" +
"    \"kind\":{" +
"      \"required\":true," +
"      \"enum\":[" +
"        \"Application\"" +
"      ]," +
"      \"default\":\"Application\"" +
"    }," +
"    \"id\":{" +
"      \"required\":true," +
"      \"type\":\"string\"," +
"      \"description\":\"The id of the object, which is unique accross all objects of the same type.\"" +
"    }," +
"    \"name\":{" +
"      \"required\":true," +
"      \"type\":\"string\"," +
"      \"description\":\"The name of the object for display purposes.\"" +
"    }," +
"    \"created\":{" +
"      \"type\":\"string\"," +
"      \"description\":\"The date the object was created.\"," +
"      \"format\":\"sl:rfc3339\"" +
"    }" +
"  }," +
"  \"type\":\"object\"," +
"  \"description\":\"An application using the SWS-API\"," +
"  \"links\":[" +
"    {" +
"      \"href\":\"/applications/{id}\"," +
"      \"rel\":\"self\"" +
"    }" +
"  ]," +
"  \"title\":\"Application\"" +
"}"
];
    var model = [CPManagedObjectModel modelWithJSONSchemas:schemas];
    [self assertNotNull:model];
    var entity = [model entityWithName:"Application"];
    [self assertNotNull:entity
                message:"Entity \"Application\" not found in model!"];
    [self assert:"kind, id, name, created"
          equals:[entity propertyNames].join(", ")];
    var attrs = [entity attributesByName];
    var attr;
    // kind
    attr = [attrs valueForKey:"kind"];
    [self assertFalse:[attr isOptional]
             message:"kind must not be optional!"];
    [self assert:"Application"
          equals:[attr enumValues].join(", ")];
    [self assert:"Application"
          equals:[attr defaultValue]];
    [self assert:CPDBinaryDataAttributeType
          equals:[attr typeValue]
         message:"Not a binary data attribute type!"];
    // created
    attr = [attrs valueForKey:"created"];
    [self assertTrue:[attr isOptional]
             message:"created must be optional!"];
    [self assertNull:[attr defaultValue]];
    [self assert:CPDStringAttributeType
          equals:[attr typeValue]
         message:"Not a string attribute type!"];
    [self assert:"sl:rfc3339"
          equals:[attr valueTransformerName]];
}

@end

