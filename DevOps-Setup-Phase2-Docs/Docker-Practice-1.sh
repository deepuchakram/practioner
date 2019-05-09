echo'
Reference: https://www.youtube.com/watch?v=PxGGeNEdb3E

Simple DevOps Setup with Jenkins+Docker+Git: 

	1. Two Ubuntu t2.small (free tier are enough for this practice) machines.
	2. Install JDK & Jenkins over the one ubuntu machine name Jenkins Server. 
	3. Install git & docker on the another ubuntu machine.
	4. Configure a Jenkins job as below.
		4.1. Trigger the Jenkins job automatically when code chek-in. (Jenkins + GitHub integration, please refer the document Jenkins-GitHub-Webhooks.doc)
		4.2. Code checkout. which should contain one index.html file, Dockerfile.
		4.3. Run the docker commands as to deploy & run the index.html file on the apache server.
'
#Note: Install Jenkins, Git, Tomcat as documnetd in Phase-1 final docs. Or you can install jenkins as below.
#Jenkins Server: AWS EC2 Ubuntu machine
#---------------
sudo apt-get update

#Install JAVA
sudo apt-get install default-jdk -y

java -version

#Install Jenkins
#In order to add the repository for the jenkins package, we need to install public key for the jenkins repo. So that ubuntu assumes its trusted repo.
sudo wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -

#Adding the jenkins pckage repo to ubuntu repo.
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'

#update all the repo packages
sudo apt-get update -y

sudo apt-get install jenkins -y

#Check whether jenkins is running
ps -ef | grep jenkins

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

#Install git
sudo apt-get install git -y
--------------------------------------------------------------------------------------------------
Test Server: Launch another AWS EC2 Ubuntu machine same as above. i.e., All Instances-->Actions(next tab to CONNECT button-->Launch More Like This. 
------------------------------
	#Docker installation
	sudo apt-get update

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

	sudo apt-get update

	apt-cache policy docker-ce

	sudo apt-get install -y docker-ce

	Jenkins slave setup: "Test server" is the slave to jenkins server. (Refer SlaveConfigForJenkins.doc)
	--------------------
	Path of the slave machine where Jenkins will create workspace: /home/ubuntu/jenkins
	Give permission to 'ubuntu' user on the folder: sudo chmod -R 777 /home/ubuntu/jenkins

	Source Code in GitHub repo:
	---------------------------
	1. index.xml: 

		<h1>Hellow Apache, ubuntu, docker!!!</h1>

	2. Writing docker file as below. 

		Dockerfile:
		-----------
		FROM ubuntu

		RUN apt-get update && apt-get install apache2 -y && service apache2 restart

		ADD index.html /var/www/html/

		CMD apachectl -D FOREGROUND

		#RUN rm -rf var/www/html/*

	Build Image: (you can keep the above files in "Test Server" and run the below commands from the same serevr manually)
	----------------
	3. Build the image with the name venkat/webpages:1.0 from the Dockerfile. The below path /home/ubuntu/jenkins/webpages contains both index.html & Dockerfile.

		sudo docker build -t venkat/webpages:1.0 "/home/ubuntu/jenkins/webpages" -f Dockerfile

	4. Run the image at the port 8080: sudo docker run -it -d -p 80:80 venkat/webpages:1.0

	5. Add a new rule to security group in the Inbound with Type: All TCP, Source: Anywhere
	   Copy the test server IP address and psate it on any broswer. ex: http://52.14.5.172/ it will load and running apache.

	sudo docker ps -a

	sudo docker kill <container-id>

	Refer Docker-Practice-2.doc to refer the Jenkins job configuration.
-------------------------------------------------------------------------------------------------

DOCKER COMMANDS:
----------------

Removing images according to a pattern:
---------------------------------------
	List: docker images -a |  grep "pattern"

		Ex: docker images -a |  grep "venkat" : List the images starts with the name venkat

	Remove the list: docker images -a | grep "pattern" | awk '{print $3}' | xargs docker rmi

Remove containers according to a pattern:
----------------------------------------

	List: docker ps -a |  grep "pattern”
	Remove: docker ps -a | grep "pattern" | awk '{print $3}' | xargs docker rmi

Remove all images: -q flag to pass the Image ID to docker rmi
-----------------
	List: docker images -a

	Remoe the List: docker rmi $(docker images -a -q)

Removing a single Container:
----------------------------
	List: docker ps -a

	Remove: docker rm ID_or_Name

Remove a container upon exit: docker run --rm image_name
-----------------------------

Remove all exited containers:
-----------------------------
	List: docker ps -a -f status=exited

	Remove: docker rm $(docker ps -a -f status=exited -q)

Remove containers using more than one filter:
---------------------------------------------
	List: docker ps -a -f status=exited -f status=created

	Remove: docker rm $(docker ps -a -f status=exited -f status=created -q)

Stop and remove all containers:
-------------------------------
	List: docker ps -a
	Stop: docker stop $(docker ps -a -q)
	Remove: docker rm $(docker ps -a -q)

Removing Volumes:
-----------------
	List: docker volume ls
	Remove one: docker volume rm volume_name

Remove dangling volumes - Docker 1.9 and later:
-----------------------------------------------
	List: docker volume ls -f dangling=true
	Remove: docker volume prune

Remove a container and its volume: docker rm -v container_name
----------------------------------