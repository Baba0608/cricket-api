class MatchInviteSerializer
  def initialize(match_invites, team)
    @match_invites = match_invites
    @team = team
  end

  def call
    {
      sent_invites: serialize_sent_invites,
      received_invites: serialize_received_invites
    }
  end

  private

  def serialize_sent_invites
    @match_invites.select { |invite| invite.invite_by_team_id == @team.id && invite.status == "pending" }
                  .map do |invite|
      {
        match_invite_id: invite.id,
        status: invite.status,
        team: serialize_team(invite.receiving_team)
      }
    end
  end

  def serialize_received_invites
    @match_invites.select { |invite| invite.receive_by_team_id == @team.id && invite.status == "pending" }
                  .map do |invite|
      {
        match_invite_id: invite.id,
        status: invite.status,
        team: serialize_team(invite.inviting_team)
      }
    end
  end

  def serialize_team(team)
    {
      id: team.id,
      name: team.name
    }
  end
end
