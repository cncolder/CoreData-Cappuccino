
@import <Foundation/CPObject.j>


/**
    A class to be used as a transparent proxy to an object.
*/
@implementation CPReference : CPObject
{
    id _ref;
    id _refClass;
}

+(id)referenceWithClass:(Class)aClass
{
    return [[self alloc] initWithClass:aClass];
}

+(id)referenceWithObject:(id)aObject
{
    return [[self alloc] initWithObject:aObject];
}

-(id)initWithClass:(Class)aClass
{
    self = [super init];
    if (self)
    {
        _refClass = aClass;
    }
    return self;
}

-(id)initWithObject:(id)aObject
{
    self = [super init];
    if (self)
    {
        _ref = aObject;
    }
    return self;
}

-(void)object
{
    return _ref;
}

-(void)setObject:(id)aObject
{
    _ref = aObject;
}

-(BOOL)isNil
{
    return (_ref == nil);
}

- (CPMethodSignature)methodSignatureForSelector:(SEL)aSelector
{
    return YES;
}

/**
    Forward all invocations to the referenced object.

    Instantiate a new referenced object if a class was defined.
*/
- (void)forwardInvocation:(CPInvocation)anInvocation
{
    if (_ref == nil && _refClass != nil)
    {
        _ref = [_refClass new];
    }
    [anInvocation invokeWithTarget:_ref];
}

@end

