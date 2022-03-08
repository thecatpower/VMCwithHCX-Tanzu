#!/bin/bash
#bdereims@gmail.com


for LINE in $(seq -f "%02g" 1 20) 
do
	USERNAME="room${LINE}"
	deluser --remove-home ${USERNAME}
done

exit 0
