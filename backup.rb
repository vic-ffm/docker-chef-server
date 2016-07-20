#!/opt/chef-server/embedded/bin/ruby

require 'date'
require 'fileutils'

MAX_BACKUPS=10

BACKUP_DIR='/var/opt/opscode/backup'

backups = Dir["#{BACKUP_DIR}/*"]
if backups.size > MAX_BACKUPS
  count_to_delete = backups.size - MAX_BACKUPS
  backups.sort[0,count_to_delete].each do |dir|
    puts "Removing backup #{dir}"
    FileUtils.rm_r dir
  end
end

new_backup_dir = "#{BACKUP_DIR}/#{DateTime.now.strftime('%Y%m%dT%H%M%S')}"

FileUtils.mkdir_p new_backup_dir

puts "Backing up to #{new_backup_dir}"
system("cd #{new_backup_dir} && /opt/chef-server/embedded/bin/knife download --server-url https://127.0.0.1/ --user admin --key /etc/chef-server/admin.pem /") || (raise "Failed to backup to directory #{new_backup_dir}")

