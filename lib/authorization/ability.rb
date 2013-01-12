# Ennek az osztalynak a josogultsag kezeles a feladata.
# 
# A CanCan ({https://github.com/ryanb/cancan/}) altal biztositott funkcionalitast 
# egesziti ki nemileg. Esetunkben a jogosultsagok nagy resze a kor/csoport ({Group})
# tagsagtol fuggenek. Valamint dinamikusan kell tudni felvenni es torolni jogosultsagokat.
#
# Ennek figyelembe vetelehez nehany kiegeszitest tartalmaz annak eldontese, hogy
# el tudja-e vegezni a felhasznalo az adott tevekenyseget az adott eroforrason.
# 
# Ket fontos metodus van. Az egyuk a #can? ami megmondja, hogy hozzafer-e vagy
# sem az adott eroforrashoz. Opcionalisan atadhato neki egy {Group} objektum is.
# Ekkor ehhez a csoporthoz/korhoz tartozo posztokat veszi alapul.
# 
# Normal esetben a konstruktorban megadott szabalyokat hasznlja. Ezek statikusak.
# Nem vonatkoznak csoport specifikus eroforrasokra. Ezeket a kovetkezo keppen
# lehet tesztelni:
# 
#   ability.can? action, subject
# 
# A csoportokra vonatkozo esetben szinte ugyan ez, csak a csoportot is meg kell adni:
# 
#   ability.can? action, subject, group
# 
# Az #authorize metodusra ugyan ez vonatkozik. A szignaturaja is megegyezik.
# 
class Ability
  include CanCan::Ability

  ABILITIES = %w( read create update destroy manage ).map(&:to_sym)

  # set up basic stuff, that can be easy expressed with cancan
  # *WARNING*: do not set up stuff that requires the presence of a {Group} object
  def initialize(user)
    # for the time being not authenticated users cannot do anything
    return if user.blank?

    @user = user

    # by default everybody can read everything
    can :read, :all
    # by default nobody can do anything
    cannot (ABILITIES - [ :manage, :read ]), :all

    can :update, Member, :id => @user.id
    can :manage, JobPosition, :member_id => @user.id
    can :create, Membership # anybody can join any group

    # admin is god
    can :manage, :all if user.admin?
  end

  # authorize resource, optionally can take a group to check against
  #
  # @param action the action to authorize
  # @param subject the subject
  # @param group the group to authorize against 
  #   (cos stuff is almost always related to groups)
  # 
  # @note overrides the default
  def authorize!(action, subject, group = nil, *args)
    message = nil
    if args.last.kind_of?(Hash) && args.last.has_key?(:message)
      message = args.pop[:message]
    end

    # check cancan rules first -> cancan rules have priorty over user defined rules
    if cannot?(action, subject, *args)
      # check user defined rules
      ability, resource = transform_action_and_subject action, subject
      if group.nil? || !has_permission?(ability, resource, group)
        message ||= unauthorized_message(action, subject)
        raise CanCan::AccessDenied.new(message, action, subject)
      end
    end
    subject
  end

  # Check if the user has permission to perform a given action on an object.
  # optianlly a group can be specified and in that case we'll check the
  # ability against it
  #
  # @note overrides the default
  def can?(action, subject, group = nil, *extra_args)
    result = super(action, subject, *extra_args)

    group = subject if subject.is_a?(Group) && group.nil?

    # if we need to check for group access
    # only check if the first attempt failed to 
    # verify access (that was only a subset)
    if group.present? and not result
      ability, resource = transform_action_and_subject action, subject
      result = has_permission? ability, resource, group
    end
    result
  end

  # Checks if the user has the ability on the given resource for the group
  # @param ability [Symbol] the user's ability
  # @param resource [String] the resource we operate on
  # @param group [Group] the that we check the ability for
  def has_permission?(ability, resource, group)
    posts = @user.posts_in_group group
    posts.map(&:permissions).flatten.any? { |perm| perm.resource == resource && perm.ability == ability }
  end

  # returns a resource name for a given subject
  # TODO: give proper mapping for resources
  def transform_subject_to_resource(subject)
    resource = nil
    resource = subject.name.underscore if subject.is_a?(Class)
    resource ||= subject.class.name.underscore
    resource
  end

  # tries to guess the ability from the given action
  def transform_action_to_ability(action)
    return action if ABILITIES.include? action

    # if its some tricky stuff we try to resolve it
    targets = (aliases_for_action(action) + expand_actions([action])) & ABILITIES
    raise "ambiguous match for #{action} action" if targets.size > 1

    targets.empty? ? nil : targets.first
  end

  # transforms the given subject and action into useable formats
  # we only permit create, read, update, destroy, manage as actions
  # and subjects are 
  # @raise raises an exception if it can't find the ability for 
  #   the action or the resource for the subject
  def transform_action_and_subject(action, subject)
    ability = transform_action_to_ability action
    raise "no alias for #{action}" if ability.blank?

    resource = transform_subject_to_resource subject
    raise "there is no matching resource for #{subject}" if resource.blank?

    return ability, resource
  end

end
