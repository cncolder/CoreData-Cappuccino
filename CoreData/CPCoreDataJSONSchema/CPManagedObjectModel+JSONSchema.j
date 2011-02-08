
/*!
    Create a managed object model from a JSON Schema.
*/
@implementation CPManagedObjectModel (CPManagedObjectModelJSONSchema)

/*!
    Load the schemas from URLs.
*/
+(id)modelWithJSONSchemaURLs:(CPDictionary)URLs
{
    var iter = [URLs keyEnumerator],
        schemas = [[CPMutableDictionary alloc] init];
    var name;
    while (name = [iter nextObject])
    {
        var URL = [URLs objectForKey:name];
        var request = [[CPURLRequest alloc] initWithURL:[CPURL URLWithString:URL]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        var data = [CPURLConnection sendSynchronousRequest:request returningResponse:nil];
        [schemas setObject:[data rawString] forKey:name];
    }
    return [[self alloc] initWithJSONSchemas:schemas];
}

-(id)initWithJSONSchemas:(CPDictionary)schemas
{
    self = [self init];
    if (self)
    {
        var iter = [schemas keyEnumerator],
            schema;
        var name;
        while (name = [iter nextObject])
        {
            var schema = [schemas objectForKey:name];
            var entity = [CPEntityDescription entityWithJSONSchema:[schema objectFromJSON]
                                                           forName:name];
            [self addEntity:entity];
        }
    }
    return self;
}

@end

