module Integral
  # Handles Page authorization
  class PagePolicy < BasePolicy
    # @return [Symbol] role name
    def role_name
      :page_manager
    end

    def editor?
      user.role?(:page_editor) || user.admin?
    end

    def index?
      user.admin? || user.role?(%i[page_manager page_editor page_contributer page_reader])
    end

    def create?
      user.admin? || user.role?(%i[page_manager page_editor])
    end

    alias new? create?

    def update?
      user.admin? || user.role?(%i[page_manager page_editor])
    end

    alias edit? update?

    def destroy?
      user.admin? || user.role?([:page_manager])
    end

    # @return [Array] attributes the user is authorization to edit
    def permitted_attributes
      return [] unless manager? || editor?

      permitted_params = %i[title description path body status template parent_id image_id lock_version]
      permitted_params.concat Integral.additional_page_params

      permitted_params -= [:status] unless manager?
      permitted_params -= [:path] if !manager? && (editor? && !instance.draft?)
      permitted_params
    end
  end
end
