#
# Jekyll posts to JSON
#
# A plugin for generating your Jekyll posts as JSON
# Still have issues with the Jekyll lifecycle
# 
# Author: Austin Breslin
# 

module Jekyll
  require 'json'

  class JSONGenerator < Generator
    safe false
    priority :low
    def generate(site)
      # Markdown converter as described in your yaml config
      converter = site.find_converter_instance(Jekyll::Converters::Markdown)

      # Iterate over all posts
      site.posts.docs.each do |post|

        # Initialize the path
        path = "./api/posts/"

        # Add categories to path if they exist
        if (post.data['categories'].class == String)
          path << post.data['categories'].tr(' ', '/')
        elsif (post.data['categories'].class == Array)
          path << post.data['categories'].join('/')
        end

        # Add the title to the path as a folder with characters unwelcomed to urls removed
        path << "/" << title = post.title.downcase.tr(' ', '-').delete("’!")

        if (!File.exists?(path))
          # Create the folder if needed 
          FileUtils.mkpath(path)
        end

        # Create the JSON file in the folder
        File.open(path << "/index.json", "w") do |f|
          f.puts(JSON.generate(converter.convert(post.content)))
          f.puts("\n")
          f.flush()
        end
      end
    end
  end
end
