#!/bin/bash

keytool -genkey -keyalg RSA -alias tomcat -keystore ./keystore.jks -storepass changeit -validity 1000 -keysize 4096
