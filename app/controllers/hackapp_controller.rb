class HackappController < ActionController::Base
  helper_method :current_account, :account_signed_in?

  def current_account
    if session.has_key? "account_id"
      @current_account ||= Account.find_by_id(session[:account_id])
    end
  end

  def guest_access_only
    redirect_to home_path if account_signed_in?
  end

  def account_access_only
    redirect_to home_path unless account_signed_in?
  end

  def applicant_access_only
    redirect_to home_path unless applicant_signed_in?
  end

  def school_admin_access_only
    redirect_to home_path unless school_admin_signed_in?
  end

  def super_admin_access_only
    redirect_to home_path unless super_admin_signed_in?
  end

  def account_signed_in?
    current_account
  end

  def applicant_signed_in?
    return nil if current_account.nil?
    current_account.has_role? Role::APPLICANT
  end

  def school_admin_signed_in?
    return nil if current_account.nil?
    current_account.has_role? Role::SCHOOL_ADMIN
  end

  def super_admin_signed_in?
    return nil if current_account.nil?
    current_account.has_role? Role::SUPER_ADMIN
  end

end
