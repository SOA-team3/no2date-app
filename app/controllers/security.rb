# frozen_string_literal: true

require_relative './app'
require 'roda'

require 'rack/ssl-enforcer'
require 'secure_headers'

module No2Date
  # Configuration for the API
  class App < Roda
    plugin :environments
    plugin :multi_route

    # Get all formatted file names in the specified directory
    def self.get_filenames(directory, extension)
      files = Dir.glob(File.join(directory, "*#{extension}"))
      files.map { |file| File.basename(file) }
    end

    # Get js directory
    js_directory = 'app/presentation/assets/js'
    # Get all filename in JavaScript format
    js_filenames = get_filenames(js_directory, '.js')
    js_filenames = js_filenames.map { |js| "/assets/js/#{js}" }

    # Define used front-end SRC
    FONT_SRC = ["'self'", 'fonts.googleapis.com', 'kit.fontawesome.com/42d5adcbca.js'].freeze
    STYLE_SRC = [
      "'self'",
      'bootswatch.com',
      'cdnjs.cloudflare.com',
      'unpkg.com',
      'api.nepcha.com',
      'cdn.jsdelivr.net',
      '/assets/css',
      'https://unpkg.com/tailwindcss@^1.0/dist/tailwind.min.css'
    ].freeze
    SCRIPT_SRC = [
      "'self'",
      'unpkg.com',
      'buttons.github.io',
      'cdnjs.cloudflare.com',
      'api.nepcha.com',
      'cdn.jsdelivr.net',
      '/assets/js',
      'https://cdn.jsdelivr.net/gh/alpinejs/alpine@v2.x.x/dist/alpine.js'
    ].freeze

    configure :production do
      use Rack::SslEnforcer, hsts: true
    end

    ## Uncomment to drop the login session in case of any violation
    # use Rack::Protection, reaction: :drop_session
    use SecureHeaders::Middleware

    SecureHeaders::Configuration.default do |config|
      config.cookies = {
        secure: true,
        httponly: true,
        samesite: {
          lax: true
        }
      }

      config.x_frame_options = 'DENY'
      config.x_content_type_options = 'nosniff'
      config.x_xss_protection = '1'
      config.x_permitted_cross_domain_policies = 'none'
      config.referrer_policy = 'origin-when-cross-origin'

      config.csp = {
        report_only: false,
        preserve_schemes: true,
        default_src: %w['self'],
        child_src: %w['self'],
        connect_src: %w[wws:],
        img_src: %w['self'],
        font_src: FONT_SRC,
        script_src: SCRIPT_SRC + [
          '/assets/js/all.js',
          '/assets/js/plugins/chartjs.min.js',
          '/assets/js/plugins/perfect-scrollbar.min.js',
          '/assets/js/soft-ui-dashboard-tailwind.js?v=1.0.5',
          '/assets/js/calendar.js',
          '/assets/js/appointment_event.js',
          'node_modules/@material-tailwind/html/scripts/collapse.js',
          # ignore script in erb file
          "'unsafe-inline'"
        ] + js_filenames,
        style_src: STYLE_SRC,
        form_action: %w['self'],
        frame_ancestors: %w['none'],
        object_src: %w['none'],
        block_all_mixed_content: true,
        report_uri: %w[/security/report_csp_violation]
      }
    end

    route('security') do |routing|
      # POST security/report_csp_violation
      routing.post 'report_csp_violation' do
        App.logger.warn "CSP VIOLATION: #{request.body.read}"
      end
    end
  end
end
