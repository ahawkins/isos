class HomeController < ApplicationController
  def index
    #@picture = Picture.find '4e1e1c974cfad15dcf000007'
    @picture = Picture.all[rand(Picture.count)]
  end

  def music

  end

  def places

  end

  def pictures
    @pictures = Picture.all
  end

  def messages

  end
end
