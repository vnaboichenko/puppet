#!/bin/bash

for node in `ls | grep -v yaml | grep -v sh`
do
	mv $node $node.yaml
done

