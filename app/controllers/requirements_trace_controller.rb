### File: plugins/redmine_requirements_trace/app/controllers/requirements_trace_controller.rb

require 'csv'

class RequirementsTraceController < ApplicationController
  before_action :find_project
  before_action :authorize

  def index
    load_trace_matrix
  end

  def export
    load_trace_matrix

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['요구사항', 'USECASE', '화면설계', '프로그램설계', '단위테스트', '통합테스트']
      @trace_matrix.each do |_, trace|
        csv << [
          trace[:requirement].subject,
          trace[:usecases].map(&:subject).join("; "),
          trace[:screen_designs].map(&:subject).join("; "),
          trace[:program_designs].map(&:subject).join("; "),
          trace[:unit_tests].map(&:subject).join("; "),
          trace[:integration_tests].map(&:subject).join("; ")
        ]
      end
    end

    send_data csv_data, filename: "requirements_trace_#{@project.identifier}.csv"
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def load_trace_matrix
    @requirements = @project.issues.where(tracker: Tracker.find_by(name: '요구사항'))
    @trace_matrix = @requirements.map do |req|
      trace = {
        requirement: req,
        usecases: linked_issues(req, 'USECASE'),
        screen_designs: linked_issues(req, '화면설계'),
        program_designs: linked_issues(req, '프로그램설계'),
        unit_tests: linked_issues(req, '단위테스트'),
        integration_tests: linked_issues(req, '통합테스트')
      }
      [req.id, trace]
    end.to_h
  end

  def linked_issues(issue, tracker_name)
    issue.relations.select do |rel|
      rel.other_issue(issue).tracker.name == tracker_name
    end.map { |rel| rel.other_issue(issue) }
  end
end
