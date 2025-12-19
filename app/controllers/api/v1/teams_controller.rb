class Api::V1::TeamsController < ApplicationController
  before_action :set_team, only: %i[ update ]


  # POST /teams
  def create
    @team = current_player.teams.build(team_params)
    if @team.save
      render json: @team, status: :created
    else
      render json: @team.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /teams/1
  def update
    if current_player.teams.first.id != params[:id].to_i
      return render json: { errors: [ "Team id is not matching with current user's team_id" ] }, status: :unprocessable_content
    end

    if @team.update(team_params)
      render json: @team
    else
      render json: @team.errors, status: :unprocessable_content
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.expect(team: [ :name ])
    end
end
