class PostsController < ApplicationController
  def index
    @post = Post.with_picture.first
  end

  def pictures
    @posts = Post.with_picture.all
  end

  def music
    @posts = Post.with_track.all
  end

  def places
    @posts = Post.all

    render :layout => 'places'
  end
end
