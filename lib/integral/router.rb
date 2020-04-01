module Integral
  # Handles Integral routing
  class Router
    # Loads Integral routes
    def self.load
      draw_root
      draw_frontend
      draw_backend
    end

    # Draws root route
    def self.draw_root
      Integral::Engine.routes.draw do
        if Integral.dynamic_homepage_enabled?
          root 'pages#show'
        else
          root Integral.root_path
        end
      end
    end

    # Draws frontend routes including dynamic pages and blog routes
    def self.draw_frontend
      Integral::Engine.routes.draw do
        # Dynamic pages (URLs are rewritten in Integral::Middleware::PageRouter)
        resources :pages, only: %i[show]

        # Visitor enquiries & newsletter signups
        post 'contact', to: 'contact#contact'
        post 'newsletter_signup', to: 'contact#newsletter_signup'

        # Frontend Blog routes
        if Integral.blog_enabled?
          scope Integral.blog_namespace do
            resources :tags, only: %i[index show]
            resources :categories, only: %i[show]
          end
          # Post Routing must go after tags otherwise it will override
          resources Integral.blog_namespace, only: %i[show index], as: :posts, controller: 'posts'
        end
      end
    end

    # Draws backend routes
    def self.draw_backend
      Integral::Engine.routes.draw do
        # Backend [User Only]
        scope Integral.backend_namespace do
          # User Authentication
          devise_for :users, class_name: 'Integral::User', module: :devise

          # WYSIWYG Editor
          mount Ckeditor::Engine => '/ckeditor'
        end

        namespace :backend, path: Integral.backend_namespace do
          get '/', to: 'static_pages#dashboard', as: 'dashboard'

          # User account Profile route
          get 'account', to: 'users#account'

          # User Management
          resources :users

          # Image Management
          resources :images, as: :img

          # Page Management
          resources :pages do
            get 'list', on: :collection
            member do
              post 'duplicate'
              get 'activities', controller: 'pages'
              get 'activities/:activity_id', to: 'pages#activity', as: :activity
            end
          end

          # Activity Management
          resources :activities, only: %i[index show] do
            collection do
              post 'widget'
              post 'grid'
            end
          end

          # Post Management
          if Integral.blog_enabled?
            resources :posts do
              get 'list', on: :collection
              member do
                post 'duplicate'
                get 'activities', controller: 'posts'
                get 'activities/:activity_id', to: 'posts#activity', as: :activity
              end
              # resources :comments, only: [:create, :destroy]
            end
            resources :categories, only: %i[create edit update destroy]
          end

          # List Management
          resources :lists, except: [:show] do
            member do
              post 'duplicate'
            end
          end

          # Settings Management
          resources :settings, only: %i[index create]
        end
      end
    end
  end
end
