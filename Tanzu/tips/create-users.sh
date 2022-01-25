#!/bin/bash
#bdereims@gmail.com


for LINE in $(seq -f "%02g" 1 6) 
do
	USERNAME="room${LINE}"
	echo ${USERNAME}
	useradd -U -G docker -m -s /bin/bash ${USERNAME}
	chpasswd <<<"${USERNAME}:${USERNAME}"
	su - ${USERNAME} -c "git clone https://github.com/thecatpower/VMCwithHCX-Tanzu"
done

exit 0
