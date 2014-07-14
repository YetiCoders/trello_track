class CardsFilter
  def self.apply_user_filter(user, cards, cards_info)
    return cards if user.settings.nil?

    cards_filter = user.settings["cards_filter"] || nil
    filter_type = user.settings["cards_filter_type"] || nil
    return cards if cards_filter.nil? || filter_type.nil?

    if filter_type == "include"
      return CardsFilter.include_filter(cards, cards_info, cards_filter)
    elsif filter_type == "exclude"
      return CardsFilter.exclude_filter(cards, cards_info, cards_filter)
    end
  end

  def self.include_filter(cards, cards_info, words)
    filtered_cards = []

    cards.each do |card|
      words.each do |word|
        if cards_info[card.list_id].name =~ /#{word}/i
          filtered_cards << card
          break
        end
      end
    end

    filtered_cards
  end

  def self.exclude_filter(cards, cards_info, words)
    filtered_cards = []

    cards.each do |card|
      exclude = false
      words.each do |word|
        exclude = true if cards_info[card.list_id].name =~ /#{word}/i
      end
      filtered_cards << card unless exclude
    end

    filtered_cards
  end
end