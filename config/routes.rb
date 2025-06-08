
### File: plugins/redmine_requirements_trace/config/routes.rb

Rails.application.routes.draw do
  resources :projects do
    get 'requirements_trace', to: 'requirements_trace#index'
    get 'requirements_trace/export', to: 'requirements_trace#export'
  end
end