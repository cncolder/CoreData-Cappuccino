
@import <OJUnit/OJTestCase.j>

@import "CoreData.j"

FILE = require("file");


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
"    }," +
"    \"periods\":{" +
"      \"description\":\"Contract periods\"," +
"      \"format\":\"sl:contract-periods\"," +
"      \"minItems\":1," +
"      \"items\":{" +
"        \"type\":\"object\"," +
"        \"properties\":{" +
"          \"start\":{" +
"            \"required\":true," +
"            \"type\":\"string\"," +
"            \"description\":\"The date when this period starts.\"," +
"            \"format\":\"sl:rfc3339\"" +
"          }," +
"          \"end\":{" +
"            \"required\":true," +
"            \"type\":\"string\"," +
"            \"description\":\"The date when this period ends.\"," +
"            \"format\":\"sl:rfc3339\"" +
"          }," +
"        }," +
"        \"title\":\"Contract Period\"" +
"      }," +
"      \"required\":true," +
"      \"type\":\"array\"" +
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
    [self assert:"kind, id, name, created, periods"
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
    // period
    attr = [attrs valueForKey:"periods"];
    [self assertFalse:[attr isOptional]
             message:"period must not be optional!"];
    [self assertNull:[attr defaultValue]];
    [self assert:CPDTransformableAttributeType
          equals:[attr typeValue]
         message:"Not a transformable attribute type!"];
    [self assert:"sl:contract-periods"
          equals:[attr valueTransformerName]];
}


-(void)testInitWithSchemaFromURL
{
    var urlBase = FILE.join(FILE.dirname(module.path), "data");
    var schemas = [CPMutableArray array];
    [schemas addObject:FILE.join(urlBase, "schema1.json")];
    [schemas addObject:FILE.join(urlBase, "schema2.json")];
    var model = [CPManagedObjectModel modelWithJSONSchemaURLs:schemas];
    [self assertNotNull:model];
    var entity = [model entityWithName:"Application"];
    [self assertNotNull:entity
                message:"Entity \"Application\" not found in model!"];
    [self assert:"kind, id, name, created, subschema, periods"
          equals:[entity propertyNames].join(", ")];
    var entity = [model entityWithName:"Contract"];
    [self assertNotNull:entity
                message:"Entity \"Contract\" not found in model!"];
    [self assert:"kind, periods, created, contractor, id, name"
          equals:[entity propertyNames].join(", ")];
}


-(void)testSubschema
{
    var urlBase = FILE.join(FILE.dirname(module.path), "data");
    var schemas = [CPMutableArray array];
    [schemas addObject:FILE.join(urlBase, "schema1.json")];
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
    [self assert:"CoreDataJSONSchema_Application_subschema"
          equals:[attr valueTransformerName]];
}

@end

