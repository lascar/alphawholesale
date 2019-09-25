class SupplierPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    @user.class.name == "Broker"
  end

  def show?
    record == user or @user.class.name == "Broker"
  end

  def create?
    @user.class.name == "Broker"
  end

  def new?
    @user.class.name == "Broker"
  end

  def update?
    @user.class.name == "Broker"
  end

  def edit?
    @user.class.name == "Broker"
  end

  def destroy?
    @user.class.name == "Broker"
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
