class Api::V1::MatchInvitesController < ApplicationController
  before_action :set_match_invite, only: %i[ accept reject ]

  def accept
  end

  def reject
  end

  private
    def set_match_invite
      @match_invite = MatchInvite.find(params[:id])
    end
end
