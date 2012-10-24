require 'faraday'
require 'multi_json'
require 'terminal-table'

class GameSeekCLI
  def initialize(host)
    @host = host || 'localhost:3000'
  end

  def list
    conn = Faraday.new(:url => "http://#{host}")
    resp = conn.get '/api/survey_responses.json'
    array_of_attrs = MultiJson.load resp.body
    if array_of_attrs.any?
      rows = [['Person', 'Platform', 'Genre', 'Price Range', 'Games']]
      rows << :separator
      array_of_attrs.each do |attrs|
        prices = [attrs['min_price'], attrs['max_price']].map { |price| price ? "$#{price}" : 'any' }
        first_game = attrs['games'].shift

        # game_list = attrs['games'].join ', '
        rows << [attrs['person_name'], attrs['platform'], attrs['genre'], prices.join(' to '), first_game]
        attrs['games'].each do |game|
          rows << [nil, nil, nil, nil, game]
        end
        rows << :separator unless array_of_attrs[-1] == attrs
      end
      Terminal::Table.new(:rows => rows).to_s
    else
      'No surveys have been taken.'
    end
  end

  private

  attr_reader :host
end