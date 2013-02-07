# Absztrakt ososztály a szerepeknek.
# 
# Az inner_check metodust kell felul irni, hogy megtortenjen a
# szerepkor ellenorzese
class ActingRole
  # a csoport, amire a szerep vonatkozik
  # ha nil, akkor a szerepkor globalisnak tekintendo
  attr_accessor :group

  # az eppen aktualis
  attr_accessor :user

  def initialize(user, group)
    self.group = group
    self.user = user
  end

  # a szerepkor neve
  def name
    raise "this method should return the name of the role as a symbol"
  end

  # A leszarmazott osztalyokban ez a metodus vegzi az ellenorzest,
  # hogy az adott szerepkorrel rendelkezo user tenyleg mit tehet meg a
  # rendszerben
  #
  # @param  action [Symbol] amit csinalni szeretnenk az eroforrssal
  # @param  resources [Object] az az eroforras, amit ellenorzunk
  # @param  group [Group] a kor, amihez kapcsolodik az eroforras/akcio
  # 
  # @return [true, false] true-val ter vissza, ha az adott szerepkor
  def check(action, resource, group)
    return false unless valid_group?(group)
    inner_check(action, resource)
  end

  # fel kell definialni a leszarmazottakban. eldonti, hogy az adott
  # szerepkor csak egy korre, vagy az teljes rendszerre vonatkozik
  def global?; end

  # egy uj szerepkort regisztral a kozponti tarba
  def self.register_role(role, klass = self)
    @@roles ||= {}
    @@roles[role] = klass
    role
  end

  # egy olyan role peldannyal ter vissza, ami mar kepes
  # ellenorizni, hogy a usernek van-e jogosultsaga valamire vagy nincs
  def self.create_role(role, user, group = nil)
    @@roles ||= {}

    # if there's no registered role, instantiate self and 
    # therefore ignore all requests to every action/resource
    role_class = @@roles[role] || self
    role_class.new user, group
  end

  def self.roles
    @@roles.keys
  end

  # visszaadja a regisztralt ures role peldanyokat
  # ez azt jelenti, hogy olyan szerepeket, amikben nincs megadva a user es
  # a group, tehat ezeket kesobb kell beallitani, ha szukseges
  def self.empty_roles
    roles = []
    @@roles.each { |_,v| roles << v.new(nil, nil) }
    roles
  end

protected 

  def valid_group?(group)
    if !global?
      self.group == group
    else
      # if it is a global role, group should not
      # be taken into account
      true
    end
  end

  # ezt a metodust kell felul irni a leszarmazottakban
  # eldonti, hogy az adott muvelet vegrehajthato-e az adott eroforrason
  # true-t vagy false-t adjon vissza
  def inner_check(action, resource)
    false
  end

end

class NotAuthorized < StandardError; end