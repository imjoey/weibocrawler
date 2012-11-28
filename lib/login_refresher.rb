require 'selenium-webdriver'

# initialize the global variables
driver = Selenium::WebDriver.for :firefox
wait = Selenium::WebDriver::Wait.new(:timeout => 60)

loop do
  # then visit the /index to refresh code
  driver.get 'http://localhost:4567/connect'
  sleep 36000
end

driver.quit
