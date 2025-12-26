class Api::V1::MatchInvitesController < ApplicationController
  before_action :set_match_invite, only: %i[ accept reject ]

  def accept
    if @match_invite.accepted? || @match_invite.rejected?
      return render json: { errors: [ "Invite already accepted or rejected" ] }, status: :unprocessable_content
    end

    current_team = current_user.player.teams.first
    team_a_id = @match_invite.invite_by_team_id
    team_b_id = @match_invite.receive_by_team_id

    if team_b_id != current_team.id
      return render json: { errors: [ "You are not allowed to perform this acction", "Only received team can accept the invite" ] }, status: :forbidden
    end

    if @match_invite.update(status: :accepted)
      match = Match.create(team_a_id:, team_b_id:)
      render json: { match: }, status: :created
    else
      render json: { errors: @match_invite.errors }, status: :unprocessable_content
    end
  end

  def reject
    if @match_invite.accepted? || @match_invite.rejected?
      return render json: { errors: [ "Invite already accepted or rejected" ] }, status: :unprocessable_content
    end

    current_team = current_user.player.teams.first
    receiving_team = @match_invite.receive_by_team_id

    if receiving_team != current_team.id
      return render json: { errors: [ "You are not allowed to perform this acction", "Only received team can reject the invite" ] }, status: :forbidden
    end

    if @match_invite.update(status: :rejected)
      render json: { match_invite: @match_invite }
    else
      render json: { errors: @match_invite.errors }, status: :unprocessable_content
    end
  end

  private
    def set_match_invite
      @match_invite = MatchInvite.find(params[:id])
    end
end
