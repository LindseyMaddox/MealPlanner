class ApplicationController < ActionController::Base
 # protect_from_forgery with: :exception
 #we have to do this because otherwise we get a token authentication issue. This is how to do on cross platform posting
  protect_from_forgery with: :null_session
end
