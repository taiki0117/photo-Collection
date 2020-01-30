class PostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:edit, :update, :destroy]

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = '写真を投稿しました。'
      redirect_to root_url
    else
      @posts = current_user.feed_posts.order(id: :desc).page(params[:page]) #feed_postsでタイムラインに対応させている
      flash.now[:danger] = '写真の投稿に失敗しました。'
      render 'toppages/index'
    end
  end
  
  def edit
    @post = Post.find(params[:id]) #編集する投稿を取得
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      flash[:success] = '更新されました'
      redirect_to user_path((current_user.id))
    else
      flash.now[:danger] = '更新されませんでした'
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:success] = '写真を削除しました。'
    redirect_back(fallback_location: root_path) #アクションが実行されたページに戻る指定
  end
  
  private
  
  def post_params
    params.require(:post).permit(:content, :image)
  end
  
  def correct_user    #投稿がログインユーザーの物なのか確認している
    @post = current_user.posts.find_by(id: params[:id])
    unless @post
      redirect_to root_url
    end
  end
end
