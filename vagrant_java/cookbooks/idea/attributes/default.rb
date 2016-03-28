#
# Cookbook Name:: idea
# Attributes:: default
#
# Author:: Vincent Theron <vptheron@gmail.com>
#
# Copyright 2014, Vincent Theron
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['idea']['version'] = '14.1.4'
default['idea']['group'] = 'vagrant'
default['idea']['64bits']['Xmx'] = '2048m'
default['idea']['64bits']['Xms'] = '2048m'
default['idea']['setup_dir'] = '/usr/local/bin'