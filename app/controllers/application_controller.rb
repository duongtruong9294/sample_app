# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found?

  include SessionsHelper
  def hello
    render html: "hello, world!"
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def page_not_found?
    render file: "#{Rails.root}/public/404.html", status: 403, layout: false
  end

  private
  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".please_login"
    redirect_to login_path
  end
end
