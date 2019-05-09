echo'
Jenkins job setup:
1. Checkout the code.
2. Build the code with maven on another slave.
3. Deploy the code to tomcat with the help of docker.
	Dockerfile should take care of create container.
	Install tomcat on the container.
	WAR package to be deployed on to the tomcat server.
' 

echo'
Required tools:
On jenkins master: Java, Maven, Jenkins.
On Slave machine:  Java, Maven, Git, docker.
'

#Install JAVA
	sudo apt-get update

	sudo apt-get install default-jdk

	java -version

#Install maven on Ubuntu machines:

#Option-1: Download and install latest version of maven.

	sudo apt install maven

	mvn -v

#Option-2: Download the required version and set the path.

#Download and unzip
wget http://www-eu.apache.org/dist/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz

tar zxpvf apache-maven-3.5.3-bin.tar.gz

#maven home path depedns on the user: here we are running from root user.
echo maven home: /home/ubuntu/apache-maven-3.5.3

#Setup Maven
export MAVEN_HOME=/home/ubuntu/apache-maven-3.5.3

export M3=$MAVEN_HOME/bin

export PATH=$M3:$PATH

#check maven: mvn -v
echo check maven: mvn -v
mvn -v

echo'
Refer the other doc Docker-Practice-1 to install jenkins, docker, git on ubuntu machines.
'

I am not installing again sicne I installed everything as part of Practice-1.

Please refer the document Docker-Practice-2.doc file.

