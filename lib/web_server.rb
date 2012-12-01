# encoding: utf-8

require 'weibo_2'
require 'time-ago-in-words'
require 'json'
require 'mongo'

%w(rubygems bundler).each { |dependency| require dependency }
Bundler.setup
%w(sinatra haml sass).each { |dependency| require dependency }
enable :sessions

WeiboOAuth2::Config.api_key = ENV['KEY']
WeiboOAuth2::Config.api_secret = ENV['SECRET']
WeiboOAuth2::Config.redirect_uri = ENV['REDIR_URI']

get '/' do
  client = WeiboOAuth2::Client.new
  if session[:access_token] && !client.authorized?
    token = client.get_token_from_hash({:access_token => session[:access_token], :expires_at => session[:expires_at]})

    unless token.validated?
      reset_session
      redirect '/connect'
      return
    end
  end
  if session[:uid]
    @user = client.users.show_by_uid(session[:uid])
    @statuses = client.statuses
  end
  haml :index
end

get '/connect' do
  client = WeiboOAuth2::Client.new
  redirect client.authorize_url
end

get '/callback' do
  client = WeiboOAuth2::Client.new
  access_token = client.auth_code.get_token(params[:code].to_s)
  p "^^^^^^^^^" + params[:code]
  session[:uid] = access_token.params["uid"]
  session[:access_token] = access_token.token
  session[:expires_at] = access_token.expires_at

  @user = client.users.show_by_uid(session[:uid].to_i)
  redirect '/'
end

get '/logout' do
  reset_session
  redirect '/'
end

get '/screen.css' do
  content_type 'text/css'
  sass :screen
end

# add /statuses interface to show latest statuses as the json output
get '/statuses' do
  client = WeiboOAuth2::Client.new

  # Check the session and get the token obj
  if session[:access_token] && !client.authorized?
    token = client.get_token_from_hash(
      {:access_token => session[:access_token], :expires_at => session[:expires_at]})
    unless token.validated?
      reset_session
      redirect '/connect'
      return
    end
  end

  # Get the latest statuses timeline
  if session[:uid]
    @user = client.users.show_by_uid(session[:uid])
    @statuses = client.statuses
  end

  # Create an MongoDB connection
  db = Mongo::Connection.new('localhost', 27017).db('weibo')
  status_coll = db['statuses']
  latest_id_coll = db['latest_id']

  unless session[:since_id]
      # Get the latest status id as the since_id param
    since_id = latest_id_coll.find_one()
    unless since_id
      latest_id_coll.insert({:id => 0})
      since_id = {'id' => 0}
    end
    session[:since_id] = since_id['id']
  end

  past_id = session[:since_id]
  count = 0
  @statuses.friends_timeline(
    {:since_id => session[:since_id], :count => 100}).statuses.each do |status|
      if count == 0
        latest_id_coll.update({:id => session[:since_id]},
          {'$set' => {:id => status.id}})
        session[:since_id] = status.id
      end
      status_coll.insert(status)
      count = count + 1
    end
  "Add #{count} weibo tweets with since_id=#{past_id.to_s}"
end

post '/update' do
  client = WeiboOAuth2::Client.new
  client.get_token_from_hash(
    {:access_token => session[:access_token], :expires_at => session[:expires_at]})
  statuses = client.statuses

  unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
    statuses.update(params[:status])
  else
    status = params[:status] || '图片'
    pic = File.open(tmpfile.path)
    statuses.upload(status, pic)
  end

  redirect '/'
end

helpers do
  def reset_session
    session[:uid] = nil
    session[:access_token] = nil
    session[:expires_at] = nil
  end
end