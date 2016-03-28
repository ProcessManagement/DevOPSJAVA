#vagrant-java-oracle-webdev

This is a vagrant configuration for setting up a box with a development environment
for creating Java web applications against Oracle.

## [CentOS 6.5](https://atlas.hashicorp.com/puppetlabs/boxes/centos-6.5-64-nocm)

From puppet labs though could probably be replaced with another version pretty easily.

## [Oracle JDK 7](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html)

Rather than OpenJDK. Currently uses 1.7.0_75.

## [Tomcat 6](http://tomcat.apache.org/tomcat-6.0-doc/index.html)

Includes the management console, documentation, and demo web apps. The management console's username and password is set
to `tomcat` and `password`.
  
## [Oracle XE 11.2](http://www.oracle.com/technetwork/database/database-technologies/express-edition/overview/index.html)

This must be downloaded separately currently as it requires an oracle account to obtain AFAICT. If someone has a hack to
download this in some way without an oracle account, I'd be happy to employ it.  It should be expanded so the Disk1 directory
extracts to the working directory

In order to not conflict with Tomcat, the port for the Axis web app is set to 8090. It also uses a found sql script to disable
authentication against Axis.

## General notes

The following table describes the ports that are opened on the guest vm and the forwarded posts on the host machine (other than ssh):

<table>
<thead><th>Purpose</th><th>Guest Port</th><th>Host Forwarded Port</th></thead>
<tbody>
<tr><td>Tomcat</td><td>8080</td><td>2280</td></tr>
<tr><td>Axis</td><td>8090</td><td>2290</td></tr>
<tr><td>Oracle Access</td><td>1521</td><td>1521</td></tr>
</tbody>
</table>