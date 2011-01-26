
@import "../CPManagedObjectModel.j"
@import "../CPEntityDescription.j"


@implementation Tools : CPObject

+(CPManagedObjectModel)testModel
{
    var model = [[CPManagedObjectModel alloc] init];
    [model setName:"Testmodel"];
    var entityDescription = [[CPEntityDescription alloc] init];
    [entityDescription setName:"Testentity"];
    [model addEntity:entityDescription];
    return model
}

@end

