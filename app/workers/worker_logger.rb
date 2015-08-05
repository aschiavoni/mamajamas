module WorkerLogger
  def log(msg)
    Rails.logger.info "#{self.class.name}: #{msg}"
  end
end
