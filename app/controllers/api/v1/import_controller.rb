class Api::V1::ImportController < Api::V1::ApiController
  def users
    if validate_file_format(params[:file])
      import_user(params[:file])
    else
      render_invalid_file_format
    end
  end

  private

  def validate_file_format(file)
    file.content_type
        .in?(%w[application/vnd.openxmlformats-officedocument.spreadsheetml.sheet text/csv])
  end

  def render_invalid_file_format
    render json: { error: I18n.t('errors.import.invalid_file_format') },
           status: :unprocessable_entity
  end

  def import_user(file)
    UserImportService.new(file).call
    render status: :created
  rescue StandardError
    render_unexpected_error
  end

  def render_unexpected_error
    render json: { error: I18n.t('errors.import.unexpected_error') },
           status: :unprocessable_entity
  end
end
