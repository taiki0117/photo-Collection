class ToppagesController < ApplicationController
  def index
    if logged_in?
      @post = current_user.posts.build
      @posts = current_user.feed_posts.order(id: :desc).page(params[:page]) #feed_postsでタイムラインに対応させている
      #user.rbに定義されているfeed_postsメソッドを使えるのはcurrent_userユーザーの記述によってユーザーモデルを引き継いでいるから。
    end
  end
end
