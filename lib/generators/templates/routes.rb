Rails.application.routes.draw do
  # Integral Routes
  mount Integral::Engine, at: '/', as: 'integral'

  # Must specify root so that #root_url method is defined
  root to: 'integral/static_pages#home'
end
