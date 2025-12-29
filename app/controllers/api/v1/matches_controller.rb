class Api::V1::MatchesController < ApplicationController
  before_action :set_match, only: %i[ show update destroy invite_player ]

  # GET /matches
  def index
    @matches = Match.all

    render json: @matches
  end

  # GET /matches/1
  def show
    render json: @match
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

  # POST /matches/1/invite_player
  def invite_player
    current_team = current_user.player&.teams&.first
      return render json: { errors: [ "Please create Profile/Team first to invite players" ] },
                status: :forbidden unless current_team

    team_id = params.dig("match", "team_id")
    player_id = params.dig("match", "player_id")

    if current_team.id != team_id
      return render json: { errors: [ "You can not invite players for other team" ] }, status: :forbidden
    end

    # check if already invited
    if @match.match_player_invites.exists?(team_id: team_id, player_id: player_id)
      return render json: { errors: [ "Player is already invited" ] },
                  status: :unprocessable_entity
    end

    player = Player.find_by(id: player_id)
    unless player
      return render json: { errors: [ "Player is not available" ] },
                    status: :unprocessable_entity
    end

    invite = @match.match_player_invites.build(
      team_id: team_id,
      player_id: player_id,
      status: :pending
    )

    if invite.save
      render json: { match_player_invite: invite }, status: :created
    else
      render json: { errors: invite.errors.full_messages },
            status: :unprocessable_entity
    end
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
