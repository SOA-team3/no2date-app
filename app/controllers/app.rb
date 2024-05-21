# frozen_string_literal: true

require 'roda'
require 'slim'

module No2Date
  # Web controller for No2Date API
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views'

    # plugin :assets, css: 'style.css', path: 'app/presentation/assets'
    plugin :assets,
      css: ['nucleo-icons.css', 'nucleo-svg.css', 'perfect-scrollbar.css',
        'soft-ui-dashboard-tailwind.css', 'soft-ui-dashboard-tailwind.min.css', 'tooltips.css'],
      js:  ['all.js', 'calendar.js', ''],
      path: 'app/presentation/assets'

    plugin :public, root: 'app/presentation/public'
    plugin :multi_route
    plugin :flash


    route do |routing|
      response['Content-Type'] = 'text/html; charset=utf-8'
      @current_account = session[:current_account]

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

