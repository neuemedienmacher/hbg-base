class Offerstamp
  def self.generate_stamp current_section, offer
    # filter target_audience array to only include those of the current_section
    target_audience_for_section = offer._target_audience_filters.select { |ta| ta.index(current_section) == 0 }
    # (.......)
    if !target_audience_for_section[0] && current_section == 'refugees'
      target_audience_for_section[0] = 'refugees_general'
    end
    # return with error if there is none => wrong target_audience_filters set
    # return 'missing correct target_audience!!' unless target_audience_for_section[0]
    # generate frontend stamp
    generate_offer_stamp current_section, offer, target_audience_for_section[0]
  end

  private_class_method

  def self.generate_offer_stamp current_section, offer, ta
    locale_entry = 'offer.stamp.target_audience' + ".#{ta}"
    stamp = I18n.t('offer.stamp.target_audience.prefix')

    if ta == 'family_children'
      locale_entry += stamp_family_children offer
    elsif ta == 'family_parents'
      locale_entry += stamp_family_parents offer
    elsif ta == 'family_nuclear_family'
      locale_entry += stamp_family_nuclear_family offer
    end

    append_age = offer.age_visible && stamp_append_age(offer, ta)
    child_age = stamp_child_age offer, ta

    stamp += I18n.t(locale_entry)
    if append_age && !offer._age_filters.empty?
      stamp += generate_age_for_stamp offer._age_filters[0], offer._age_filters.last, child_age ? "#{I18n.t('offer.stamp.age.of_child')} " : '', current_section
    end
    stamp
  end

  def self.stamp_child_age offer, ta
    ta == 'family_children' && offer.gender_second_part_of_stamp.nil?
  end

  def self.stamp_append_age offer, ta
    puts ta
    puts offer.gender_first_part_of_stamp
    puts offer.gender_second_part_of_stamp

    ta != 'family_nuclear_family' || !offer.gender_first_part_of_stamp.nil? ||
    !offer.gender_second_part_of_stamp.nil?
  end

  def self.stamp_family_children offer
    if !offer.gender_first_part_of_stamp.nil?
      ".#{offer.gender_first_part_of_stamp}"
    elsif offer.age_from >= 14 && offer.age_to >= 14
      '.adolescents'
    elsif offer.age_from < 14 && offer.age_to >= 14
      '.and_adolescents'
    else
      '.default'
    end
  end

  def self.stamp_family_parents offer
    if !offer.gender_first_part_of_stamp.nil? && !offer.gender_second_part_of_stamp.nil?
      ".#{offer.gender_first_part_of_stamp}.#{offer.gender_second_part_of_stamp}"
    elsif !offer.gender_first_part_of_stamp.nil?
      # child_age.replace(true)
      ".#{offer.gender_first_part_of_stamp}.default"
    else
      # child_age.replace(true)
      '.default'
    end
  end

  def self.stamp_family_nuclear_family offer
    if !offer.gender_first_part_of_stamp.nil? && !offer.gender_second_part_of_stamp.nil?
      ".#{offer.gender_first_part_of_stamp}.#{offer.gender_second_part_of_stamp}"
    elsif !offer.gender_first_part_of_stamp.nil?
      ".#{offer.gender_first_part_of_stamp}.default"
    elsif !offer.gender_second_part_of_stamp.nil?
      ".special_#{offer.gender_second_part_of_stamp}"
    else
      # append_age.replace(false)
      '.default'
    end
  end

  def self.generate_age_for_stamp from, to, prefix, current_section
    age_string =
      prefix +
      if from == 0
        "#{I18n.t('offer.stamp.age.to')} #{to}"
      elsif to == 99 || current_section == 'family' && to > 17
        "#{I18n.t('offer.stamp.age.from')} #{from}"
      elsif from == to
        from.to_s
      else
        "#{from} - #{to}"
      end
    " (#{age_string} #{I18n.t('offer.stamp.age.suffix')})"
  end
end
