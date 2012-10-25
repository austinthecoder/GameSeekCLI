require 'faraday'
require 'multi_json'
require 'terminal-table'

class GameSeekCLI
  def initialize(host)
    @host = host || 'localhost:3000'
  end

  def list
    array_of_attrs = MultiJson.load game_seek_api.get('/api/survey_responses.json').body
    if array_of_attrs.any?
      render_survey_response_table array_of_attrs
    else
      'No surveys have been taken.'
    end
  end

  def remove_game(id)
    case game_seek_api.delete("/api/games/#{id}").status
    when 204
      "Game was removed."
    when 404
      "Game doesn't exist."
    else
      "Unknown error."
    end
  end

  private

  def game_seek_api
    Faraday.new :url => "http://#{host}"
  end

  def render_survey_response_table(array_of_attrs)
    rows = [['Person', 'Platform', 'Genre', 'Price Range', 'Games']]
    rows << :separator
    array_of_attrs.each do |attrs|
      prices = [attrs['min_price'], attrs['max_price']].map { |price| price ? "$#{price}" : 'any' }
      first_game = attrs['games'].shift
      rows << [attrs['person_name'], attrs['platform'], attrs['genre'], prices.join(' to '), first_game]
      attrs['games'].each do |game|
        rows << [nil, nil, nil, nil, game]
      end
      rows << :separator unless array_of_attrs[-1] == attrs
    end
    Terminal::Table.new(:rows => rows).to_s
  end

  attr_reader :host
end