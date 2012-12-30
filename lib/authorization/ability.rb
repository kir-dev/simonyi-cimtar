class Ability
  include CanCan::Ability

  ABILITIES = %w( create read update destroy manage ).map(&:to_sym)

  def initialize(user)
    # for the time being not authenticated users cannot do anything
    return if user.blank?

    @user = user

    # by default everybody can read everything
    can :read, :all

    setup_group_abilities

    # admin is god
    can :manage, :all if user.admin?
  end

  # sets up all the abilities corresponding to groups
  def setup_group_abilities
    ABILITIES.each { |a| set_group_ability a }
  end

private

  def set_group_ability(ability)
    can ability, Group do |group|
      posts = @user.posts_in_group group
      posts.map(&:permissions).flatten.any? { |perm| perm.resource == "group" && perm.ability == ability }
    end
  end  

end
