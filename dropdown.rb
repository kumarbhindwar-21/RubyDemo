require 'watir'
require 'rspec/expectations'
include RSpec::Matchers 

browser = Watir::Browser.new :chrome
browser.window.maximize
browser.goto 'https://demo.automationtesting.in/Register.html'
sleep 2
# ropdown =browser.select(id: 'Skills');
# dropdown.select('APIs')
dropdown =browser.select_list(id: 'Skills')
# dropdown.select('APIs')
# puts dropdown.selected_options.first.text
# puts "Dropdown value is: #{dropdown.selected_options.first.text}"
#Verify dropdown is selected using vaue
dropdown.options.find {|option| option.value=='Android'}.select
#Verify dropdown is selected using index
dropdown.options[2].select
expect(dropdown.selected_options.first.text).to eq('Adobe Photoshop')
puts dropdown.selected_options.first.text
#select print all options
dropdown.options.each do |option|
    puts "Option: #{option.text}"
    option.select if option.text=='C++'
end
#Deselect for multi selector
dropdown.clear('C++')
#multiple dropdown clear all
#dropdown.clear

gets