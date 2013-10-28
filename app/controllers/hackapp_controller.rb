class HackappController < ActionController::Base
  helper_method :current_account, :account_signed_in?, :guest?, :role_signed_in?

  def current_account
    return nil if !session.key? "account_id"
    @current_account ||= Account.find_by_id(session[:account_id])
  end

  def guest_access_only
    redirect_to home_path if account_signed_in?
  end

  def account_access_only
    redirect_to home_path unless account_signed_in?
  end

  def applicant_access_only
    role_access_only Role::APPLICANT
  end

  def school_admin_access_only
    role_access_only Role::SCHOOL_ADMIN
  end

  def super_admin_access_only
    role_access_only Role::SUPER_ADMIN
  end

  def role_access_only role
    redirect_to home_path unless role_signed_in? role
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

end
