class Api::V1::ImportController < Api::V1::ApiController
  def users
    if params[:file].content_type
                    .in?(%w[application/vnd.openxmlformats-officedocument.spreadsheetml.sheet text/csv])
      import_user(params[:file])
    else
      render json: { error: I18n.t('errors.import.invalid_file_format') },
             status: :unprocessable_entity
    end
  end

  private

  def import_user(file)
    UserImportService.new(file).call
    render status: :created
  rescue StandardError
    render json: { error: I18n.t('errors.import.unexpected_error') },
           status: :unprocessable_entity
  end
end
