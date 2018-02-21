everything has been tested on CentOS-7-x86_64-DVD-1708.iso

1. download the book.yml file
2. launch ansible-playbook with book.yml
3. download the 'dockerfile' file to the target host
4. #docker build .
5. #docker run -d -p 80:80 <image id>
