app_dir = node['mamajamas']['app_dir']
ruby_version = node['mamajamas']['ruby_version']

include_recipe "rbenv"

tasks = {
  bundle: %{bundle install},
  dbmigrate: %{bundle exec rake db:migrate},
  dbseed: %{bundle exec rake db:seed},
  # import_recommended: %{bundle exec rake mamajamas:recommended_products:import:csv FILE=db/import/recommended_products.csv CONTINUE_ON_ERROR=true}
}

tasks.each do |name, task|
  rbenv_script "mamajamas_#{name}" do
    rbenv_version ruby_version
    user 'vagrant'
    group 'vagrant'
    cwd app_dir
    code task
  end
end
