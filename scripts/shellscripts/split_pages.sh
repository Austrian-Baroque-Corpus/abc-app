#!/bin/bash

echo remove TEI namespace from root element before splitting
pipenv run python scripts/python/remove_ns.py
echo split files
for file in data/editions/*_modified.xml; do
		pipenv run python scripts/python/milestone.py -t pb -n {http://www.w3.org/XML/1998/namespace}id $file
		rm $file
done

echo add namespaces to root
pipenv run python scripts/python/milestone_cleanup.py

echo add attributes
pipenv run python scripts/python/attributes.py

echo done
