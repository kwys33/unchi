require "json" 
require "open-uri"

class PostsController < ApplicationController
  before_action :authenticate_user

  def index
    @posts = Post.where(user_id: @current_user.id)
    api_key = "e790cb63ccb9d5a53515a0b22361d69d"
    base_url = "http://api.openweathermap.org/data/2.5/weather"
    response = open(base_url + "?zip=195-0062,jp&APPID=#{api_key}")
    results = JSON.parse(response.read)
      puts results ["weather"][0]["main"]


  end

  def show
    @posts = Post.find_by(id:params[:id])
    @user = @posts.user
  end

  def create
    @posts = Post.new(
      memo:params[:memo],
      when:params[:when],
      date:params[:date],
      user_id: @current_user.id
    )
    @posts.save
    flash[:notice] = "投稿しました"
    redirect_to("/posts/index")
  end

  def edit
    @posts = Post.find_by(id: params[:id])
  end

  def update
    @posts = Post.find_by(id:params[:id])
    @posts.memo = params[:memo]
    @posts.date = params[:date]
    @posts.when = params[:when]
    if @posts.save
      flash[:notice] = "編集しました"
      redirect_to("/posts/index")
    else
      render("posts/edit")
    end
  end

  def destroy
    @posts = Post.find_by(id: params[:id])
    @posts.destroy
    flash[:notice] = "削除しました"
    redirect_to("/posts/index")
  end  

end
