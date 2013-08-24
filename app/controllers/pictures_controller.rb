class PicturesController < ApplicationController
  def wall
    picture = Post.picture params[:picture_id]
    content = picture.image.wall.read
    send_data content, type: picture.image.file.content_type, disposition: "inline"
  end

  def gallery
    picture = Post.picture params[:picture_id]
    content = picture.image.gallery.read
    send_data content, type: picture.image.file.content_type, disposition: "inline"
  end
end
