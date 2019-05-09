
#Create an image after you installed Jenkins (as per Phase-1), ansible(as per Phase-2.1), and docker (as per Phase-2.3) and then cretae an image.
#Toi create an image, AWS console --> Services --> EC2 service --> Instances --> Select the instance which has installed with Jenkins, Docker, ansible --> Actions --> Image --> Create Image.

#Whenever you create a new instance from the your own image, start the tomcat server & docker deamon/engine.

./tomcat7/bin/startup.sh

service docker start

