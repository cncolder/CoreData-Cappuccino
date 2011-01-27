
@import <Foundation/CPArray.j>
@import <Foundation/CPDictionary.j>
@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>


CPPOSIXErrorDomain=@"CPPOSIXErrorDomain";
CPOSStatusErrorDomain=@"CPOSStatusErrorDomain";
CPWICPOCKErrorDomain=@"CPWICPOCKErrorDomain";
CPWin32ErrorDomain=@"CPWin32ErrorDomain";
CPCocoaErrorDomain=@"CPCocoaErrorDomain";

CPUnderlyingErrorKey=@"CPUnderlyingErrorKey";
CPLocalizedDescriptionKey=@"CPLocalizedDescriptionKey";
CPLocalizedFailureReasonErrorKey=@"CPLocalizedFailureReasonErrorKey";
CPLocalizedRecoveryOptionsErrorKey=@"CPLocalizedRecoveryOptionsErrorKey";
CPLocalizedRecoverySuggestionErrorKey=@"CPLocalizedRecoverySuggestionErrorKey";
CPRecoveryAttempterErrorKey=@"CPRecoveryAttempterErrorKey";


@implementation CPError : CPObject
{
    CPString _domain @accessors(getter=domain);
    CPNumber _code @accessors(getter=code);
    CPDictionary _userInfo @accessors(getter=userInfo);
}

+(id)errorWithDomain:(CPString)domain
                code:(CPNumber)code
            userInfo:(CPDictionary)userInfo
{
    return [[self alloc] initWithDomain:domain
                                   code:code
                               userInfo:userInfo];
}

- (id)initWithDomain:(CPString)domain
                code:(CPNumber)code
            userInfo:(CPDictionary)userInfo
{
    self = [super init];
    if (self)
    {
        _domain = domain;
        _code = code;
        _userInfo = userInfo;
    }
    return self;
}

-(CPString)localizedDescription
{
    var localizedDescription = [_userInfo objectForKey:CPLocalizedDescriptionKey];
    if (localizedDescription != nil)
    {
       return localizedDescription;
    }
    return [CPString stringWithFormat:@"CPError (%@ error %d)", _domain, _code];
}

-(CPString)localizedFailureReason {
   return [_userInfo objectForKey:CPLocalizedFailureReasonErrorKey];
}

-(CPArray)localizedRecoveryOptions {
   return [_userInfo objectForKey:CPLocalizedRecoveryOptionsErrorKey];
}

-(CPString)localizedRecoverySuggestion {
   return [_userInfo objectForKey:CPLocalizedRecoverySuggestionErrorKey];
}

-(id)recoveryAttempter {
   return [_userInfo objectForKey:CPRecoveryAttempterErrorKey];
}

-(id)description {
   return [CPString stringWithFormat:@"Error Domain=%@ Code=%d UserInfo=%@ %@",
                         _domain, _code, _userInfo, [self localizedDescription]];
}

@end

