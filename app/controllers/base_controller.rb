class BaseController < ActionController::Base
  helper_method :current_account, :account_signed_in?, :guest?, :role_signed_in?

  protected
  
    def current_account
      @current_account ||= Account.includes(:roles).find_by_auth_token(cookies[:h_a]) if cookies[:h_a]
    end

    def guest_access_only
      not_found if account_signed_in?
    end

    def account_access_only
      not_found unless account_signed_in?
    end

    def role_access_only role
      not_found unless role_signed_in? role
    end

    def non_role_access_only role
      not_found if role_signed_in? role
    end

    def applicant_access_only
      role_access_only Role::APPLICANT
    end

    def non_applicant_access_only
      non_role_access_only Role::APPLICANT
    end

    def school_admin_access_only
      role_access_only Role::SCHOOL_ADMIN
    end

    def super_admin_access_only
      role_access_only Role::SUPER_ADMIN
    end

    def account_signed_in?
      current_account
    end

    def guest?
      current_account.nil?
    end

    def role_signed_in? role
      return nil unless current_account
      current_account.has_role? role
    end

    def current_account_for_id_only(param = nil)
      param ||= params[:id]
      not_found unless current_account and (current_account.id.to_s.eql? param.to_s)
    end

    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end

end
