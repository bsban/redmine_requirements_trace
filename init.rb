### File: plugins/redmine_requirements_trace/init.rb

require 'redmine'

Redmine::Plugin.register :redmine_requirements_trace do
  name 'Redmine Requirements Trace Plugin'
  author '범석 반'
  description 'Displays a traceability matrix for requirements and related work items.'
  version '0.1.0'
  url 'http://yourdomain.com/redmine_requirements_trace'
  author_url 'mailto:you@example.com'

  project_module :requirements_trace do
    permission :view_requirements_trace, { requirements_trace: [:index, :export] }, public: true
    menu :project_menu, :requirements_trace, { controller: 'requirements_trace', action: 'index' }, caption: '요구사항 추적표', after: :activity, param: :project_id
  end
end