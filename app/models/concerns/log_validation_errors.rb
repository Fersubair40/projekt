module LogValidationErrors
  extend ActiveSupport::Concern

  included { after_validation :log_errors, if: proc { |m| m.errors } }

  def log_errors
    Rails.logger.debug "Validation failed!\n" +
                         errors.full_messages.map { |i| " - #{i}" }.join("\n")
  end
end
