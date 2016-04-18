class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build if logged_in?
    @feed_items = current_user.feed_items.order(created_at: :desc).page(params[:page]).per(7)
  end
end