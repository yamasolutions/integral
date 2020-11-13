Rails.application.routes.draw do
  mount Integral::Engine => "/"
  root 'integal/static_pages#home'
end
