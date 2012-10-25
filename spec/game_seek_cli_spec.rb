require 'bundler/setup'
require 'sham_rack'
require_relative '../lib/game_seek_cli'

class MockGameSeekAPI
  attr_accessor :json

  def call(env)
    case env['PATH_INFO']
    when'/api/survey_responses.json'
      [200, {"Content-Type" => "application/json"}, [json]]
    when %r(/api/games/(\d+))
      if $1 == '3475829'
        [204, {"Content-Type" => "text/plain"}, ['']]
      else
        [404, {"Content-Type" => "text/plain"}, ["Record not found"]]
      end
    else
      [404, {"Content-Type" => "text/plain"}, ['Not Found']]
    end
  end
end

describe GameSeekCLI do
  before do
    @game_seek_api = MockGameSeekAPI.new
    ShamRack.mount @game_seek_api, "game-seek.test"

    @game_seek_cli = GameSeekCLI.new('game-seek.test')
  end

  describe "list" do
    context "when the GameSeek API has survey responses" do
      it "prints them in a text-style table" do
        @game_seek_api.json = <<-JSON.strip
[
  {
    "person_name": "Jack Smith",
    "platform": "Xbox 360",
    "genre": "Shooting",
    "min_price": 10,
    "max_price": 50,
    "games": ["Game1", "Game2"]
  },
  {
    "person_name": "Joe Stevens",
    "platform": "PlayStation 3",
    "genre": "Action",
    "min_price": 20,
    "max_price": 40,
    "games": ["Game4", "Game5", "Game6"]
  },
  {
    "person_name": "Sam",
    "platform": "PlayStation 3",
    "genre": "Sports",
    "min_price": null,
    "max_price": 40,
    "games": ["Game8"]
  },
  {
    "person_name": "Taylor",
    "platform": "XBox 360",
    "genre": "Shooting",
    "min_price": null,
    "max_price": null,
    "games": []
  }
]
        JSON

        expect(@game_seek_cli.list).to eq <<-STRING.strip
+-------------+---------------+----------+-------------+-------+
| Person      | Platform      | Genre    | Price Range | Games |
+-------------+---------------+----------+-------------+-------+
| Jack Smith  | Xbox 360      | Shooting | $10 to $50  | Game1 |
|             |               |          |             | Game2 |
+-------------+---------------+----------+-------------+-------+
| Joe Stevens | PlayStation 3 | Action   | $20 to $40  | Game4 |
|             |               |          |             | Game5 |
|             |               |          |             | Game6 |
+-------------+---------------+----------+-------------+-------+
| Sam         | PlayStation 3 | Sports   | any to $40  | Game8 |
+-------------+---------------+----------+-------------+-------+
| Taylor      | XBox 360      | Shooting | any to any  |       |
+-------------+---------------+----------+-------------+-------+
        STRING
      end
    end

    context "when the GameSeek API doesn't have any survey responses" do
      it "prints a nice message" do
        @game_seek_api.json = '[]'
        expect(@game_seek_cli.list).to eq 'No surveys have been taken.'
      end
    end
  end

  describe "remove_game" do
    context "when the game exists" do
      it "returns an informative message" do
        expect(@game_seek_cli.remove_game('3475829')).to eq "Game was removed."
      end
    end

    context "when the game doesn't exist" do
      it "returns an informative message" do
        expect(@game_seek_cli.remove_game('3746825')).to eq "Game doesn't exist."
      end
    end
  end
end