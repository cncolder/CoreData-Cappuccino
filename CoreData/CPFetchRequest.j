//
//  CPFetchRequest.j
//
//  Created by Raphael Bartolome on 11.11.09.
//

@import <Foundation/CPObject.j>


@implementation CPFetchRequest : CPObject
{
    // Entity
    CPEntityDescription _entity @accessors(property=entity);

    // Fetch Contraints
    CPPredicate _predicate @accessors(property=predicate);
    CPInteger _fetchLimit @accessors(property=fetchLimit);
    CPInteger _fetchOffset @accessors(property=fetchOffset);
    CPInteger _fetchBatchSize @accessors(property=fetchBatchSize);
    CPArray _affectedStores @accessors(property=affectedStores);

    // Sorting
    CPArray _sortDescriptors @accessors(property=sortDescriptors);

    // Managing How Results Are Returned
    CPArray _propertiesToFetch @accessors(property=propertiesToFetch);

    // response data set if an error occured during a fetch
    CPError error @accessors;
}

@end

