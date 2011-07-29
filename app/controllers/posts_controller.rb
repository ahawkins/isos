class PostsController < ApplicationController
  respond_to :json, :html

  def index
    @post = Post.with_picture.first

    respond_with @post do |wants|
      wants.html
      wants.json { render :json => @post.all }
    end
  end

  def pictures
    @posts = Post.with_picture.all

    respond_with @posts
  end

  def music
    @posts = Post.with_track.all

    respond_with @posts
  end
end
