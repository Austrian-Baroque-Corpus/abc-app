#!/bin/bash

echo remove TEI namespace from root element before splitting
python scripts/python/remove_ns.py
echo split files
for file in data/editions/*_modified.xml; do
		python scripts/python/milestone.py -t pb -n {http://www.w3.org/XML/1998/namespace}id $file
		rm $file
done

echo add namespaces to root
python scripts/python/milestone_cleanup.py
echo done
