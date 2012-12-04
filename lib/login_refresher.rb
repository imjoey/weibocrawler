require 'selenium-webdriver'

# initialize the global variables
driver = Selenium::WebDriver.for :firefox
wait = Selenium::WebDriver::Wait.new(:timeout => 60)

count = 100
loop do
  # then visit the /connect to refresh code
  if count == 100
    driver.get 'http://localhost:4567/connect'
    wait.until { driver.title.start_with? 'weibo oauth2' }
    count = 0
  end

  # load statuses into mongodb
  driver.get 'http://localhost:4567/statuses'
  wait.until { driver.body.start_with? 'Add' }

  # every 6 minues do the statuses loading
  sleep 360
  count = count + 1
end

driver.quit
