#!/bin/bash

for i in `ls | grep -v 'erb' | grep -v 'test.sh' | grep -v conf`
do
	mv $i $i.erb
done

