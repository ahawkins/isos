class PostsController < ApplicationController
  respond_to :json, :html

  def index
    respond_to do |wants|
      wants.html do
        @posts = Post.with_picture.all
        render :layout => 'index'
      end
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

  def map
    @posts = Post.with_latitude_and_longitude.all

    render :layout => 'map'
  end

  def places
    @locations = Post.locations

    respond_with @locations
  end
end
