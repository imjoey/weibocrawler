# encoding: utf-8
require 'selenium-webdriver'

# initialize the global variables
driver = Selenium::WebDriver.for :firefox
wait = Selenium::WebDriver::Wait.new(:timeout => 60)

# first open the pre-logined weibo account
driver.get 'http://weibo.com'
wait.until { driver.title.start_with? '新浪微博' }

loop do
  # then visit the /index to refresh code
  driver.get 'http://localhost:4567/connect'
=begin
  # fill in the user id input-field
  element = driver.find_element :name => 'userId'
  element.clear
  element.send_keys 'majunjiev@gmail.com'

  # fill in the password input-field
  element2 = driver.find_element :name => 'passwd'
  element2.clear
  element2.send_keys 'joeyyeoj321'
  element2.submit
=end

  sleep 36000

end

driver.quit
