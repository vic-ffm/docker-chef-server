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
_env = Hash[ Dir['/.chef/env/*'].map { |f| [ File.basename(f), File.read(f).strip ] } ]

require 'uri'
_uri = ::URI.parse(ENV['PUBLIC_URL'] || 'https://127.0.0.1/')

# Set environment variables that may be missing when chef-server-ctl
# runs from docker exec
ENV['HOME']     ||= '/'

if _uri.port == _uri.default_port
  api_fqdn _uri.hostname
else
  api_fqdn "#{_uri.hostname}:#{_uri.port}"
end

bookshelf['external_url'] = _uri.to_s
bookshelf['url'] = _uri.to_s
nginx['enable_non_ssl'] = true
nginx['url'] = _uri.to_s
nginx['x_forwarded_proto'] = _uri.scheme
lb['fqdn'] = _uri.hostname
lb['server_name'] = _uri.hostname
