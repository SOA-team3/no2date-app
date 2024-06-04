# frozen_string_literal: true

# Requires all ruby files in specified app folders
# Params:
# - (opt) folders: Array of root folder names, or String of single folder name
# Usage:
def require_app(folders = %w[lib models services forms controllers])
  app_list = Array(folders).map { |folder| "app/#{folder}" }
  full_list = ['config', app_list].flatten.join(',')
  Dir.glob("./{#{full_list}}/**/*.rb").each do |file|
    require file
  end
end
