# -*- conf -*-

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

## Credits
# The project is heavily inspired by [3ofcoins/docker-chef-server](https://github.com/3ofcoins/docker-chef-server).
# All credit goes to the original authors.

FROM ubuntu:16.04
MAINTAINER FFMVic <support@ffm.vic.gov.au>

EXPOSE 80 443
VOLUME /var/opt/opscode

COPY install.sh /tmp/install.sh

RUN [ "/bin/sh", "/tmp/install.sh" ]

COPY init.rb /init.rb
COPY chef-server.rb /.chef/chef-server.rb
COPY logrotate /opt/opscode/sv/logrotate
COPY knife.rb /etc/chef/knife.rb
COPY backup.sh /usr/local/bin/chef-server-backup

ENV KNIFE_HOME /etc/chef

CMD [ "/opt/opscode/embedded/bin/ruby", "/init.rb" ]
