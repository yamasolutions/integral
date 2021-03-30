module Integral
  module Backend
    # Users controller
    class UsersController < BaseController
      before_action :set_resource, except: %i[create new index list account]
      before_action :authorize_with_klass, except: %i[activities activity show edit update account notifications read_notification read_all_notifications]
      before_action :authorize_with_instance, only: %i[show edit update]

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
        @resource = User.new(resource_params)

        if @resource.valid?
          @resource = User.invite!(resource_params, current_user)
          respond_successfully(notification_message('creation_success'), backend_user_path(@resource))
        else
          respond_failure(notification_message('creation_failure'), 'new')
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

      # GET /:id/notifications
      def notifications
        load_more_url = notifications_backend_user_url(current_user, page: current_page+1) if current_user.notifications.count > current_page * Notification::Notification.per_page
        render json: { content: render_to_string(current_user.notifications.recent.page(current_page).decorate, cached: true), load_more_url: load_more_url }
      end

      # PUT /:id/read_notification
      def read_notification
        if current_user.notifications.find(params[:notification_id]).read!
          head :ok
        else
          head :unprocessable_entity
        end
      end

      # PUT /:id/read_all_notifications
      def read_all_notifications
        if current_user.notifications.unread.update_all(read_at: Time.now)
          head :ok
        else
          head :unprocessable_entity
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

      def current_page
        params[:page].to_i
      end

      def white_listed_grid_params
        [ :descending, :order, :page, :name, status: [], locale: [], user: [] ]
      end

      def resource_klass
        Integral::User
      end

      def resource_params
        unless params[:user][:password].present?
          return params.require(:user).permit(:name, :email, :avatar, :locale, :notify_me, role_ids: [])
        end

        params.require(:user).permit(:name, :email, :avatar, :locale, :notify_me, :password, :password_confirmation, role_ids: [])
      end

      def authorize_with_instance
        authorize @resource
      end
    end
  end
end
