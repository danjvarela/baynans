namespace :lint do
  task :write do
    `bundle exec rubocop`
    `find #{Rails.root} -iname '*.erb' -exec bundle exec htmlbeautifier --lint-only {} \\;`
  end

  task :fix do
    `bundle exec rubocop --autocorrect`
    `find #{Rails.root} -iname '*.erb' -exec bundle exec htmlbeautifier {} \\;`
  end
end
