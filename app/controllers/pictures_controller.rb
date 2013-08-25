class PicturesController < ApplicationController
  def wall
    picture = Post.picture params[:picture_id]

    if stale? etag: picture.id, public: true
      content = picture.image.wall.read
      send_data content, type: picture.image.file.content_type, disposition: "inline"
    end
  end

  def gallery
    picture = Post.picture params[:picture_id]

    if stale? etag: picture.id, public: true
      content = picture.image.gallery.read
      send_data content, type: picture.image.file.content_type, disposition: "inline"
    end
  end
end
