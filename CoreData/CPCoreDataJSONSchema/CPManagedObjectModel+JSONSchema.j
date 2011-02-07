
/*!
    Create a managed object model from a JSON Schema.
*/
@implementation CPManagedObjectModel (CPManagedObjectModelJSONSchema)

+(id)modelWithJSONSchemas:(CPArray)schemas
{
    return [[self alloc] initWithJSONSchemas:schemas];
}

/*!
    Load the schemas from URLs.
*/
+(id)modelWithJSONSchemaURLs:(CPArray)URLs
{
    var iter = [URLs objectEnumerator],
        schemas = [CPMutableArray array];
    while (URL = [iter nextObject])
    {
        var request = [[CPURLRequest alloc] initWithURL:[CPURL URLWithString:URL]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        var data = [CPURLConnection sendSynchronousRequest:request returningResponse:nil];
        [schemas addObject:[data rawString]];
    }
    return [[self alloc] initWithJSONSchemas:schemas];
}

-(id)initWithJSONSchemas:(CPArray)schemas
{
    self = [self init];
    if (self)
    {
        var iter = [schemas objectEnumerator],
            schema;
        while (schema=[iter nextObject])
        {
            var entity = [CPEntityDescription entityWithJSONSchema:[schema objectFromJSON]];
            [self addEntity:entity];
        }
    }
    return self;
}

@end

