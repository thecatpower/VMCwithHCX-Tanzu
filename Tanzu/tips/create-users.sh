#!/bin/bash
#bdereims@gmail.com

PASSWORD='XPday1t4'

for LINE in $(seq -f "%02g" 1 20) 
do
	USERNAME="room${LINE}"
	echo ${USERNAME}
	useradd -U -G docker -m -s /bin/bash ${USERNAME}
	chpasswd <<<"${USERNAME}:${PASSWORD}"
	cp -R /home/grease-monkey/VMCwithHCX-Tanzu /home/${USERNAME}/.
	chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/VMCwithHCX-Tanzu
done

exit 0
