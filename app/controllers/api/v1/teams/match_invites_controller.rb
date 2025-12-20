class Api::V1::Teams::MatchInvitesController < ApplicationController
  # POST teams/:team_id/match_invites
  def create
    team = Team.find(params[:team_id])

    @match_invite = team.sent_match_invites.new(
      receive_by_team_id: params.dig(:match_invite, :team_id),
      status: :pending
    )

    if @match_invite.save
      render json: @match_invite, status: :created
    else
      render json: @match_invite.errors, status: :unprocessable_entity
    end
  end

  # GET teams/:team_id/match_invites/sent
  def sent
  end

  # GET teams/:team_id/match_invites/received
  def received
  end

  private
    # Only allow a list of trusted parameters through.
    def match_invite_params
      params.expect(match_invite: [ :invite_by_team_id, :receive_by_team_id, :status ])
    end
end
