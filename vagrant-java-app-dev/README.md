vagrant-java-app-dev
====================

vagrantfile for a simple Java app development and deployment environment based on a Ubuntu 14.04 box.
Assumptions:<br />
1) Code is stored in reachable remote Git repository.<br />
2) Code is setup for build with Gradle.<br />
3) Simple conf file defining the name of the project and the Git clone URL. Must be named 'java-app-dev.conf' and stored in Vagrant directory. Example contents:<br />
<pre>
GIT_PROJ_NAME="test-project"
GIT_CLONE_URL="https://github.com/testuser/test-project.git"
</pre>
