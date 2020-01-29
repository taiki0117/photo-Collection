class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def edit
  end

  def create
    post= Post.find(params[:post_id])
    current_user.favorite(post)
    flash[:success] = 'お気に入りに追加しました。'
    redirect_to likes_user_path(current_user.id)
  end

  def destroy
    post = Post.find(params[:post_id])
    current_user.unfavorite(post)
    flash[:success] = 'お気に入りを解除しました。'
    redirect_to likes_user_path(current_user.id) #(current_user.id)で自分は何者かを示している。
  end
  
end
