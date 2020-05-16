Integral::Engine.routes.draw do
  Integral::Router.load
end

ActiveSupport::Notifications.instrument 'integral.routes_loaded'
