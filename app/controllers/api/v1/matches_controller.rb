class Api::V1::MatchesController < ApplicationController
  before_action :set_match, only: %i[ show update destroy ]

  # GET /matches
  def index
    @matches = Match.all

    render json: @matches
  end

  # GET /matches/1
  def show
    render json: @match
  end

  # POST /matches
  def create
    @match = Match.new(match_params)

    if @match.save
      render json: @match, status: :created, location: @match
    else
      render json: @match.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /matches/1
  def update
    if @match.update(match_params)
      render json: @match
    else
      render json: @match.errors, status: :unprocessable_content
    end
  end

  # DELETE /matches/1
  def destroy
    @match.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def match_params
      params.expect(match: [ :team_a_id, :team_b_id, :toss_won_by_team_id, :toss_won_by_team_choose_to, :winner_team_id, :won_by_runs, :won_by_wickets ])
    end
end
