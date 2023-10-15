class ImportService
  def initialize(file)
    @file = file
  end

  def call
    if @file.content_type == 'text/csv'
      process_csv
    elsif @file.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      process_xlsx
    end
  end
end
