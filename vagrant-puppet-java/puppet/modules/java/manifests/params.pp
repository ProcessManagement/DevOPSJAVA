# /etc/puppet/modules/java/manifests/params.pp

class java::params {

        $java_version = $::hostname ? {
            default	=> "1.8.0_25",
        }
        $jdk_version = $::hostname ? {
            default => "8u25"
        }
        $jdk_version_beta_release = $::hostname ? {
            default => "b17",
        }
        $java_base = $::hostname ? {
            default     => "/opt/java",
        }
        $jdk_url = $::hostname ? {
            default => "http://download.oracle.com/otn-pub/java/jdk/$jdk_version-$jdk_version_beta_release/jdk-$jdk_version-linux-x64.tar.gz",
        }
}
