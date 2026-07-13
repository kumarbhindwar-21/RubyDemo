require 'watir'
require 'rspec/expectations'
include RSpec::Matchers
browser=Watir::Browser.new :chrome
browser.goto 'https://opensource-demo.orangehrmlive.com/web/index.php/auth/login'
puts "Browser is launched!"
sleep 3
# enter values
browser.input(name: 'username').send_keys('Admin')
browser.input(name: 'username').send_keys('Admin')
sleep 5
puts browser.title
