#!/bin/bash

keytool -genkey -alias tomcat -keyalg RSA -keysize 4096 -keystore keystore.jks
keytool -certreq -alias tomcat -keyalg RSA -file docker1.fuller.edu.csr -keystore ./keystore.jks
## upload csr and download certificate
keytool -import -trustcacerts -alias tomcat -file ./star_fuller_edu.p7b -keystore ./keystore.jks
## publish the cert to the docker host
scp ./keystore.jks jharwell@docker1.fuller.edu:/docker1_keystore.jks

