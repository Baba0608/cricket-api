class PlayerSearch
  def initialize(params, current_player:)
    @query = params[:q]&.strip
    @player_name = params[:player_name]&.strip
    @player_unique_id = params[:player_unique_id]&.strip
    @team_name = params[:team_name]&.strip
    @current_player = current_player
  end

  def call
    players = Player.all

    # exclude current player and friends
    players = exclude_current_player(players)
    players = exclude_friends(players)

    # search all fields if query is present
    if @query.present?
      players = search_all_fields(players, @query)
    else
      # filter by name, unique id, and team name if present
      players = filter_by_name(players) if @player_name.present?
      players = filter_by_unique_id(players) if @player_unique_id.present?
      players = filter_by_team_name(players) if @team_name.present?
    end

    players.distinct
  end

  private

  def search_all_fields(players, query)
    pattern = "%#{sanitize_like(query)}%"

    players
      .left_joins(:teams)
      .where(
        players_table[:name].matches(pattern)
          .or(players_table[:unique_id].matches(pattern))
          .or(teams_table[:name].matches(pattern))
      )
  end

  def filter_by_name(players)
    players.where(players_table[:name].matches("%#{sanitize_like(@player_name)}%"))
  end

  def filter_by_unique_id(players)
    players.where(players_table[:unique_id].matches("%#{sanitize_like(@player_unique_id)}%"))
  end

  def filter_by_team_name(players)
    players
      .left_joins(:teams)
      .where(teams_table[:name].matches("%#{sanitize_like(@team_name)}%"))
  end

  def players_table
    Player.arel_table
  end

  def teams_table
    Team.arel_table
  end

  def sanitize_like(value)
    ActiveRecord::Base.sanitize_sql_like(value)
  end

  def exclude_current_player(players)
    players.where.not(id: @current_player.id)
  end

  def exclude_friends(players)
    friend_ids = @current_player.friends.pluck(:id)
    players.where.not(id: friend_ids)
  end
end
