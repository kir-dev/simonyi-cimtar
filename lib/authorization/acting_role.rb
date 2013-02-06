# Absztrakt ososztály a szerepeknek.
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
  # 
  # @return [true, false] true-val ter vissza, ha az adott szerepkor
  def check(action, resource)
    false
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

end

class NotAuthorized < StandardError; end