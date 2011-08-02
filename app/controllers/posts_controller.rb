class PostsController < ApplicationController
  respond_to :json, :html

  def index
    respond_with @post do |wants|
      wants.html { @post = Post.with_picture.first }
      wants.json { render :json => Post.all }
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

  def places
    @posts = Post.all

    render :layout => 'places'
  end
end
