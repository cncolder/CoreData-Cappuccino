#!/bin/sh
#
# NOTE: The working directory should be the main CoreData directory when this script is run

if [ -d CoreData.doc ]; then
    rm -rf CoreData.doc
fi

mkdir CoreData.doc

echo "Copying source files..."
cp *.j CoreData.doc
cp CPCoreDataCategories/*.j CoreData.doc
cp CPCoreDataPersistantStores/**/*.j CoreData.doc
cp CPPredicate/*.j CoreData.doc
cp NSCoreData/*.j CoreData.doc

echo "Processing source files..."
find CoreData.doc -name "*.j" -exec sed -e '/@import.*/ d' -i '' {} \;

exec documentation/make_headers

