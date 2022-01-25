#!/bin/bash
#bdereims@gmail.com


for LINE in $(seq -f "%02g" 1 6) 
do
	USERNAME="room${LINE}"
	echo ${USERNAME}
	useradd -U -G docker -m -s /bin/bash ${USERNAME}
	chpasswd <<<"${USERNAME}:${USERNAME}"
	su - ${USERNAME} -c "git clone https://github.com/thecatpower/VMCwithHCX-Tanzu"
	cp /home/grease-monkey/VMCwithHCX-Tanzu/Tanzu/env /home/${USERNAME}/VMCwithHCX-Tanzu/Tanzu/.
	cp /home/grease-monkey/VMCwithHCX-Tanzu/Tanzu/password /home/${USERNAME}/VMCwithHCX-Tanzu/Tanzu/.
	chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/VMCwithHCX-Tanzu/Tanzu/*
done

exit 0
