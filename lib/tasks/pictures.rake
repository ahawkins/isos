namespace :pictures do
  task :upload => :environment do
    pictures = Dir['/Users/adam/Dropbox/Pictures/In Search of Sunrise/*.jpg'].each do |image|
      puts "Uploading: #{image}"
      Picture.create! :image => File.new(image)
    end
  end
end