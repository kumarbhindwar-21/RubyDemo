require 'watir'
require 'rspec/expectations'
include RSpec::Matchers 

browser = Watir::Browser.new :chrome
browser.goto 'https://opensource-demo.orangehrmlive.com/web/index.php/auth/login'

puts "Press Enter to close browser"
sleep 5

# enter values
browser.input(name: 'username').set('Admin')
browser.input(name: 'password').set('admin123')

# fetch values
user = browser.input(name: 'username').value
pass = browser.input(name: 'password').value

# validations
expect(user).to eq('Admin')
puts user

expect(pass).to eq('admin123')
puts pass

browser.button(type: 'submit').click

puts 'Jitendra Yadav'

browser.wait_until { |b| b.title.include?('OrangeHRM') }
puts 'Title verified after wait'

#gets
browser.close