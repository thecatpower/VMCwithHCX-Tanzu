#!/bin/bash
#bdereims@vmware.com
#
# $1: file to remove 

git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch '${1} --prune-empty --tag-name-filter cat -- --all
