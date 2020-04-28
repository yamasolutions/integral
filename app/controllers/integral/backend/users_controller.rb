module Integral
  module Backend
    # Users controller
    class UsersController < BaseController
      before_action :set_resource, except: %i[create new index list account]
      before_action :authorize_with_klass, except: %i[activities activity show edit update account]
      before_action :authorize_with_instance, only: %i[show edit update]
      before_action -> { set_grid }, only: [:index]

      # GET /
      # Lists all users
      def index
        respond_to do |format|
          format.html
          format.json do
            render json: { content: render_to_string(partial: 'integral/backend/users/grid', locals: { grid: @grid }) }
          end
        end
      end

      # GET /:id
      # Show specific user
      def show
        add_breadcrumb @resource.name, :backend_user_path
      end

      # GET /:id/edit
      # Resource edit screen
      def edit
        add_breadcrumb @resource.name, :backend_user_path
        add_breadcrumb I18n.t('integral.navigation.edit'), "edit_backend_#{controller_name.singularize}_path".to_sym
      end

      # GET /account
      # Show specific users account page
      def account
        @resource = current_user
        add_breadcrumb @resource.name, :backend_account_path

        render :show
      end

      # POST /
      # User creation
      def create
        @resource = User.invite!(resource_params, current_user)

        if @resource.errors.present?
          respond_failure(notification_message('creation_failure'), 'new')
        else
          respond_successfully(notification_message('creation_success'), backend_user_path(@resource))
        end
      end

      # PUT /:id
      # Updating a user
      def update
        authorized_user_params = resource_params
        authorized_user_params.delete(:role_ids) unless policy(current_user).manager?

        if @resource.update(authorized_user_params)
          respond_successfully(notification_message('edit_success'), backend_user_path(@resource))
        else
          respond_failure(notification_message('edit_failure'), 'edit')
        end
      end

      # PUT /:id/block
      # Block a user
      def block
        if @resource.blocked!
          respond_successfully(notification_message('edit_success'), backend_user_path(@resource))
        else
          respond_failure(notification_message('edit_failure'), 'edit')
        end
      end

      # PUT /:id/unblock
      # Unblock a user
      def unblock
        if @resource.active!
          respond_successfully(notification_message('edit_success'), backend_user_path(@resource))
        else
          respond_failure(notification_message('edit_failure'), 'edit')
        end
      end

      private

      def white_listed_grid_params
        %i[descending order page user action object name status]
      end

      def resource_klass
        Integral::User
      end

      def resource_params
        unless params[:user][:password].present?
          return params.require(:user).permit(:name, :email, :avatar, :locale, role_ids: [])
        end

        params.require(:user).permit(:name, :email, :avatar, :locale, :password, :password_confirmation, role_ids: [])
      end

      def authorize_with_instance
        authorize @resource
      end
    end
  end
end
