module ProductFetcherLogging
  def logger
    @logger
  end

  def debug(msg)
    logger.debug log_msg(msg)
  end

  def info(msg)
    logger.info log_msg(msg)
  end

  def warn(msg)
    logger.warn log_msg(msg)
  end

  def error(msg)
    logger.error log_msg(msg)
  end

  def log_msg(msg)
    "#{self.class.name}: #{msg}"
  end
end
