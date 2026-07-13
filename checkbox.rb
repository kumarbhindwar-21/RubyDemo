require 'watir'
require 'rspec/expectations'
include RSpec::Matchers 

browser = Watir::Browser.new :chrome
browser.window.maximize
browser.goto 'https://demo.automationtesting.in/Register.html'
sleep 2
# #Verify checkbox is present or not
# checkbox=browser.checkbox(value: 'Cricket')
# expect(checkbox.present?).to be true
# #checkbox.click
# #Verify checkbox is checked or not
# expect(checkbox.checked?).to be false
# puts 'checkbox is not checked'
# #check the checkbox
# checkbox.set
# expect(checkbox).to be_checked
# expect(checkbox).to be_set
# #checkbox.clear
# puts 'checkbox is cleared'
# check Multiple check boxes
#browser.checkboxes(value: ['Cricket','Movies','Hockey'])
browser.checkboxes.each do |cb|
  cb.set if cb.value=='Cricket'  # check it
end
browser.checkboxes.each do |cb|
    cb.set unless cb.set?
end

gets


