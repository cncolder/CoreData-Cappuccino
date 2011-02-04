
/*!
    Create a managed object model from a JSON Schema.
*/
@implementation CPManagedObjectModel (CPManagedObjectModelJSONSchema)

+(id)modelWithJSONSchemas:(CPArray)schemas
{
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
            var entity = [CPEntityDescription entityWithJSONSchema:schema];
            [self addEntity:entity];
        }
    }
    return self;
}

@end

