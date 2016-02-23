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

    if ta == 'family_children' || ta == 'family_parents' ||
       ta == 'family_nuclear_family'
      locale_entry += send("stamp_#{ta}", offer)
    end
    stamp += I18n.t(locale_entry)

    stamp_add_age offer, ta, stamp, current_section
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
    if !offer.gender_first_part_of_stamp.nil? &&
       !offer.gender_second_part_of_stamp.nil?
      ".#{offer.gender_first_part_of_stamp}.#{offer.gender_second_part_of_stamp}"
    elsif !offer.gender_first_part_of_stamp.nil?
      ".#{offer.gender_first_part_of_stamp}.default"
    else
      '.default'
    end
  end

  # AbcSize is 16.49, just a bit over maximum + this method is not complicated
  # rubocop:disable Metrics/AbcSize
  def self.stamp_family_nuclear_family offer
    if !offer.gender_first_part_of_stamp.nil? &&
       !offer.gender_second_part_of_stamp.nil?
      ".#{offer.gender_first_part_of_stamp}.#{offer.gender_second_part_of_stamp}"
    elsif !offer.gender_first_part_of_stamp.nil?
      ".#{offer.gender_first_part_of_stamp}.default"
    elsif !offer.gender_second_part_of_stamp.nil?
      ".special_#{offer.gender_second_part_of_stamp}"
    elsif offer.age_visible
      '.with_child'
    else
      '.default'
    end
  end
  # rubocop:enable Metrics/AbcSize

  def self.stamp_add_age offer, ta, stamp, current_section
    append_age = offer.age_visible && stamp_append_age(ta)
    child_age = stamp_child_age offer, ta

    if append_age && !offer._age_filters.empty?
      stamp += generate_age_for_stamp(
        offer._age_filters.first,
        offer._age_filters.last,
        child_age ? "#{I18n.t('offer.stamp.age.of_child')} " : '',
        current_section
      )
    end
    stamp
  end

  def self.stamp_append_age ta
    ta != 'family_everyone' && ta != 'refugees_families'
  end

  def self.stamp_child_age offer, ta
    ta == 'family_parents' && offer.gender_second_part_of_stamp.nil?
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
