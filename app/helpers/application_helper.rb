module ApplicationHelper
  def background_images
    folders = %w(mid_day sunrise sunset clubbing)
    folders.inject({}) do |h, folder|
      images = Dir[Rails.root.join('app', 'assets', 'images', 'suns', folder, '*.*')]
      h.merge folder => images.map {|i| "/assets/suns/#{folder}/#{File.basename(i)}" }
    end.to_json.html_safe
  end
end
