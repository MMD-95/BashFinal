#!/bin/bash
#my name is abdulaziz bin nayel,
#Use centOS operating system
#main function use's case statment combained with if statment to check if user is root
main(){
uid=$( id -u )
echo -e "Please write the number of method that you want:\n1-Check host is up.\n2-hash /etc/passwd\n3-Check /etc/passwd for changes.\n4-Read /etc/passwd using a loop\n*Enter anything else then press enter to exit.\n"
read ch
case $ch in
1 ) echo -e "Enter IP:"
read ip
if [ "$ip" == "" ];then
echo -e "There is no blank IP address please Enter Something"
main
else
checkhostisup $ip
fi;;
2 ) if [ "$uid" == "0" ];then
hashpasswd
else
echo -e "Login as root to run this function"
main
fi;;
3 ) if [ "$uid" == "0" ];then
ch_hashpasswd
else
echo -e "Login as root to run this function"
main
fi;;
4 ) if [ "$uid" == "0" ];then
readpasswd
else
echo -e "Login as root to run this function"
main
fi;;
* ) echo -e "PowerHorse!!!!!!!"
exit ;;
esac
}

#this function will print the first args passed to it
print_funname() {
echo -e "############  $1  ############\n"
}

#Check if host is up
checkhostisup() {
print_funname "Checking the host"
up=$( ping -c1 $1 )
if [[ $up == *"0%"* ]]; then
  echo "Host $1 Is Up!"
else 
echo "Host $1 Is Down!"
fi
main
}

#hash /etc/passwd in text file (search the file if it does not exisit it create one)
hashpasswd(){
print_funname "Hashing etc/passwd"
if [ ! -f ./Security.txt ]; then
    touch ./Security.txt
fi
cat /etc/passwd | md5sum > ./Security.txt
echo -e "succeeded\n"
main
}

#hash /etc/passwd and compare it with the hash in the text file (if it exisit)
ch_hashpasswd(){
if [ ! -f ./Security.txt ]; then
    echo -e "there is no previous hash please use function number 2 first"
main
fi
oldHash=$( cat ./Security.txt ) 
newHash=$( cat /etc/passwd | md5sum )
if [ "$oldHash" == "$newHash" ];then
echo -e "/etc/passwd did not change\n"
else
echo -e "/etc/passwd changed\n"
fi
main

}

#this function read /etc/passwd using while loop
readpasswd(){
while read p; do
  echo $p
done </etc/passwd
main
}



main $@
