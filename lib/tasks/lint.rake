namespace :lint do
  task :write do
    `bundle exec standardrb`
    `find #{Rails.root} -iname '*.erb' -exec bundle exec htmlbeautifier --lint-only {} \\;`
  end

  task :fix do
    `bundle exec standardrb --fix`
    `find #{Rails.root} -iname '*.erb' -exec bundle exec htmlbeautifier {} \\;`
  end
end
