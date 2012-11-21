require 'selenium-webdriver'

# initialize the global variables
driver = Selenium::WebDriver.for :firefox
wait = Selenium::WebDriver::Wait.new(:timeout => 30)

# first open the pre-logined weibo account
driver.get 'http://m.weibo.com/joey016'
wait.until { driver.title.downcase.start_with? 'thanksjoey' }

loop do
  # then visit the /connect to refresh code
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
  puts "Page title is #{driver.title}"
  #wait.until { driver.title.downcase.start_with? 'weibo oauth2' }

  sleep 15

end

driver.quit
