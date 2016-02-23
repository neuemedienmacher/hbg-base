class OfferObserver < ActiveRecord::Observer
  def after_initialize offer
    if offer.new_record?
      offer.expires_at ||= (Time.zone.now + 1.year)
      offer.logic_version_id = LogicVersion.last.id
    end
  end

  def after_save offer
    offer.generate_translations!
  end

  def before_create offer
    return if offer.created_by
    current_user = ::PaperTrail.whodunnit
    offer.created_by = current_user if current_user.is_a? Integer # so unclean
  end
end
