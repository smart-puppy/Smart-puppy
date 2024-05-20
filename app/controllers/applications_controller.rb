class ApplicationsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @per_page = (params[:per_page] || 10).to_i
    query = params[:query]

    if @query.present?
      Rails.logger.debug "Search query: #{@query}"
      search_query = "%#{@query.downcase}%"
      @applications = Application.where('LOWER(title) LIKE :query OR LOWER(company_name) LIKE :query OR LOWER(requirements) LIKE :query OR LOWER(description) LIKE :query OR LOWER(location) LIKE :query', query: search_query)
      Rails.logger.debug "Applications found: #{@applications.count}"
    else
      @applications = Application.all
    end

    @applications = @applications.paginate(page: params[:page], per_page: @per_page)
  end

  def show
  end

  def new
    @application = Application.new
  end

  def create
    @application = Application.new(application_params)
    @application.user = current_user
    if @application.save
      redirect_to jobs_path(@job), notice: 'Application was successfully sent.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def application_params
    params.require(:application).permit(:job_id, :resume_id, :cover_letter_id, :cv_file)
  end
end
