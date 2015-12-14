# docker_tomcat_production
Docker Image for Deploying Grails Applications into Production

My favorite thing about this image is that you can set the environmental variables for the grails database configuration and it
will properly pass those to Tomcat in a way so that they can be used within the Grails app itself. It took me quite a while to
figure out how to get that to work.
