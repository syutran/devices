module FlashesHelper
  FLASH_CLASSES = { alert: "danger", notice: "success", warning: "warning"}.freeze

  def flashes_class(key)
    FLASH_CLASSES.fetch key.to_sym, key
  end

end
