This project is a standalone project which can crawl over the sina weibo. It mainly uses the weibo_2 and selenium libraries. The goal is to simplify grabing contents from sina weibo for developers.

# Prerequisition
1. Ruby 1.9.2 and bundler installed.
2. A graphic web browser installed, firefox and chrome are recommended.

# Usage
1. Install the required gem libraries with the input command 'bundle install' (see Gemfile for details).
2. Run the webserver which processes the token/userid storage and handles the weibo API callback, by command './apprun.sh'.
3. Run the user status refresher and data storage trigger by command 'ruby login_refresher.rb'.
4. By default, firefox will be opened and you must input the username and password to pass throught the weibo auth. There are also 2 minutes for you to open a new tab with 'weibo.com' and log in with the test account. This step is to make sure of the /connect can refresh the user check code automatically, without reinput the username and password.

# Function
This tool could load timeline tweets every 6 minutes to avoid the interface limit. Also with every 10 hours to refresh the logged in account status to keep online. 100 tweets is the max number of every 6 minutes.

# access_token自动延续方案
如果用户在授权有效期内重新打开授权页授权（如果此时用户有微博登录状态，这个页面将一闪而过），那么新浪会为开发者自动延长access_token的生命周期，请开发者维护新授权后得access_token值。

# Special Thanks
The project is based on the example codes of weibo_2, the author of which is Simsicon. Thanks to Simsicon.

