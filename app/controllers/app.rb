# frozen_string_literal: true

require 'roda'
require 'slim'

module No2Date
  # Web controller for No2Date API
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views'

    # Get all formatted file names in the specified directory
    def self.get_filenames(directory, extension)
      files = Dir.glob(File.join(directory, "*#{extension}"))
      files.map { |file| File.basename(file) }
    end

    # Get js directory
    js_directory = 'app/presentation/assets/js'
    # Get all filename in JavaScript format
    js_filenames = get_filenames(js_directory, '.js')

    css_directory = 'app/presentation/assets/css'
    css_filenames = get_filenames(css_directory, '.css')

    # plugin :assets, css: 'style.css', path: 'app/presentation/assets'
    plugin :assets,
           css: css_filenames,
           js: js_filenames,
           path: 'app/presentation/assets'

    plugin :public, root: 'app/presentation/public'
    plugin :multi_route
    plugin :flash

    route do |routing|
      response['Content-Type'] = 'text/html; charset=utf-8'
      @current_account = CurrentSession.new(session).get(:current_account)

      routing.public
      routing.assets
      routing.multi_route

      # GET /
      routing.root do
        view 'home', locals: { current_account: @current_account }
      end
    end
  end
end
