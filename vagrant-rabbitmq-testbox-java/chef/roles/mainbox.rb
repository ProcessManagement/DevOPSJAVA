# Name of the role should match the name of the file
name "mainbox"
#postgresql password: iloverandompasswordsbutthiswilldo
default_attributes(
  "nodejs" => {
    "install_method" => "package"
  },
  "java" => {
    "install_flavor" => "oracle",
    "jdk_version" => "7",
    "oracle" => {
      "accept_oracle_download_terms" => true
    }
  },
  "postgresql" => {
      "password" => {
        "postgres" => "d4dd6397cf55a4507874c3864f092a8c"
      }
  }
)

# Run list function we mentioned earlier
run_list(
    "recipe[apt]",
    "recipe[java]",
    "recipe[nodejs]",
    "recipe[rabbitmq]",
    "recipe[rabbitmq::mgmt_console]",
    "recipe[postgresql]",
    "recipe[postgresql::server]"
)
