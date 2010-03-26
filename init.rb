require 'sortable'

##
## Run the install assets script, too, just to make sure
## But at least rescue the action in production
##
begin
  require File.dirname(__FILE__) + '/install_assets'
rescue
  raise $! unless Rails.env == 'production'
end
