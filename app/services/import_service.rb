class ImportService
  def initialize(file)
    @file = file
  end

  def call
    return unless @file.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'

    process_file
  end

  def get_data(headers, row)
    data = {}

    headers.each_with_index do |column, i|
      column = column.to_s
      data[column] = row[i].is_a?(Float) ? row[i].to_i.to_s : row[i].to_s
    end

    data
  end
end
