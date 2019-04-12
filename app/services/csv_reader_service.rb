require 'csv'

# Allows to load sync data from CSV to ActiveRecord Model
# How to use
#   CSVReaderService.new(FILE_PATH).sync(Model) do |configuration|
#     configuration.column_target['product_name'] = :name
#     configuration.column_target['barcode'] = :barcode
#     configuration.column_target['photo_url'] = :photo_url
#     configuration.column_target['price_cents'] = :price_cents
#     configuration.column_target['sku (unique id)'] = :sku
#     configuration.column_target['producer'] = :producer
#     configuration.identify_by = :sku
#   end
class CSVReaderService
  attr_reader :csv_path
  attr_reader :configuration
  attr_reader :field_disposition

  def initialize(csv_path)
    @csv_path = csv_path
    @configuration = OpenStruct.new(
      column_target: {},
      identify_by: '',
      logger: Logger.new(STDOUT),
      error: ''
    )
    @column_disposition = {}
  end

  def sync(subject)
    yield configuration
    iterator = CSV.foreach(csv_path)
    return unless update_configuration(iterator.next)

    loop { sync_row(subject, iterator.next) } # use loop here because we took header as a first line
  rescue StopIteration
    configuration.logger.info("File #{csv_path} has been processed")
  end

  private

  def update_configuration(header)
    if configuration.identify_by.blank?
      configuration.logger.error('It impossible to continue without "identify_by" configured')
      return false
    end
    read_header(header)
  end

  def read_header(header)
    @field_disposition = {}
    header.each_with_index do |name, index|
      configuration.column_target[name.strip].tap do |attribute_name|
        next unless attribute_name.present?

        field_disposition[attribute_name] = index
      end
    end
    if field_disposition[configuration.identify_by].present?
      true
    else
      configuration.logger.error("CSV header doesn`t contain field #{configuration.identify_by}")
      false
    end
  end

  def sync_row(subject, row)
    subject.find_by(configuration.identify_by => row_identity(row)).tap do |item|
      if item.present?
        update_item(item, row)
      else
        create_item(subject, row)
      end
    end
  end

  def update_item(item, row)
    item.assign_attributes(row_attributes(row))
    if item.save
      configuration.logger.info("[#{row_identity(row)}] Has been successfully imported")
    else
      configuration.logger.error("[#{row_identity(row)}] Import Errors: #{item.errors.to_json}")
    end
  end

  def create_item(subject, row)
    subject.create(row_attributes(row)).tap do |item|
      if item.new_record?
        configuration.logger.error("[#{row_identity(row)}] Import Errors: #{item.errors.to_json}")
      else
        configuration.logger.info("[#{row_identity(row)}] Has been successfully imported")
      end
    end
  end

  def row_attributes(row)
    field_disposition.map do |attribute_name, row_index|
      [attribute_name, row[row_index]]
    end.to_h
  end

  def row_identity(row)
    row[field_disposition[configuration.identify_by]]
  end
end
